//
//  AddSpecialConsumableCard.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 27/01/2021.
//

import Foundation
import SwiftUI
struct addCategorieIcon: View {
   
    var sizes: Int = 10
    #if os(iOS)
    var cornerRadius: CGFloat = 18
    #else
    var cornerRadius: CGFloat = 10
    #endif
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
   
    var customAction : () -> ()
    
    var body: some View {
        Button(action: {
            customAction()
        }) {
            ZStack{
               
           
                    VStack(alignment: .center, spacing: 5) {

                     
                            Image(systemName: "plus")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)

                        
                        Text("New").foregroundColor(Color.primary).fontWeight(.semibold)
                    .frame(width:65, height: 40)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .font(.system(size: 11, design: .rounded))
            
                
                }
               
            

            }
            
        }
        .buttonStyle(SquishableButtonStyle(fadeOnPress: true))
    }
}
struct AddSpecialConsumableCardButton: View {
   
    @State var placeHolderIsActive : Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
   
    #if os(iOS)
    var cornerRadius: CGFloat = 20
    #else
    var cornerRadius: CGFloat = 10
    #endif
    var isCompact : Bool = true
  
    var customAction : () -> ()
    var body: some View {
        Button(action: {
            customAction()
        }) {
          
            VStack{
                
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.white)
                    .aspectRatio(contentMode: .fit)
                    .padding(40)
                    

            }
            .frame(maxWidth:300,maxHeight :300)
            .background(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
            
        }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
        
    }
    
    
    
    
}
struct AddSpecialConsumableCard: View {
   
    @State var placeHolderIsActive : Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
   
    #if os(iOS)
    var cornerRadius: CGFloat = 20
    #else
    var cornerRadius: CGFloat = 10
    #endif
    var isCompact : Bool = true
  
    var body: some View {
        
          
            VStack{
                
                Image(systemName: "plus")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.white)
                    .aspectRatio(contentMode: .fit)
                    .padding(40)
                    

            }
            .frame(maxWidth:300,maxHeight :300)
            .background(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
    
    }
    
    
    
    
}
struct AddToMenuButtons_Previews: PreviewProvider {
    static var previews: some View {
        AddSpecialConsumableCard()
    }
}
