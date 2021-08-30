//
//  AboutView.swift
//  PotLuck
//
//  Created by Sierra Seabrease on 4/30/21.
//
import Foundation
import SwiftUI

struct AboutView: View {
    @State var flipped = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.clear)
                .background(self.flipped ? LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .top, endPoint: .bottom))
                .padding()
                .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                .animation(.default)
                .onTapGesture {
                    self.flipped.toggle()
                }
            if(self.flipped == false) {
                Text("Click For Credits")
            } else {
                VStack{
                    Text("Thanks for checking out our app! This app was brought to you by a group of UMD Students for a CMSC436 Project").multilineTextAlignment(.center)
                    Text("Creators: ")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding()
                    Text("Kurnal Saini")
                    Text("Isha Angadi")
                    Text("Rahul Khanna")
                    Text("Sierra Seabrease")
                }.frame(width: 350, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

