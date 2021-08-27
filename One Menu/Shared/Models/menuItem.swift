//
//  menuItem.swift
//  menuItem
//
//  Created by Jordain on 20/08/2021.
//

import Foundation
import SwiftUI

struct menuItem : Identifiable {
    var id : String
    var title : String
    var subTitle : String
    var type : menuItemType
    var options = [Option]()
    var extras = [Option]()
    var quantity : Int
    var price : Double
    var consumable : Consumable
    
//    static let `default` = menuItem(id : "e" ,title: "Morning Pancakes", subTitle: "A pancake is a flat cake, often thin and round, prepared from a starch-based batter that may contain eggs, milk and butter and cooked on a hot surface such as a griddle or frying pan, often frying with oil or butter.",type: .custom, options: [Option.default, Option.defaultWithoutPrice], extras: [Option.default, Option.defaultWithoutPrice], quantity: 1, price: 15.25, consumable: Consumable)
    
   // static let `all` = [menuItem(consumable: Consumable.default), menuItem.default]
    
}
extension menuItem{
    
    init(consumable: Consumable) {
        self.id = consumable.id
        self.title = consumable.title
        self.subTitle = consumable.title
        self.type = .custom
        self.options = consumable.options.compactMap { option in
            let optionString = option.components(separatedBy: ",€")
            if let optionStringFirst = optionString.first {
                return Option(name: optionStringFirst, price: optionString.last.emptyStr.isEmpty ? "0.00" : optionString.last.emptyStr, enabled: false)
            } else {
                return nil
            }
            
        }
        self.extras = consumable.extras.compactMap { extra in
            let extraString = extra.components(separatedBy: ",€")
            if let extraStringFirst = extraString.first {
                return Option(name: extraStringFirst, price: extraString.last.emptyStr.isEmpty ? "0.00" : extraString.last.emptyStr, enabled: false)
            } else {
                return nil
            }
            
        }
        self.quantity = 1
        self.price = consumable.price
        self.consumable = consumable
    }
    
}

enum menuItemType : String,  Equatable, CaseIterable, Hashable  {
    case standard = "Standard"
    case custom = "Customized"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}


struct Option : Identifiable , Hashable {
    var id : UUID = UUID()
    var name : String
    var price : String
    var enabled : Bool
    
    static let `default` = Option(name: "Extra Eggs", price: "3.25", enabled: false)
    static let `defaultWithoutPrice` = Option(name: "Extra Bacon", price: "3.75", enabled: false)
}
