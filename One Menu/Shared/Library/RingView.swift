//
//  RingView.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 07/08/2020.
//


import SwiftUI

// Usage

//RingView(color1: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), width: 50, height: 50, percent: 78, show: $show)
//.animation(Animation.easeInOut.delay(0.3))
struct RingView: View {
    
    var color1 = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    var color2 = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    var width : CGFloat = 800
    var height : CGFloat = 800
    var percent : CGFloat = 88
    @Binding var show : Bool
    

    var body: some View {
        
        let multiplier = width / 44
        let progress = 1 - (percent / 100)
        
        
        return ZStack {
            
            Circle()
                .stroke(Color.black.opacity(0.1) , style:  StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            
            Circle()
                .trim(from: show ? progress : 1 , to : 1) // Used to set the percentages
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .topTrailing, endPoint: .bottomLeading) ,
                    style: StrokeStyle(lineWidth: 5 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20,0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(
                    Angle(degrees: 180),
                    axis: (x: 1, y: 0, z: 0.0))
                .frame(width: width, height: height)
                .shadow(color: Color(color2).opacity(0.1),radius: 3 * multiplier, x: 0, y: 3 * multiplier)
                
            
            Text("\(Int(percent))%")
                .font(.system(size: 14 * multiplier))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(color1: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), color2: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), width: 44, height: 44, percent: 40, show: .constant(true))
    }
}
