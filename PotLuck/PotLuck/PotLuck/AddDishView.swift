//
//  ContentView.swift
//  AddDishes
//
//  Created by Isha Angadi on 3/14/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

//For capturing an image: Citation on about page
struct CaptureImageView {
    
    /// MARK: - Properties
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

struct Allergy {
    static let allAllergies = [
        "Gluten",
        "Eggs",
        "Peanuts",
        "Tree Nuts",
        "Milk",
        "Other",
        "N/A"
    ]
}

struct Cuisine {
    static let allCuisines = [
        "Italian",
        "Japanese",
        "Chinese",
        "Indian",
        "American",
        "Mediterranean",
        "Other"
    ]
}

struct AddDishView: View {
    
    private var db = Firestore.firestore()
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var recipeName = ""
    @State private var recipeDesc = ""
    @State private var allergies = ""
    @State private var cuisine = ""
    @State private var termsAccepted = false
    //For uploading an image:
    @State var image: UIImage? = nil
    @State var showCaptureImageView: Bool = false
    
    //uploaded alert
    @State private var showingAlert = false
    
    @State private var keyboardOffset: CGFloat = 0
    //Do not forget to update Info.plist -> add row -> privacy - location when in usage description -> add string you want displayed "To submit your dish, we need permission to use your location"
    @ObservedObject var locationViewModel = LocationManager()
    
    // for loading button
    @State var complete: Bool = false
    @State var inProgress: Bool = false
    
    
    var body: some View {
        
        VStack {
            NavigationView {
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image)
                } else{
                    VStack {
                        Form {
                            Section(header: Text("Recipe Information")) {
                                TextField("Recipe Name",
                                          text: $recipeName)
                                
                                TextField("Recipe Description",
                                          text: $recipeDesc)
                                
                                Picker(selection: $cuisine,
                                       label: Text("Cuisine")) {
                                    ForEach(Cuisine.allCuisines, id: \.self) { cuisine in
                                        Text(cuisine).tag(cuisine)
                                    }
                                }
                                
                                Picker(selection: $allergies,
                                       label: Text("Allergies")) {
                                    ForEach(Allergy.allAllergies, id: \.self) { allergies in
                                        Text(allergies).tag(allergies)
                                    }
                                }
                                
                                
                                VStack{
                                    Toggle("Are you located on campus?", isOn: $termsAccepted)
                                    
                                }
                                
                                VStack{
                                    Button(action: {
                                        self.showCaptureImageView.toggle()
                                    }) {
                                        Text("Add a photo")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 300, height: 50)
                                            .background(Color.green)
                                            .cornerRadius(15.0)
                                            .shadow(radius: 10.0, x: 20, y: 10)
                                    }
                                    if(image != nil){
                                        Image(uiImage: image!).resizable()
                                            .frame(width: 250, height: 250)
                                            .clipShape(Rectangle())
                                            .overlay(Rectangle().stroke(Color.green, lineWidth: 4))
                                            .shadow(radius: 10, x:20, y:10)
                                    }
                                }
                            }
                        }.navigationBarTitle(Text("What's cooking?"))
                        AsyncButton(isComplete: complete, action: {
                            if let userid = viewRouter.currentUser?.id {
                                if let coords = locationViewModel.location?.coordinate {
                                    let lat = coords.latitude
                                    let long = coords.longitude
                                    let dish = Dish(id: nil, recipeName: recipeName, recipeDesc: recipeDesc, allergies: allergies, cuisine: cuisine, lat: Float(lat), long: Float(long), url: nil)
                                    do {
                                        var result: DocumentReference? = nil
                                        result = try db.collection("users").document(userid).collection("dishes").addDocument(from: dish) {
                                            err in
                                                if let err = err {
                                                    print("failed", err)
                                                } else {
                                                    if let data = image?.pngData() { // convert your UIImage into Data object using png representation
                                                        FirebaseStorageManager().uploadImageData(data: data, serverFileName: result!.documentID) { (isSuccess, url) in
                                                            db.collection("users").document(userid).collection("dishes").document(result!.documentID).updateData([
                                                                "url": url
                                                            ])
                                                            print("uploadImageData: \(isSuccess)")
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                    catch {
                                        print(error, "dish write failed")
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            complete = true
                                        }
                                    }
                                }
                            }
                        }) {
                            Text(complete || inProgress ? "" : "Add Dish")
                        }
                    }
                }
            }
            .offset(y: -self.keyboardOffset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                       object: nil,
                                                       queue: .main) { (notification) in
                    NotificationCenter.default.addObserver(
                        forName: UIResponder.keyboardDidShowNotification,
                        object: nil,
                        queue: .main) { (notification) in
                        guard let userInfo = notification.userInfo,
                              let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                        
                        self.keyboardOffset = keyboardRect.height
                    }
                                                        
                                                        NotificationCenter.default.addObserver(
                                                            forName: UIResponder.keyboardDidHideNotification,
                                                            object: nil,
                                                            queue: .main) { (notification) in
                                                            self.keyboardOffset = 0
                                                        }
                                                       }
            }
            
        }.background(Color(UIColor.systemGray6))
    }
    
    private func isUserInformationValid() -> Bool {
        if recipeName.isEmpty {
            return false
        }
        
        if !termsAccepted {
            return false
        }
        
        if allergies.isEmpty {
            return false
        }
        
        //could add check to see if the user's location is on campus
        
        return true
    }
    
}


