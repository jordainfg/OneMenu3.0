//
//  NewsRequest.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 25/01/2021.
//

import Foundation
//
//  PartnerRequest.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 10/10/2020.
//

import Foundation
struct NewsRequest: Identifiable , Codable, Hashable{
    var id = UUID()
    var notificationID: String
    var notificationTitle: String
    var notificationSubTitle: String
    var forRestaurant: String
    var forRestaurantID: String
    var isPending: Bool
    init?(dictionary: [String: Any]) {
        guard (dictionary["notificationID"] as? String) != nil else { return nil }
        self.notificationID = dictionary["notificationID"] as! String
        self.notificationTitle = dictionary["notificationTitle"] as! String
        self.notificationSubTitle = dictionary["notificationSubTitle"] as! String
        self.forRestaurant = dictionary["forRestaurant"] as! String
        self.forRestaurantID = dictionary["forRestaurantID"] as! String
        self.isPending = dictionary["isPending"] as! Bool
    }
    

    
}
