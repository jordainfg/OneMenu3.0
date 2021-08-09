//
//  LanguageType.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 26/01/2021.
//

import Foundation

enum collectionName : String{
    case Meals
    case Beverages
    case MealCategories
    case BeveragesCategories

}
enum languageType : String{
    case Dutch
    case English
    
    var categorieOneGroupHeader : String {
        switch self {
        case .Dutch:                return "Categorieën"
        case .English:              return "Categories"
        }
    }
    
    var categorieTwoGroupHeader : String {
        switch self {
        case .Dutch:                return "Dieet restricties"
        case .English:              return "Dietary restrictions"
        }
    }
    
    
    
    var allConsumablesHeader : String {
        switch self {
        case .Dutch:                return "Alle"
        case .English:              return "All"
        }
    }
}
