//
//  PartnerRequest.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 10/10/2020.
//

import Foundation
struct PartnerRequest: Identifiable , Codable{
    var id = UUID()
    var partnerName: String
    var restaurantName: String
    var restaurantAddress: String
    var email: String
    var phoneNumber: String
    
    
    init?(dictionary: [String: Any]) {
        guard (dictionary["partnerName"] as? String) != nil else { return nil }
        self.partnerName = dictionary["partnerName"] as! String
        self.restaurantName = dictionary["restaurantName"] as! String
        self.restaurantAddress = dictionary["restaurantAddress"] as! String
        self.email = dictionary["email"] as! String
        self.phoneNumber = dictionary["phoneNumber"] as! String
       

    }
    

    
}
