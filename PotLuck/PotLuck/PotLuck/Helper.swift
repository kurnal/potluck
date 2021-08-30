//
//  Helper.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 5/1/21.
//

import SwiftUI

enum Page {
    case signIn
    case dashboard
}

struct HelperView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    //Switches pages after successful log in. citation on about page.
    var body: some View {
        switch viewRouter.currentPage {
            case .signIn:
                SignInView()
            case .dashboard:
               MainNavigationView()
        }
    }
}
