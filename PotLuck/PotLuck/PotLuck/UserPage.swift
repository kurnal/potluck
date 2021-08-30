    //
    //  UserProfile.swift
    //  assign3
    //
    //  Created by Rahul Khanna on 5/2/21.
    //
    
    import Foundation
    import SwiftUI
    import FirebaseFirestore
    
    struct UserPage: View {
        
    private var db = Firestore.firestore()
    
    // Add the environment variable here and then query to display values
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var dishesArr: [Dish] = []
    
    func loadDishes() {
        db.collection("users").document(viewRouter.currentUser!.id!).collection("dishes").getDocuments() { (dishes, err) in
            if let err = err {
                print("Error getting user documents: \(err)")
            } else {
                var placeholder: [Dish] = []
                for dish in dishes!.documents {
                    do {
                        let result = try dish.data(as: Dish.self)
                        placeholder.append(result!)
                    } catch {
                        print("parse dish failed")
                    }
                }
                print(placeholder)
                self.dishesArr = placeholder
            }
        }
    }
    
    var body: some View {
        if let user = viewRouter.currentUser {
            ZStack {
                // This will be the background
                LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                VStack {
                    // Display the information
                    VStack(alignment: .center){
                        // Replace "Firstname Lastname" with something like String(format: "%s %s", user.firstname, user.lastname)
                        Text(user.firstname + " " + user.lastname)
                            .font(.title)
                        VStack() {
                            Text(user.username)
                                .font(.subheadline)
                            Text(user.email)
                                .font(.subheadline)
                        }
                        Text("Graduation Year: " + String(format: "%d", user.gradYear))
                            .font(.subheadline)
                        
                    }.padding()
                    // Display dish info here
                    VStack {
                        Text("Current Dishes")
                            .font(.title)
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
                                        }.padding(20)
                                    }
                                }.foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(25)
                                .font(Font.body.weight(.semibold))
                                .padding(.all, 20)
                            }
                        }
                        Button(action:{viewRouter.currentPage = .signIn}){
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }.padding(.top, 50)
                    }.onAppear(perform: loadDishes)
                }
            }
        } else {
            Button(action:{viewRouter.currentPage = .signIn}){
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
        }
    }
    }
    
