//
//  DataStore.swift
//  BaseSwiftUIAPP (iOS)
//
//  Created by Jordain Gijsbertha on 30/07/2020.
//

// MARK: - Documentation
/* The datastore is similar to MVVM, you declare it like the example below. Use:

 1. Declare the datastore as an ObservableObject like bellow
 2. In YOURAPPNAME.swift:
         @main
         struct YOURAPPNAME: App {
            
            let store = DataStore()
     
             var body: some Scene {
                 WindowGroup {
                     ContentView()
                   
                 }
             }
         }
 3. In the view that you're planning to use the object:
    
         @ObservedObject var store : DataStore
         store.varibale
         store.function()
 
 4. NOTE:
 
 Use @ObservedObject when your view is dependent on an observable object that it can create itself, or that can be passed into that view's initializer.
 
 Use @EnvironmentObject when it would be too cumbersome to pass an observable object through all the initializers of all your view's ancestors.
*/
import SwiftUI
import Combine
import Firebase
import FirebaseStorage
import FirebaseFirestore
class DataStore: ObservableObject, Identifiable{
    
    @Published var didScanRestaurant : Bool = false
    @Published var needsToLoadRestaurant: Bool = false
    @Published var restaurantID = ""
    var hasScannedNFCQr = false
    @AppStorage("userSelectedLanguage") var language: String = "en"
    @Published var needsToLoadConsumables: Bool = true
    
    @Published var needsToLoadBeverages: Bool = true
    
    @Published var selectedRestaurant : Restaurant?
    @Published var scannedRestaurant : Restaurant?
    let db = Firestore.firestore()
    let storage = Storage.storage()
    

   
    @Published var Restaurants : [Restaurant] = []

    @Published var consumables : [Consumable] = []
    
    @Published var consumableCategories : [ConsumableCategorie] = []

    @Published var collectionName : collectionName = .Meals
    @Published var languageType : languageType = .Dutch
    init() { // When Datastore is initialized the following functions will be run
        getRestaurants { result in
            print("Got restaurants from Data Store init")
        }
    }
    
    
    func createRestaurant(restaurant : Restaurant,completionHandler: @escaping (Result<Restaurant, CoreError>) -> Void){
        let refRestaurant = db.collection("Restaurants").document()
        let newRestaurant = [
            "restaurantID" : refRestaurant.documentID,
            "name" : restaurant.name,
            "phone" : restaurant.phone,
            "address": restaurant.address,
            "color" : restaurant.color,
            "description": restaurant.description,
            "emailAddress" : restaurant.emailAddress,
            "facebookURL": restaurant.facebookURL,
            "instagramURL": restaurant.instagramURL,
            "websiteURL": restaurant.websiteURL,
            "logoURL": restaurant.logoURL,
            "hours" : restaurant.hours,
            "image": restaurant.image,
            "imageReference" : restaurant.imageReference,
            "messagingTopic": restaurant.messagingTopic,
            "subscriptionPlan": restaurant.subscriptionPlan,
            "isEditing": restaurant.isEditing,
            "hasMultiLanguageSupport" : restaurant.hasMultiLanguageSupport
                                                    ] as [String : Any]
            refRestaurant.setData(newRestaurant) { err in
            if let err = err {
                print("Error: creating new Restaurat document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding booking")))
            } else {
                if let booking = Restaurant(dictionary: newRestaurant) {
                    completionHandler(.success(booking))
                    print("Success: Restaurat created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: omething went wrong when adding booking")))
                }
            }
        }
    }
    
    func getRestaurant(id: String,completionHandler: @escaping (Result<Restaurant, CoreError>) -> Void){
        let docRef = db.collection("Restaurants").document(id)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
               
                if let restaurant = Restaurant(dictionary: document.data()!) {
                completionHandler(.success(restaurant))
                }
            } else {
                print("Document does not exist")
            }
        }
    }

 
    func getRestaurants(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
        
            
            db.collection("Restaurants").whereField("isEditing", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                
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
    
    func getConsumables(collectionName: collectionName,languageType: languageType, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
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
    func createPartnerRequest(request : PartnerRequest,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
        let refRquest = db.collection("Requests").document()
        let newRequest = [
            "partnerName" : request.partnerName,
            "restaurantName" : request.restaurantName,
            "restaurantAddress": request.restaurantAddress,
            "email": request.email,
            "phoneNumber" : request.phoneNumber] as [String : Any]
            refRquest.setData(newRequest) { err in
            if let err = err {
                print("Error: creating new Request document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding Partner Request")))
            } else {
                if PartnerRequest(dictionary: newRequest) != nil {
                    completionHandler(.success(.documentAdded))
                    print("Success: Request created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: something went wrong when adding ConsumableCategorie")))
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

class AppearanceStore: ObservableObject {
    
    @Published var AutoModeIsOn : Bool = UserDefaults.standard.bool(forKey: "AutoModeIsOn")
    

}
class AppState: ObservableObject {
    @Published var moveToDashboard: Bool = false
}
