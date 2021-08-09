//
//  ConsumableCategorie.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 01/02/2021.
//

import Foundation
struct ConsumableCategorie: Identifiable,Codable,Hashable {
    var id :String
    var title: String
    var subtitle: String
    var image: String
    var color: String
    var iconColor: String
    var consumablesByID: [String]
    var consumableSectionGroup : Int
    
    init?(dictionary: [String: Any]) {
        guard (dictionary["title"] as? String) != nil else { return nil }
        self.title = dictionary["title"] as! String
        self.id = dictionary["id"] as! String
        self.subtitle = dictionary["subtitle"] as! String
        self.image = dictionary["image"] as! String
        self.color = dictionary["color"] as! String
        self.iconColor = dictionary["iconColor"] as! String
        self.consumablesByID = dictionary["consumablesByID"] as! [String]
        self.consumableSectionGroup = dictionary["consumableSectionGroup"] as? Int ?? 0
   

    }
    

    
}
