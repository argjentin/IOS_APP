//
//  PartielApp.swift
//  Partiel
//
//  Created by jobst gaetan on 11/12/2023.
//

import SwiftUI

@main
struct PartielApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CompanyViewModel(service: DataService()))
                .environmentObject(UserViewModel(service: DataService()))
                .environmentObject(PlaceViewModel(service: DataService()))
        }
    }
}
