//
//  FirebaseService.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 21/08/2020.
//

import Foundation


import FirebaseStorage
import Firebase
import FirebaseCore
//import FirebaseMessaging

class FirebaseService : NSObject {
    
    
    static let shared = FirebaseService()
    
    func start() {}
    
    var db : Firestore?
    
    func configure(){
        FirebaseApp.configure()
        
        
        db = Firestore.firestore()
        
        Auth.auth().signInAnonymously() { (authResult, error) in
          // ...
            guard let user = authResult?.user else { return }
          
            user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                  // Handle error
                    print("Error getting token for request: \(error.localizedDescription)")
                    
                  return;
                }
                UserDefaults.standard.setValue(idToken, forKey: "token")
                // Send token to your backend via HTTPS
                // ...
              }
            
        }

        
    }
}
