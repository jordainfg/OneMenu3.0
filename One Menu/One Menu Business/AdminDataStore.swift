//
//  DataStore.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 19/11/2020.
//

import SwiftUI

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseStorage
class AdminDataStore: ObservableObject, Identifiable{
  
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    
    @Published var didScanRestaurant : Bool = false
    @Published var needsToLoadRestaurant: Bool = false
    @Published var restaurantID = ""
    var hasScannedNFCQr = false
    
    @Published var language: String = UserDefaults.standard.string(forKey: "userSelectedLanguage") ?? "nl"
    
    
    @Published var needsToLoadBeverages: Bool = true
    
    @Published var selectedRestaurant : Restaurant?
    @Published var scannedRestaurant : Restaurant?
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Published var userID : String = FirebaseService.shared.authenticationState?.user_ID ?? ""
   
    @Published var Restaurants : [Restaurant] = []

    
    @Published var consumables : [Consumable] = []
    
    
    @Published var selectedConsumable : Consumable?
    @Published var selectedConsumableCategorie : ConsumableCategorie?
    @Published var consumableCategories : [ConsumableCategorie] = []
   
    
    @Published var newsRequests : [NewsRequest] = []
    
    @Published var collectionName : collectionName = .Meals
    @Published var languageType : languageType = .Dutch
    
    
    init() { // When Datastore is initialized the following functions will be run
        getRestaurants { result in
            print("Got restaurants from Data Store init")
        }
    }
  
    
    // MARK: - Upload to Firebase Storage
    
    /// Uploads an image to Firebase Storage
    /// - Parameters:
    ///   - imageID: name to indentify the image
    ///   - imageData: imageData description
    ///   - folder: "/RestaurantName/Consumables"  example : "/CarpeDiem/Beverages"
    ///   - completion: Result
    func uploadImage(imageID : String, imageData: Data, folder: String, completionHandler: @escaping (Result<String, CoreError>) -> Void){
        
        let storageRef = storage.reference()
        let uid = imageID
        
        storageRef.child(folder).child(uid).putData(imageData, metadata: nil) { (_, err) in
            
            if err != nil{
                completionHandler(.failure(.unknown))
                return
                
            }
            
            // Downloading Url And Sending Back...
            let refrence  = "\(storageRef.child(folder).child(uid))"
            completionHandler(.success(refrence))
//            storageRef.child(folder).child(uid).downloadURL { (url, err) in
//                if err != nil{
//                    completionHandler(.failure(.badURL))
//                    return
//
//                }
//                if let url = url{
//
//                }
//            }
        }
    }
    
    
    
    
    
    // MARK: - GET
    func getRestaurants(completionHandler: @escaping (Result<Response, CoreError>) -> Void){

            db.collection("Restaurants").whereField("createdByUserID", isEqualTo: FirebaseService.shared.authenticationState?.user_ID ?? "").getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error: Bookings for user documents: \(err)")
                    completionHandler(.failure(.noSuchCollection))
                }
                    
                else {
                    self.Restaurants.removeAll()
                    for document in querySnapshot!.documents {
                        
                        if let restaurant = Restaurant(dictionary: document.data()) {
                         self.Restaurants.append(restaurant)
                        }
                        
                    }
                    
                    print("Success: Restaurants retrieved")
                    completionHandler(.success(.collectionRetrieved))
                    
                    if querySnapshot!.documents.isEmpty{
                        print("Success: Restaurants but isEmpty")
                        completionHandler(.success(.collectionRetrievedButIsEmpty))
                        return
                    }
                }
            }
        
    }
    
    func getConsumables(collectionName: collectionName,languageType: languageType, forRestaurant : String, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
        let path = createPath(collectionName: collectionName,languageType : languageType)
            db.collection(path).getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error: Bookings for user documents: \(err)")
                    completionHandler(.failure(.noSuchCollection))
                }
                    
                else {
                    self.consumables.removeAll()
                    for document in querySnapshot!.documents {
                        
                        if let restaurant = Consumable(dictionary: document.data()) {
                         self.consumables.append(restaurant)
                        }
                        
                    }
                    if querySnapshot!.documents.isEmpty{
                        print("Success: Consumables for user retrieved but isEmpty")
                        completionHandler(.success(.collectionRetrievedButIsEmpty))
                        return
                    }
                    print("Success: Booking for user retrieved")
                    completionHandler(.success(.collectionRetrieved))
                    
                  
                }
            }
        
    }
    
   

    func getConsumableCategories(collectionName: collectionName,languageType: languageType, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
    
        let path = createPath(collectionName: collectionName,languageType : languageType)
            db.collection(path).getDocuments() { (querySnapshot, err) in

                if let err = err {
                    print("Error: ConsumableCategories for user documents: \(err)")
                    completionHandler(.failure(.noSuchCollection))
                }

                else {
                    self.consumableCategories.removeAll()
                    for document in querySnapshot!.documents {

                        if let consumableCategorie = ConsumableCategorie(dictionary: document.data()) {
                         self.consumableCategories.append(consumableCategorie)
                        }

                    }
                    if querySnapshot!.documents.isEmpty{
                        print("Success: ConsumableCategories for user retrieved but isEmpty")
                        completionHandler(.success(.collectionRetrievedButIsEmpty))
                        return
                    }
                    print("Success: ConsumableCategories retrieved")
                    completionHandler(.success(.collectionRetrieved))


                }
            }
    
    }
    
    
    // MARK: - Request
    func createNewsRequestRequest(request : NewsRequest,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
        let refNewsRequest = db.collection("Notification").document()
        let newRequest = [
            "notificationID": refNewsRequest.documentID,
            "notificationTitle" : request.notificationTitle,
            "notificationSubTitle" : request.notificationSubTitle,
            "forRestaurant": request.forRestaurant,
            "forRestaurantID": request.forRestaurantID,
            "isPending": request.isPending] as [String : Any]
        refNewsRequest.setData(newRequest) { err in
            if let err = err {
                print("Error: creating new News Request document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding News Request")))
            } else {
                if NewsRequest(dictionary: newRequest) != nil {
                    completionHandler(.success(.documentAdded))
                    print("Success: News Request created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: something went wrong when adding News Request")))
                }
            }
        }
    }
    
    
    func createPath(collectionName: collectionName,languageType : languageType) -> String{
        if let restaurant = selectedRestaurant{
            
            switch languageType {
            case .Dutch:
                switch collectionName {
                case .Meals:
                    return "Restaurants/\(restaurant.restaurantID)/Maaltijden"
                case .Beverages:
                return "Restaurants/\(restaurant.restaurantID)/Dranken"
                case .MealCategories:
                return "Restaurants/\(restaurant.restaurantID)/MaaltijdCategorieen"
                case .BeveragesCategories:
                return "Restaurants/\(restaurant.restaurantID)/DrankenCategorieen"
                }
            case .English:
                switch collectionName {
                case .Meals:
                    return "Restaurants/\(restaurant.restaurantID)/Meals"
                case .Beverages:
                return "Restaurants/\(restaurant.restaurantID)/Beverages"
                case .MealCategories:
                return "Restaurants/\(restaurant.restaurantID)/MealCategories"
                case .BeveragesCategories:
                return "Restaurants/\(restaurant.restaurantID)/BeverageCategories"
             
                }
           
            }
         
            
        }
        return ""
        
    }
}



// MARK: - AppearanceStore
class AppearanceStore: ObservableObject {
    
    @Published var AutoModeIsOn : Bool = UserDefaults.standard.bool(forKey: "AutoModeIsOn")
    
    
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var moveToDashboard: Bool = false
}
