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
 ContentView().environmentObject(store)
 
 }
 }
 }
 3. In the view that you're planning to use the object:
 
 @EnvironmentObject var store : DataStore
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
class DataStore: ObservableObject, Identifiable{

    @AppStorage("restaurantID") var restaurantID: String = ""
    
    @Published var language: String = UserDefaults.standard.string(forKey: "userSelectedLanguage") ?? "en"
    
    @Published var needsToLoadConsumables: Bool = true
    
    @Published var needsToLoadBeverages: Bool = true
    
    @Published var selectedRestaurant : Restaurant?
    
    //let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    
    // Data For App
    @Published var restaurants : [Restaurant] = []
    
    @Published var restaurant : Restaurant?
    
    @Published var consumables : [Consumable] = []
    

    @Published var consumableCategories : [ConsumableCategorie] = []
    
    @Published var collectionName : collectionName = .Meals
    @Published var languageType : languageType = .Dutch
    init() {
        
    }
    
    let firebaseLogicController = FirestoreLogicController(
        networkController: NetworkController()
    )
    
    var subscriptions = Set<AnyCancellable>()
    
    
    func getRestaurants(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
        firebaseLogicController.getRestaurantAllRestaurants()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    completionHandler(.failure(CoreError.noSuchDocument))
                    print("Couldn't get Restaurants: \(error)")
                case .finished:
                    break
                }
            }) { restaurants in
                self.restaurants = restaurants
                if self.restaurants.count >= 1 {
                    completionHandler(.success(.documentRetrieved))
                } else{
                    completionHandler(.failure(.errorDescription(error: "Restaurants is an empty array")))
                }
            }
            .store(in: &subscriptions)
        
    }
    
    
    func getRestaurant(completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        firebaseLogicController.getRestaurantDocument(id: restaurantID)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    completionHandler(.failure(CoreError.noSuchDocument))
                    print("Couldn't get Restaurants: \(error)")
                case .finished:
                    break
                }
            }) { restaurant in
                self.restaurant = restaurant
                completionHandler(.success(.documentRetrieved))
            }
            .store(in: &subscriptions)
        
    }
    
    
    func getConsumables(collectionName: collectionName,languageType: languageType, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        let endPoint = findEndPoint(restaurantID: restaurantID, collectionName: collectionName, languageType: languageType)
        firebaseLogicController.getRestaurantConsumables(restaurantID: restaurantID, endPoint: endPoint)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    completionHandler(.failure(CoreError.noSuchDocument))
                    print("Couldn't get Consumables: \(error)")
                case .finished:
                    break
                }
            }) { consumables in
                self.consumables = consumables
                if self.consumables.count >= 1 {
                    completionHandler(.success(.documentRetrieved))
                } else{
                    completionHandler(.failure(.errorDescription(error: "Consumables is an empty array")))
                }
            }
            .store(in: &subscriptions)
        
    }
    
 
    
    func getConsumableCategories(collectionName: collectionName,languageType: languageType, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        let endPoint = findEndPoint(restaurantID: restaurantID, collectionName: collectionName, languageType: languageType)
        firebaseLogicController.getRestaurantConsumableCategories(restaurantID: restaurantID, endPoint: endPoint)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case let .failure(error):
                    completionHandler(.failure(CoreError.noSuchDocument))
                    print("Couldn't get ConsumableCategories: \(error)")
                case .finished:
                    break
                }
            }) { consumableCategories in
                self.consumableCategories = consumableCategories
                if self.consumableCategories.count >= 1 {
                    completionHandler(.success(.documentRetrieved))
                } else{
                    completionHandler(.failure(.errorDescription(error: "ConsumableCategories is an empty array")))
                }
            }
            .store(in: &subscriptions)
    }
    
    func findEndPoint(restaurantID: String, collectionName: collectionName,languageType : languageType) -> OneMenuFireStoreEndPoints{
        
        switch languageType {
        case .Dutch:
            switch collectionName {
            case .Meals:
                return .Maaltijden(restaurantID: restaurantID)
            case .Beverages:
                return .Dranken(restaurantID: restaurantID)
            case .MealCategories:
                return .MaaltijdCategorieen(restaurantID: restaurantID)
            case .BeveragesCategories:
                return .DrankenCategorieen(restaurantID: restaurantID)
            }
        case .English:
            switch collectionName {
            case .Meals:
                return .Meals(restaurantID: restaurantID)
            case .Beverages:
                return .Beverages(restaurantID: restaurantID)
            case .MealCategories:
                return .MealCategories(restaurantID: restaurantID)
            case .BeveragesCategories:
            return .BeverageCategories(restaurantID: restaurantID)
         
            }
       
        }
      
    }
    
    
}


class AppClipsState: ObservableObject {
    @Published var moveToRoot: Bool = false
}
