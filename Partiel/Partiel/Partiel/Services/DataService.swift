//
//  DataService.swift
//  Partiel
//
//  Created by jobst gaetan on 08/01/2024.
//

import Foundation

enum DataError: Error{
    case failed
    case failedToDecode
    case invalidStatusCode
    case invalidUserName
}

struct DataService{
    
    let baseUrl = "https://ios-production-608b.up.railway.app/api/"
    
    func fetchUsers() async throws -> [User]{
        
        let endpoint = baseUrl + "users"
        
        guard let url = URL(string: endpoint) else{
            throw DataError.invalidUserName
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw DataError.invalidStatusCode
        }
        
        let decodedData = try JSONDecoder().decode([User].self, from: data)
        
        return decodedData
        
    }
    
    func fetchCompanies() async throws -> [Company]{
        let endpoint = baseUrl + "companies"
        
        guard let url = URL(string: endpoint) else{
            throw DataError.invalidUserName
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw DataError.invalidStatusCode
        }
        
        let decodedData = try JSONDecoder().decode([Company].self, from: data)
        
        return decodedData
        
    }
    
    func fetchPlaces() async throws -> [Place]{
        let endpoint = baseUrl + "places"
        
        guard let url = URL(string: endpoint) else{
            throw DataError.invalidUserName
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw DataError.invalidStatusCode
        }
        
        let decodedData = try JSONDecoder().decode([Place].self, from: data)
        
        return decodedData
        
    }
    
    func fetchUserById(userId: Int) async throws -> User {
        let endpoint = baseUrl + "users/\(userId)"

        guard let url = URL(string: endpoint) else {
            throw DataError.invalidUserName
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode(User.self, from: data)
        return decodedData
    }
    
    func updateUserPlaceId(userId: Int, newPlaceId: Int) async throws {
        
        let endpoint = baseUrl + "users/\(userId)/toggle-place/\(newPlaceId)"

        guard let url = URL(string: endpoint) else {
            throw DataError.invalidUserName
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.invalidStatusCode
        }
    }
    
}
