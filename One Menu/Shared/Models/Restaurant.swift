//
//  Download.swift
//  DesignCodeUniversal
//
//  Created by Jordain Gijsbertha on 19/08/2020.
//

import SwiftUI

struct Restaurant: Identifiable, Hashable,Codable {
    internal init(id: String, restaurantID: String, name: String, description: String, image: String, address: String, emailAddress: String, hours: [String], phone: String, color: String, imageReference: String, facebookURL: String, instagramURL: String, logoURL: String, websiteURL: String, subscriptionPlan: Int, messagingTopic: String, hasMultiLanguageSupport: Bool, isEditing: Bool) {
        self.id = id
        self.restaurantID = restaurantID
        self.name = name
        self.description = description
        self.image = image
        self.address = address
        self.emailAddress = emailAddress
        self.hours = hours
        self.phone = phone
        self.color = color
        self.imageReference = imageReference
        self.facebookURL = facebookURL
        self.instagramURL = instagramURL
        self.logoURL = logoURL
        self.websiteURL = websiteURL
        self.subscriptionPlan = subscriptionPlan
        self.messagingTopic = messagingTopic
        self.hasMultiLanguageSupport = hasMultiLanguageSupport
        self.isEditing = isEditing
    }
    
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
  
    static let `default` = Restaurant(id: "w7dbr9Q7XyAL1IUJskJs", restaurantID: "w7dbr9Q7XyAL1IUJskJs", name: "Number 10", description: "Curaçaos finest hotspot for coffee, breakfast and lunch.", image: "gs://one-menu-40f52.appspot.com/Carpe Diem/image-asset.jpeg", address: "SANTA ROSAWEG 10 - WILLEMSTAD, CURAÇAO", emailAddress: "number10@gmail.com", hours: ["Monday-Thu 12:00am to 6:00pm", "Friday-Sunday 12:00am to 6:00pm"], phone: "0638482214", color: "", imageReference: "gs://one-menu-40f52.appspot.com/Carpe Diem/image-asset.jpeg", facebookURL: "", instagramURL: "", logoURL: "", websiteURL: "", subscriptionPlan: 0, messagingTopic: "test", hasMultiLanguageSupport: false, isEditing: true)
}

