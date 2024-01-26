//
//  ContentView.swift
//  Partiel
//
//  Created by jobst gaetan on 11/12/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @EnvironmentObject var companyViewModel: CompanyViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var placeViewModel: PlaceViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.6384449, longitude: 6.8637375),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State private var selectedLocation: Place?
    @State private var isSheetVisible = false
    @State private var showAlert = false
    
    
    var body: some View {
        NavigationView{
            switch (placeViewModel.state){
            case (.loading) :
                ProgressView()
                
            case (.notAvailable):
                Text("notAvailable")
                
            case (.success(let locationData)):
                ZStack{

                    Map(coordinateRegion: $region, annotationItems: locationData) { item in
                        
                        MapAnnotation(coordinate: item.coordinate) {
                            ZStack(alignment: .center) {
                                Circle()
                                    .foregroundColor(.clear)
                                    .frame(width: 30, height: 30, alignment: .center)
                                Image("point")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        selectedLocation = item
                                    }
                            }
                        }
                    }.ignoresSafeArea()
                    .sheet(item: $selectedLocation){location in
                        PlaceView(currentPlace: location)
                            .environmentObject(userViewModel)
                            .environmentObject(companyViewModel)
                            .presentationDetents([.fraction(0.9)])

                    }
                    .sheet(isPresented: $isSheetVisible, content: {
                        ScrollView {
                            CreateUserView(userViewModel: userViewModel)
                                .environmentObject(userViewModel)
                                .environmentObject(companyViewModel)
                                .presentationDetents([.fraction(0.75), .fraction(0.9)])
                        }
                    })
                    
                    VStack{
                        HStack {
                            Spacer()
                            Button(action: {
                                isSheetVisible.toggle()
                            }) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            }.padding()

                        }
                        Spacer()
                    }
                }
            default:
                Text("Default")
            }
            
        }.task {
            await userViewModel.getUsers()
            await placeViewModel.getPlaces()
            await companyViewModel.getCompanies()
        }.onAppear(){
            userViewModel.getCurrentUserData()
            isSheetVisible.toggle()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CompanyViewModel(service: DataService()))
            .environmentObject(UserViewModel(service: DataService()))
            .environmentObject(PlaceViewModel(service: DataService()))
    }
}
