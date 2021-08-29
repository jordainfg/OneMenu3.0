//
//  MenuItem.swift
//  BaseSwiftUIAPP
//
//  Created by Jordain Gijsbertha on 03/08/2020.
//

import SwiftUI

struct ConsumableCategorieIcon: View {
    var consumableSection: ConsumableCategorie?
    var sizes: Int = 10
    #if os(iOS)
    var cornerRadius: CGFloat = 18
    #else
    var cornerRadius: CGFloat = 10
    #endif
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
   
    
    var body: some View {
       
        ZStack{
           
            if let consumableSection = consumableSection{
                VStack(alignment: .center, spacing: 5) {

                    if horizontalSizeClass == .compact {
                        Image(consumableSection.image)
                            .resizable()
                            .foregroundColor(Color(hexString: consumableSection.iconColor))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(hexString: consumableSection.color))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            
                    } else {
                      
                        Image(consumableSection.image)
                            .resizable()
                            .foregroundColor(Color(hexString: consumableSection.iconColor))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color(hexString: consumableSection.color))
                            
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    }
                     
                            
                    Text(consumableSection.title).foregroundColor(Color.primary)
                        .frame(width:65, height: 40)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        
                        .font(.system(size: 11, design: .rounded))
                        
                        
                        

        
            }
            }
           
        

        }
        
    }
}

struct Beverage_Previews: PreviewProvider {
    static var previews: some View {
        ConsumableCategorieIcon()
    }
}
