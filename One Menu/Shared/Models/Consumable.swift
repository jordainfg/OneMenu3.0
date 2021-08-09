//
//  Consumable.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 01/02/2021.
//

import Foundation

struct Consumable: Identifiable, Hashable,Codable  {
    var id :String
    var consumableID : String
    var headline : String
    var colorTone : String
    var image: String
    var title: String
    var subtitle: String
    var calories:String
    var price : Double
    var currency: String
    var carbs: String
    var carbsPercentage : Int
    var fat: String
    var fatPercentage : Int
    var protein: String
    var proteinPercentage : Int
    var extras : [String]
    var allergens : [String]
    var options : [String]
    var hasExtras : Bool
    var hasOptions: Bool
    var hasNutrition: Bool
    var hasIngredients : Bool
    var isPopular : Bool
    
    init?(dictionary: [String: Any]) {
        guard (dictionary["consumableID"] as? String) != nil else { return nil }
        self.consumableID = dictionary["consumableID"] as! String
        self.id = dictionary["consumableID"] as! String
        self.headline = dictionary["headline"] as! String
        self.colorTone = dictionary["colorTone"] as! String
        self.image = dictionary["image"] as! String
        self.title = dictionary["title"] as! String
        self.subtitle = dictionary["subtitle"] as! String
        self.calories = dictionary["calories"] as! String
        self.price = dictionary["price"] as! Double
        self.currency = dictionary["currency"] as! String
        self.carbs = dictionary["carbs"] as! String
        self.carbsPercentage = dictionary["carbsPercentage"] as! Int
        self.fat = dictionary["fat"] as! String
        self.fatPercentage = dictionary["fatPercentage"] as! Int
        self.protein = dictionary["protein"] as! String
        self.proteinPercentage = dictionary["proteinPercentage"] as! Int
        self.extras = dictionary["extras"] as! [String]
        self.allergens = dictionary["allergens"] as! [String]
        self.options = dictionary["options"] as! [String]
        self.hasExtras = dictionary["hasExtras"] as! Bool
        self.hasOptions = dictionary["hasOptions"] as! Bool
        self.hasNutrition = dictionary["hasNutrition"] as! Bool
        self.hasIngredients = dictionary["hasIngredients"] as! Bool
        self.isPopular = dictionary["isPopular"] as! Bool

    }
    
}
