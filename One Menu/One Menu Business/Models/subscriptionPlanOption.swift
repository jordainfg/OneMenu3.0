//
//  subscriptionPlanOption.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 21/01/2021.
//

import Foundation
import Purchases
struct subscriptionPlanOption:Identifiable,Hashable {
    var id = UUID()
    var name : String
    var price : String
    var features : [String]
    var package : Purchases.Package
}
