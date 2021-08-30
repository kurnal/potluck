//
//  DishView.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 3/13/21.
//

import SwiftUI
import FirebaseFirestore

struct DishView: View {
    
    private var db = Firestore.firestore()
    
    @State private var isLoaderPresented = false
    @EnvironmentObject var locationManager: LocationManager
    @State private var dishesArr: [Dish] = []
    
    func loadDishes() {
        let asyncBlock = DispatchGroup()
        db.collection("users").getDocuments() { (users, err) in
            if let err = err {
                print("Error getting user documents: \(err)")
            } else {
                var placeholder: [Dish] = []
                for document in users!.documents {
                    asyncBlock.enter()
                    db.collection("users").document(document.documentID).collection("dishes").getDocuments() { (dishes, err) in
                        if let err = err {
                            print("Error getting dishes documents: \(err)")
                        } else {
                            for dish in dishes!.documents {
                                do {
                                    let result = try dish.data(as: Dish.self)
                                    placeholder.append(result!)
                                } catch {
                                    print("parse dish failed")
                                }
                            }
                        }
                        asyncBlock.leave()
                    }
                }
                asyncBlock.notify(queue: .main) {
                    print(placeholder)
                    self.dishesArr = placeholder
                    print("Finished all requests.")
                }
            }
        }
    }

    var body: some View {
        VStack {
            MapView().environmentObject(locationManager).frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Button("Refresh", action: {
                self.dishesArr = []
                loadDishes()
            })
            ScrollView {
                ForEach(dishesArr) { dish in
                    VStack {
                        HStack {
                            if let url = dish.url {
                                URLImage(url: url).frame(width: 100, height: 100).padding(20)
                            } else {
                                Circle().frame(width: 100, height: 100).padding(20)
                            }
                            Spacer()
                            VStack {
                                Text("Name: " + dish.recipeName)
                                    .foregroundColor(Color.white)
                                Text("Desc: " + dish.recipeDesc)
                                    .foregroundColor(Color.white)
                                Text("Cuisine: " + dish.cuisine)
                                    .foregroundColor(Color.white)
                                Text("Allergies: " + dish.allergies)
                                    .foregroundColor(Color.white)
                                Button("Accept Dish",
                                    action: { self.isLoaderPresented.toggle() }
                                ).foregroundColor(Color.blue)
                            }.padding(20)
                        }
                    }.foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(25)
                    .font(Font.body.weight(.semibold))
                    .padding(.all, 20)
                }
            }
            Spacer()
        }.onAppear(perform: loadDishes)
        .foregroundColor(.black)
        .tabItem { Label("Pick Up", systemImage: "arrow.up") }
        .popup(isPresented: isLoaderPresented, alignment: .center)
    }
}
