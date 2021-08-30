//
//  SignUpView.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 3/13/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View{
    // Necessary for adjusting background of form
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    private var db = Firestore.firestore()

    // for loading button
    @State var complete: Bool = false
    @State var inProgress: Bool = false
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var username: String = ""
    @State var gradYear: Int = 2021
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    private func addUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("Profile Creation Failed")
            } else {
                let user = User(id: nil, email: email, firstname: firstname, lastname: lastname, username: username, gradYear: gradYear, rating: 0)
                do {
                  let _ = try db.collection("users").addDocument(from: user)
                }
                catch {
                  print(error, "write failed")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        complete = true
                    }
                    viewRouter.currentPage = .signIn
                }
                print("Profile Creation Succeeded")
            }
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Basic Info").foregroundColor(.black)) {
                    TextField("First name", text: $firstname)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    TextField("Last name", text: $lastname)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    Picker(selection: $gradYear, label: Text("Graduation Year")) {
                        ForEach(Years.allYears, id: \.self) {
                            value in Text(String(value)).tag(value)
                        }
                    }
                }
                
                Section(header: Text("Account Info").foregroundColor(.black)) {
                    TextField("Username", text: $username)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    TextField("UMD Email", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    SecureField("Password (8 characters minimum, at least one letter and one number)", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .disableAutocorrection(true)
                        .autocapitalization(UITextAutocapitalizationType.none)
                }
                
                Section(header: Text("Requirements").foregroundColor(.black)) {
                    List {
                        Text("Must be a UMD student")
                        Text("Password must have at least 8 characters with at least one letter and one number")
                    }
                }
            }.navigationBarTitle(Text("Create Account"))


            AsyncButton(isComplete: complete, action: addUser) {
                Text(complete || inProgress ? "" : "Sign Up")
            }
  
        }.background(
            LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
    }
    
    // Input validation
    private func validInfo() -> Bool {
        // Regex for the password
        let password_pattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        if(firstname.isEmpty) {
            return false
        }
        
        if(lastname.isEmpty) {
            return false
        }
        
        if(password.isEmpty || password.matches(password_pattern) == false) {
            return false
        }
        
        if(email.isEmpty || (email.contains("@umd.edu") == false && email.contains("@terpmail.umd.edu") == false)) {
            return false
        }
        
        if(confirmPassword != password) {
            return false
        }
        
        return true
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

struct Years {
    static let allYears = [
        2021,
        2022,
        2023,
        2024,
        2025
    ]
}

// Regex matching method
extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

// Need to create a struct/class for a user after the information has been entered then we would store the users info in a database

