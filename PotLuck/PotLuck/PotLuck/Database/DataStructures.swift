//
//  DataStructures.swift
//  PotLuck
//
//  Created by Kurnal Saini on 5/1/21.
//

import Foundation
import FirebaseFirestoreSwift

class User: Identifiable, Codable, ObservableObject {
    @DocumentID var id: String?
    var email: String
    var firstname: String
    var lastname: String
    var username: String
    var gradYear: Int
    var rating: Float
    
    init(id: String?, email: String, firstname: String, lastname: String, username: String, gradYear: Int, rating: Float) {
        if let id = id {
            self.id = id
        }
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.gradYear = gradYear
        self.rating = rating
    }
}

class Dish: Identifiable, Codable {
    @DocumentID var id: String?
    var recipeName: String
    var recipeDesc: String
    var allergies: String
    var cuisine: String
    var lat: Float
    var long: Float
    var url: String?

    init(id: String?, recipeName: String, recipeDesc: String, allergies: String, cuisine: String, lat: Float, long: Float, url: String?) {
        if let id = id {
            self.id = id
        }
        if let url = url {
            self.url = url
        }
        self.recipeName = recipeName
        self.recipeDesc = recipeDesc
        self.allergies = allergies
        self.cuisine = cuisine
        self.lat = lat
        self.long = long
    }
}
