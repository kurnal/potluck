//
//  MainNavigationView.swift
//  PotLuck
//
//  Created by Kurnal Saini on 5/1/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainNavigationView: View {
    
    private var db = Firestore.firestore() 
    
    @ObservedObject var locationManager = LocationManager()
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    NavigationLink(
                        destination: UserPage()
                    ){
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Image("potluck-cropped")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Spacer ()
                    NavigationLink(destination: AboutView().navigationBarTitle("About Us")){
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }.padding().frame(height: 30)
                
                
                TabView {
                    DishView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .environmentObject(locationManager).tabItem {
                            Image(systemName:"book.fill" )
                            Text("Current Dishes")}
                    AddDishView()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .tabItem {
                            Image(systemName: "plus.circle")
                            Text("Add a New Dish")}
                }
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
