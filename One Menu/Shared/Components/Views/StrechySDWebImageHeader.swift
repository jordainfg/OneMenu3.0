//
//  StrechySDWebImageHeader.swift
//  StrechySDWebImageHeader
//
//  Created by Jordain on 30/08/2021.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI
struct StrechySDWebImageHeader : View{
    
    @State var image : WebImage?
    
    var body : some View{
        VStack(alignment:.center){
            ZStack{
                GeometryReader { geometry in
                    if let image = image{
                        
                        image
                           // .placeholder {PlaceholderImage() }
                            .resizable()
                            .background(Color("grouped"))
                            .scaledToFill()
                            //.overlay(TintOverlay().opacity(0.4))
                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                            //.cornerRadius(20, corners: [.bottomLeft,.bottomRight])
                            .clipped()
                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                    }
                }
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .frame(height:screen.height/4.5 , alignment: .topLeading)
                .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 10)
                
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    // 2
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
}
