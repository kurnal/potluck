//
//  Users.swift
//  PotLuck
//
//  Created by Rahul Khanna on 4/1/21.
//

import Foundation
import SwiftUI

class User {
    var firstname:String
    var lastname:String
    var username:String
    var gradYear:Int
    var email: String
    var password: String
    var dishes: [Dish]
    
    // Constructor for our User, we will store all user info in a SQL database
    init(firstname:String, lastname:String, username:String, gradYear:Int, email: String, password: String, dishes:[Dish]) {
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.gradYear = gradYear
        self.email = email
        self.password = password
        self.dishes = dishes
    }
}
