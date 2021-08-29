//
//  RestaurantRow.swift
//  BaseiOSapp
//
//  Created by Jordain Gijsbertha on 04/08/2020.
//

import SwiftUI

struct RestaurantRow: View {
    var item: Restaurant?
 
    var body: some View {
       VStack(alignment: .leading, spacing:4) {
            HStack(alignment: .center, spacing:5) {
                
                Image("iCAppIcon")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 10)
                    .padding(.trailing,10)
                    .foregroundColor(Color.primaryOne)
                    
                if let restaurant = item {
                VStack(alignment: .leading, spacing: 5) {
                    Text(restaurant.name)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.primary)
                    Text(restaurant.address)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                }
                Spacer()
                
            }
            
            .padding(.vertical,5)
        
  
     }

    }
}

struct RestaurantRow_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRow()
    }
}
