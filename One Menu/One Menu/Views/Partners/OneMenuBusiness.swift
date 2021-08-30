//
//  OneMenuBusiness.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 02/02/2021.
//

import SwiftUI
import Lottie
struct OneMenuBusiness: View {
    var lottie = LottieView(filename: "qrScanAnimation")
   
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ScrollView {
                lottie.frame(width: screen.width - 40 , height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.top,-40)
                HStack {
                    VStack(spacing: 10) {
                        Text("One Menu Business").font(.largeTitle).font(.headline).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("With just a few taps you can have your menu up and running.").font(.headline).foregroundColor(.secondary)
                       
                        Link("Download", destination: URL(string: "https://apps.apple.com/nl/app/one-menu-business/id1550057671?l=en")!)
                        .font(Font.headline.weight(.bold))
                        .buttonStyle(NavigationDrawerPresableButtonStyle(fadeOnPress: true, color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1))))
                        .padding(10)
                        .padding(.trailing,80)
                        
                    }
                    Spacer()
                   
                  
                }.padding()
                
            }
            .navigationBarItems(trailing: CircularButton(systemName:"xmark"){
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct OneMenuBusiness_Previews: PreviewProvider {
    static var previews: some View {
        OneMenuBusiness()
    }
}
