//
//  ContentView.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 3/13/21.
//

import SwiftUI
import Firebase




struct ContentView: View {
    @StateObject var viewRouter = ViewRouter()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        HelperView().environmentObject(viewRouter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
