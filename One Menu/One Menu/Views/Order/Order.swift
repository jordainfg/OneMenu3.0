//
//  Order.swift
//  Order
//
//  Created by Jordain on 20/08/2021.
//

import Foundation
import SwiftUI

struct Order : Identifiable{
    var id : String
    var name : String
    var orderType : orderType
    var status : status
    var forCustomerID : String
    var orderDate : Date
    var subTotal : Double
    var menuItems : [menuItem]
    
    static let `default` = Order(name: "Default test order")
    
}

extension Order {
    init(name: String) {
        self.name = "New order for restaurant"
        id = "s"
        orderType = .pickup
        status = .pending
        forCustomerID = "jordain"
        orderDate = Date()
        subTotal = 0.0
        menuItems = menuItem.all
    }
}

enum orderType : String, Equatable, CaseIterable {
    case pickup = "Pick up"
    case seated = "Dine-in"
    //case delivery
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

enum status : String {
    case dispatched
    case pending
    case canceld
    case completed
    case refunded
}

