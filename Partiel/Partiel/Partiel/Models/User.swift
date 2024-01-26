//
//  User.swift
//  Partiel
//
//  Created by jobst gaetan on 11/12/2023.
//

import Foundation

struct User: Codable, Hashable, Identifiable{
    var id: Int
    var firstname: String
    var lastname: String
    var email: String
    var PlaceId: Int?
    var CompanyId: Int
}
