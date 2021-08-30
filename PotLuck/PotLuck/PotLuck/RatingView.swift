//
//  RatingView.swift
//  PotLuck
//
//  Created by Isha Angadi on 4/30/21.
//

import SwiftUI
import ConfettiSwiftUI

struct RatingView:View{
    @Binding var rating: Int
    @State var counter: Int = 0
    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.green
    
    var body: some View{
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        
        }
        
        //ConfettiSwiftUI Package used to make confetti on clicking the thank you button
        
            Text("Thank you for choosing PotLuck!").contentShape(Rectangle())
                .padding()
                .border(Color.black, width: 2)
                .onTapGesture(){counter += 1}
                ConfettiCannon(counter: $counter)
        
    
    }
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}


