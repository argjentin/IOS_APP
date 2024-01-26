//
//  CompanyViewModel.swift
//  Partiel
//
//  Created by jobst gaetan on 08/01/2024.
//

import Foundation

@MainActor
class CompanyViewModel: ObservableObject{
    enum State{
        case notAvailable
        case loading
        case success(data: [Company])
        case failed(error: Error)
    }
    
    private let service: DataService
    
    @Published var state: State = .notAvailable
    
    var companies: [Company] {
        if case let .success(data: companies) = state {
            return companies
        } else {
            return []
        }
    }
    
    init(service: DataService) {
        self.service = service
    }
    
    func getCompanies() async {
        self.state = .loading
        
        do{
            let followers = try await service.fetchCompanies()
            self.state = .success(data:followers)
        }catch{
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    
}
