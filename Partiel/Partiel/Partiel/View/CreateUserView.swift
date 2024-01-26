//
//  CreateUserView.swift
//  Partiel
//
//  Created by jobst gaetan on 23/01/2024.
//

import SwiftUI

struct CreateUserView: View {
    @ObservedObject var userViewModel: UserViewModel
    @EnvironmentObject var companyViewModel: CompanyViewModel
    @EnvironmentObject var placeViewModel: PlaceViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isCompaniesPickerVisible = false
    @State private var isPlacesPickerVisible = false
    @State private var selectedPlace: Place?
    
    let baseUrl = "https://ios-production-608b.up.railway.app/api/"
    
    var body: some View {
        VStack {
            HStack{
                Text("Prénom : ")
                TextField("Prénom : ", text: $userViewModel.currentUser.firstname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //.padding(.horizontal)
            }.padding(.bottom, 20)
            
            HStack{
                Text("Nom : ")
                TextField("Nom : ", text: $userViewModel.currentUser.lastname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }.padding(.bottom, 20)
            
            
            HStack{
                Text("Email : ")
                TextField("Email : ", text: $userViewModel.currentUser.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }.padding(.bottom, 20)
            
            
            
            Button(action: {
                withAnimation {
                    isCompaniesPickerVisible.toggle()
                    print("isPlacesPickerVisible:", isPlacesPickerVisible)
                }
            }) {
                HStack {
                    Text("Sélectionner une entreprise : ")
                    Spacer()
                    Text(companyViewModel.companies.first { $0.id == userViewModel.currentUser.CompanyId }?.name ?? "")
                        .foregroundColor(Color.black)
                    
                }
            }
            if isCompaniesPickerVisible {
                Picker(selection: $userViewModel.currentUser.CompanyId, label: Text("")) {
                    ForEach(companyViewModel.companies, id: \.id) { company in
                        Text(company.name)
                            .tag(company.id)
                    }
                }.onChange(of: userViewModel.currentUser.CompanyId) { _ in
                    isCompaniesPickerVisible = false
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            Spacer()
            
            Button("Enregistrer") {
                Task {
                    do {
                        try await saveUserToAPI(updatedUser: userViewModel.currentUser)
                        // La mise à jour a réussi, vous pouvez ajouter ici le code pour gérer le résultat dans votre application
                        // Par exemple, mettre à jour votre modèle local, afficher une notification, etc.
                        print("Mise à jour réussie !")
                        
                        // Fermer la Sheet
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // Gérer les erreurs ici
                        print("Erreur lors de la mise à jour : \(error)")
                    }
                }
            }
            .padding()
            .background(Color.blue) // Définir le fond en bleu
            .foregroundColor(Color.white)
            .cornerRadius(10)
    
            }.padding()
            .padding(.top, 30)
    }
    func saveUserToAPI(updatedUser: User) async throws {
        let endpoint = baseUrl + "users/1" // Remplacez 1 par l'id de l'utilisateur que vous souhaitez mettre à jour
        
        guard let url = URL(string: endpoint) else {
            throw DataError.invalidUserName
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(updatedUser)
            request.httpBody = userData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw DataError.invalidStatusCode
            }
            
            // La mise à jour a réussi
            print("Mise à jour réussie !")
            
            
        } catch {
            throw error
        }
    }
}
