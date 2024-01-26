//
//  UserDetailView.swift
//  Partiel
//
//  Created by jobst gaetan on 22/01/2024.
//

import SwiftUI

struct UserDetailView: View {
    var user: User
    @EnvironmentObject var dataCompanies: CompanyViewModel
    @EnvironmentObject var dataPlaces: PlaceViewModel

    
    var company: Company {
        return dataCompanies.companies.first { $0.id == user.CompanyId } ?? Company(id: 0, name: "Unknown Company", description: "random descrpition")
    }
    
    var place: Place {
        return dataPlaces.places.first { $0.id == user.PlaceId } ?? Place(id: 0, longitude: 0.0, latitude: 0.0, name: "Unknown Company", description: "random descrpition")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ID: \(user.id)")
                .font(.title)
                .fontWeight(.bold)
            Text("Prénom: \(user.firstname)")
                .font(.headline)
            Text("Nom: \(user.lastname)")
                .font(.headline)
            Text("Email: \(user.email)")
                .font(.headline)
            Text("Place: \(place.name)")
                .font(.headline)
            Text("Entreprise: \(company.name)")
                .font(.headline)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .navigationBarTitle("\(user.firstname) \(user.lastname)", displayMode: .inline)
    }
}


