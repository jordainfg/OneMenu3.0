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
        Text("\(menuItem.name) ")
        Text(String(format: "%.2f", menuItem.price))
        if menuItem.options.first!.enabled{
            Text("Enabled")
        } else {
            Text("Disabled")
        }
    }
}

//struct itemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        itemRow()
//    }
//}
