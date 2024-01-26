//
//  UserViewModel.swift
//  Partiel
//
//  Created by jobst gaetan on 08/01/2024.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject{
    enum State{
        case notAvailable
        case loading
        case success(data: [User])
        case failed(error: Error)
    }
    
    private let service: DataService
    
    @Published var state: State = .notAvailable
    @Published var currentUser: User = User(id: 1, firstname: "", lastname: "", email: "", PlaceId: 0, CompanyId: 0)
    
    
    init(service: DataService) {
        self.service = service
    }
    
    func getUsers() async {
        self.state = .loading
        
        do{
            let followers = try await service.fetchUsers()
            print(followers)
            self.state = .success(data:followers)
        }catch{
            self.state = .failed(error: error)
            print(error)
        }
    }

    func getUserById(userId: Int) async -> User?{
        do {
            let user = try await service.fetchUserById(userId: userId)
            return user
        } catch {
            return nil
        }
    }
    
    func getCurrentUserData() {
        Task {
            do {
                self.currentUser = try await getUserById(userId: 1) ?? User(id: 1, firstname: "", lastname: "", email: "", PlaceId: 0, CompanyId: 0)
                self.currentUser.firstname = ""
                self.currentUser.lastname = ""
                self.currentUser.email = ""
            } catch {
                print("Erreur lors de la récupération de l'utilisateur : \(error)")
            }
            
        }
    }
    
    func updatePlaceId(userId: Int, newPlaceId: Int) {
        Task {
            do {
                print("view model !")
                try await service.updateUserPlaceId(userId: userId, newPlaceId: newPlaceId)
                self.currentUser = try await getUserById(userId: 1) ?? User(id: 1, firstname: "", lastname: "", email: "", PlaceId: 0, CompanyId: 0)
            } catch {
                print("Erreur lors de la mise à jour du PlaceId : \(error)")
            }
        }
    }
}
