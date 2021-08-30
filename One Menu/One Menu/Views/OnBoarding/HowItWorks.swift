//
//  HowItWorks.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 18/08/2020.
//

import SwiftUI

struct HowItWorks: View {
    var lottie = LottieView(filename: "qrScanAnimation", loopMode: .loop)
    var body: some View {
        VStack {
            
            Text("Howitworks")
                .fontWeight(.black)
                .font(.system(size: 36, design: .rounded))
                .foregroundColor(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                .padding(.bottom)
                
            
                lottie
                .frame(width: screen.width, height: screen.height/2.9)
                .onAppear{
                    lottie.play()
                }
            Text("howDetail")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}

struct HowItWorks_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorks()
    }
}
