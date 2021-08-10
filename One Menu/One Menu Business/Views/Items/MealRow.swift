//
//  ConsumableRow.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 27/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI
struct ConsumableRow: View {
    var item: Consumable?
    @State var image : WebImage?
    var body: some View {
        VStack {
            if let item = item {
                if let image = image{
                    HStack(alignment: .center,spacing:20) {
                        image
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .imageScale(.large)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                        
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text(item.title)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.primary)
                            Text(item.subtitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                        }
                        Spacer()
                    }
                }
            }
            
        }
    }
}
struct AddNewConsumableRow: View {
    
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
            
            VStack {
                HStack(alignment: .center,spacing:20) {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(width: 80, height: 80)
                    .background(Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0.9867780805, green: 0.4486843348, blue: 0.385889709, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text("New")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
            }
        }.buttonStyle(SquishableButtonStyle(fadeOnPress: true))
    }
}

