//
//  Styles.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 10/10/2020.
//

import SwiftUI

import SwiftUI


struct roundedButtonStyle: ButtonStyle {
    
    let color : UIColor
    let shadowColor : UIColor
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color(color))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .shadow(color: Color(shadowColor).opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal,30)
    }
}

extension View{
    
   /*  How to activate: SomeView().cardStyle() * */
    func cardStyle(color: Color, cornerRadius: CGFloat) -> some View {
        return self
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
    }
 
    
    
}
