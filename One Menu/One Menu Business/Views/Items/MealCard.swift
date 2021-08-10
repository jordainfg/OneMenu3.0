//
//  ConsumableCard.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 28/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ConsumableCard: View {
    var consumable: Consumable?
    @State var placeHolderIsActive : Bool = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme
    @State var image : WebImage?
    #if os(iOS)
    var cornerRadius: CGFloat = 20
    #else
    var cornerRadius: CGFloat = 10
    #endif
    var isCompact : Bool = true
   
    var body: some View {
        if let consumable = consumable{
            ZStack{
                if let image = image{
                    image
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.primary)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color("grouped")).onAppear{
                                    placeHolderIsActive = true
                                }
                            
                        }
                        .resizable()
                        .renderingMode(.original)
                        .indicator(.activity)
                        
                        .transition(.fade(duration: 0.5))
                        .frame(maxWidth:300,maxHeight :300)
                        .aspectRatio(contentMode: .fill)
                        .background(placeHolderIsActive ? Color("grouped") : Color.clear)
                    
                }
                
                VStack(alignment: .leading){
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing : 5){
                            Text(consumable.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            
                        }.padding()
                        Spacer()
                    }
                    .frame(maxWidth:300)
                    .background(VisualEffectBlur(blurStyle: colorScheme == .dark ? .dark : .light))
                    
                    
                }
                
            }
            
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color("BlackToNone").opacity(0.2), radius: 10, x: 0, y: 10)
            
        }
        
    }
    
    
    
    
}

struct ConsumableCard_Previews: PreviewProvider {
    static var previews: some View {
        ConsumableCard()
    }
}
