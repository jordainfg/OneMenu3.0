//
//  itemRow.swift
//  itemRow
//
//  Created by Jordain on 17/08/2021.
//

import SwiftUI

struct itemRow: View {
    
    @Binding var menuItem : menuItem
    
    var body: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(menuItem.name).font(.subheadline)
                    Spacer()
                    Text(calculateTotal(menuItem: menuItem)).font(.subheadline).foregroundColor(Color.secondary)
                }
                .padding(.bottom,10)
                
                ForEach(menuItem.options.filter{ $0.enabled == true}, id: \.self) { option in
                    HStack {
                        Text(option.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(option.price)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }.padding(.leading,5)
                }
                
                ForEach(menuItem.extras.filter{ $0.enabled == true}, id: \.self) { extra in
                    HStack {
                        Text(extra.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(extra.price)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
               
               
            }
            .padding()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func calculateTotal(menuItem : menuItem) -> String {
        var grandTotal : Double = menuItem.price
        for option in menuItem.options where option.enabled == true {
            grandTotal += Double(option.price) ?? 00.00
        }
        for extra in menuItem.extras where extra.enabled == true {
            grandTotal += Double(extra.price) ?? 00.00
        }
        
        grandTotal = grandTotal * Double(menuItem.quantity)
        
        return String(format: "%.2f", grandTotal)
        
    }
}

//struct itemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        itemRow()
//    }
//}
