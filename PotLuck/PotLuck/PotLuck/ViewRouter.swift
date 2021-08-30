//
//  ViewRouter.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 5/1/21.
//
import SwiftUI

//To relocate the main page after login, citation on about page
class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .signIn
    @Published var currentUser: User? = nil
    
}
