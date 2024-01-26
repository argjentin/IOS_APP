//
//  LocationViewModel.swift
//  Partiel
//
//  Created by jobst gaetan on 08/01/2024.
//

import Foundation

@MainActor
class PlaceViewModel: ObservableObject{
    enum State{
        case notAvailable
        case loading
        case success(data: [Place])
        case failed(error: Error)
    }
    
    private let service: DataService
    
    @Published var state: State = .notAvailable
    
    var places: [Place] {
        if case let .success(data: places) = state {
            return places
        } else {
            return []
        }
    }
    
    init(service: DataService) {
        self.service = service
    }
    
    func getPlaces() async {
        self.state = .loading
        
        do{
            let places = try await service.fetchPlaces()
            self.state = .success(data:places)
        }catch{
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    
}
