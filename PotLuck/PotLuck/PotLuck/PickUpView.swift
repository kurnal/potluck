//
//  PickUpView.swift
//  PotLuck
//
//  Created by Isha Angadi on 4/30/21.
//

import Foundation
import SwiftUI

struct PickUpView: View {
    @State private var buttonText = "Pick Up Now"
    
    
    var body: some View {
        
        VStack{
            NavigationView {
                ZStack{
                    NavigationLink(destination: RatingView(rating: .constant(4))) {
                        
                        Text(buttonText).font(.headline).foregroundColor(Color.green)
                            .padding()
                            .contentShape(Rectangle())
                            .border(Color.black, width: 2)
                    }
                }
            }
        }
    }
}

