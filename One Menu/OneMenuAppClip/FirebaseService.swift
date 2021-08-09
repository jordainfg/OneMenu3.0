//
//  FirebaseService.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 21/08/2020.
//

import Foundation


import Firebase
import FirebaseCore
//import FirebaseMessaging

class FirebaseService : NSObject {
    
    
    static let shared = FirebaseService()
    
    func start() {}
 
    func configure(){
        FirebaseApp.configure()
        
      
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
    func refreshToken(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        Auth.auth().signInAnonymously() { (authResult, error) in
          // ...
            guard let user = authResult?.user else {
                completionHandler(.failure(CoreError.errorDescription(error: "Error getting token for request")))
                return }
          
            user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                  // Handle error
                    completionHandler(.failure(CoreError.errorDescription(error: "Error getting token for request")))
                    print("Error getting token for request: \(error.localizedDescription)")
                    
                  return;
                }
                print("Succesful token refresh")
                UserDefaults.standard.setValue(idToken, forKey: "token")
                completionHandler(.success(Response.tokenRefreshed))
            
              }
            
        }
    }
}
