//
//  Welcome.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 18/08/2020.
//

import SwiftUI

struct Welcome: View {
    var body: some View {
        VStack {
            Image(uiImage: #imageLiteral(resourceName: "landingPage2"))
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(LocalizedStringKey("Welcome"))
                .fontWeight(.black)
                .font(.system(size: 36, design: .rounded))
            Text("One Menu")
                .fontWeight(.black)
                .font(.system(size: 36, design: .rounded))
                .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                .padding(.bottom)
            Text(LocalizedStringKey("welcomeDescription"))
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }.padding()
        
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
