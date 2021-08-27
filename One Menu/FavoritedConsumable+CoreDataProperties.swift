//
//  FavoritedConsumable+CoreDataProperties.swift
//  FavoritedConsumable
//
//  Created by Jordain on 26/08/2021.
//
//

import Foundation
import CoreData


extension FavoritedConsumable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedConsumable> {
        return NSFetchRequest<FavoritedConsumable>(entityName: "FavoritedConsumable")
    }

    @NSManaged public var consumableID: String
    @NSManaged public var restaurantID: String
    @NSManaged public var isMeal: Bool
    @NSManaged public var id: UUID?

}

extension FavoritedConsumable : Identifiable {

}
