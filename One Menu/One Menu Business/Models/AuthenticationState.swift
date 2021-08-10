//
//  BerryUser.swift
//  ChowTown
//
//  Created by Jordain Gijsbertha on 12/12/2019.
//  Copyright © 2019 Jordain Gijsbertha. All rights reserved.
//

import Foundation


public struct AuthenticationState : Codable {
    
    
    var name: String
    var email: String
    var user_ID: String
    var isAdmin: Bool
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else { return nil }
        self.name = name
        self.email = dictionary["email"] as! String
        self.user_ID = dictionary["user_ID"] as! String
         self.isAdmin = dictionary["isAdmin"] as! Bool
        
    }
    
}
