//
//  SignInView.swift
//  PotLuck
//
//  Created by Rahul Khanna on 4/28/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignInView: View {
    
    private var db = Firestore.firestore()
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var user: User
    
    @State private var email = ""
    @State private var password = ""
    
    // for loading button
    @State var complete: Bool = false
    @State var inProgress: Bool = false
    
    func login() {
        inProgress = true
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                db.collection("users").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        do {
                            let result = try querySnapshot!.documents[0].data(as: User.self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    complete = true
                                }
                                viewRouter.currentUser = result
                                viewRouter.currentPage = .dashboard
                            }
                        } catch {
                            print("no user was queried. which is not right")
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack() {
                Text("Welcome to Potluck")
                    .font(.largeTitle).foregroundColor(Color.white)
                    .padding([.top, .bottom], 40)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: self.$email)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    
                }.padding([.leading, .trailing], 27.5)
                                
                AsyncButton(isComplete: complete, action: login) {
                    Text(complete || inProgress ? "" : "Login")
                }
                
                Spacer()
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                    }
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

