//
//  Download.swift
//  DesignCodeUniversal
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI

struct Restaurant: Identifiable, Hashable,Codable {
    var id : String
    var restaurantID : String
    var name: String
    var description: String
    var image: String
    var address: String
    var emailAddress: String
    var hours: [String]
    var phone : String
    var color : String
    var imageReference : String
    var facebookURL : String
    var instagramURL : String
    var logoURL : String
    var websiteURL : String
    var subscriptionPlan : Int
    var messagingTopic : String
    var hasMultiLanguageSupport : Bool
    var isEditing : Bool
    
    init?(dictionary: [String: Any]) {
        guard (dictionary["restaurantID"] as? String) != nil else { return nil }
        self.restaurantID = dictionary["restaurantID"] as! String
        self.id = dictionary["restaurantID"] as! String
        self.name = dictionary["name"] as! String
        self.description = dictionary["description"] as! String
        self.image = dictionary["image"] as! String
        self.address = dictionary["address"] as! String
        self.emailAddress = dictionary["emailAddress"] as! String
        self.hours = dictionary["hours"] as! [String]
        self.phone = dictionary["phone"] as! String
        self.color = dictionary["color"] as! String
        self.imageReference = dictionary["imageReference"] as! String
        self.facebookURL = dictionary["facebookURL"] as! String
        self.instagramURL = dictionary["instagramURL"] as! String
        self.logoURL = dictionary["logoURL"] as! String
        self.websiteURL = dictionary["websiteURL"] as! String
        self.subscriptionPlan = dictionary["subscriptionPlan"] as! Int
        self.messagingTopic = dictionary["messagingTopic"] as! String
        self.hasMultiLanguageSupport = dictionary["hasMultiLanguageSupport"] as! Bool
        self.isEditing = dictionary["isEditing"] as! Bool
    }
    
    
}

