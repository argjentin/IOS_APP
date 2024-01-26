//
//  PlaceView.swift
//  Partiel
//
//  Created by jobst gaetan on 22/01/2024.
//

import SwiftUI

struct PlaceView: View {
    
    @EnvironmentObject var dataUsers: UserViewModel
    @EnvironmentObject var dataCompanies: CompanyViewModel
    @State private var searchText = ""
    var currentPlace: Place
        
    var body: some View {
        switch dataUsers.state{
            
        case (.loading):
            ProgressView()
            
        case (.notAvailable):
            Text("notAvailable")
            
        case (.success(data: let data)):
            let groupedUsers = Dictionary(grouping: data, by: { $0.CompanyId })
            let companiesDictionary = Dictionary(uniqueKeysWithValues: dataCompanies.companies.map { ($0.id, $0.name) })
            let filteredUsers = data.filter { $0.PlaceId == currentPlace.id }
            NavigationView{
                VStack{
                    Toggle(isOn: Binding(
                        get: {
                            dataUsers.currentUser.PlaceId == currentPlace.id
                        },
                        set: { newValue in
                            dataUsers.updatePlaceId(userId: dataUsers.currentUser.id, newPlaceId: newValue ? currentPlace.id : 0)
                        }
                    )) {
                        VStack {
                            Image(systemName: dataUsers.currentUser.PlaceId == currentPlace.id ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(.white)
                                .background(dataUsers.currentUser.PlaceId == currentPlace.id ? Color.green : Color.red)
                                .clipShape(Circle())
                                .padding(5)
                            
                            Text(dataUsers.currentUser.PlaceId == currentPlace.id ? "Vous êtes ici" : "Vous n'êtes pas ici")
                                .foregroundColor(.primary)
                                .font(.headline)
                        }
                    }
                    .padding()
                    
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    List {
                        ForEach(groupedUsers.keys.sorted(), id: \.self) { companyId in
                            // Filtrer les utilisateurs pour cette entreprise et qui correspondent à la recherche
                            let filteredUsersForCompany = filteredUsers.filter { $0.CompanyId == companyId &&
                                (searchText.isEmpty || $0.firstname.localizedCaseInsensitiveContains(searchText) || $0.lastname.localizedCaseInsensitiveContains(searchText)) }
                            
                            // Afficher la section seulement s'il y a des utilisateurs filtrés pour cette entreprise
                            if let companyName = companiesDictionary[companyId], !filteredUsersForCompany.isEmpty {
                                Section(header: Text("\(companyName)")) {
                                    ForEach(filteredUsersForCompany, id: \.id) { user in
                                        NavigationLink(destination: UserDetailView(user: user)) {
                                            Text("\(user.firstname) \(user.lastname)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle(currentPlace.name)
                }
            }
            
        default:
            Text("Default View")
            
        };
    }
}



struct CompanySum: Identifiable, Codable, Hashable{
    var id: Int
    var name: String
}
