//
//  DataStore+CRUD.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 22/01/2021.
//

import Foundation

extension AdminDataStore{
    func getNewsRequest(forRestaurantID : String, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        
    
            
            db.collection("Notification").whereField("forRestaurantID", isEqualTo: restaurantID).getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error: NewsRequests for user documents: \(err)")
                    completionHandler(.failure(.noSuchCollection))
                }
                    
                else {
                    self.newsRequests.removeAll()
                    for document in querySnapshot!.documents {
                        
                        if let newsRequest = NewsRequest(dictionary: document.data()) {
                         self.newsRequests.append(newsRequest)
                        }
                        
                    }
                    if querySnapshot!.documents.isEmpty{
                        print("Success: NewsRequests retrieved but isEmpty")
                        completionHandler(.failure(CoreError.errorDescription(error: "NewsRequest collection is empty")))
                        return
                    }
                    print("Success: NewsRequest retrieved")
                    completionHandler(.success(.collectionRetrieved))
                    
                  
                }
            }
        
    }
    func deleteNewsRequest(requestNotificationID: String,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
        db.collection("Notification").document(requestNotificationID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completionHandler(.failure(.noSuchDocument))
            } else {
                completionHandler(.success(.documentDeleted))
            }
        }
    }
    
    
    // MARK: - CRUD
    func createRestaurant(restaurant : Restaurant,completionHandler: @escaping (Result<Restaurant, CoreError>) -> Void){
        let refRestaurant = db.collection("Restaurants").document()
        let newRestaurant = [
            "restaurantID" : refRestaurant.documentID,
            "name" : restaurant.name,
            "phone" : restaurant.phone,
            "address": restaurant.address,
            "color" : restaurant.color,
            "createdByUserID": FirebaseService.shared.authenticationState?.user_ID,
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
                if let restaurant = Restaurant(dictionary: newRestaurant) {
                    self.Restaurants.append(restaurant)
                    completionHandler(.success(restaurant))
                    print("Success: Restaurant created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: omething went wrong when adding booking")))
                }
            }
        }
    }
    func showRestaurant(isEditing : Bool){
   
        let refConsumable = db.collection("Restaurants").document(restaurantID)
        refConsumable.updateData([ "isEditing": isEditing])
    }
    
    func deleteRestaurant(restaurant : Restaurant,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
       
      
        db.collection("Restaurants").document(restaurant.restaurantID).delete() { err in
                if let err = err {
                    print("Error: deleting  Restaurant document: \(err)")
                    completionHandler(.failure(.failed(reason: "Something went wrong when deleting Restaurant")))
                } else {
                    if let row = self.Restaurants.firstIndex(where: {$0.restaurantID == restaurant.restaurantID}) {
                        self.Restaurants.remove(at: row)
                    }
                        completionHandler(.success(.documentDeleted))
                        print("Success: Restaurant Deleted")
                  
                }
        }
        
    }
    
    func createConsumable(consumable : Consumable, completionHandler: @escaping (Result<Consumable, CoreError>) -> Void){
        
        let path = createPath(collectionName: collectionName,languageType : languageType)
   
        let refConsumable = db.collection(path).document()
        let newConsumable = [
            "consumableID" : refConsumable.documentID,
            "headline": consumable.headline,
            "colorTone": consumable.colorTone,
            "image": consumable.image,
            "title": consumable.title,
            "subtitle": consumable.subtitle,
            "calories": consumable.calories,
            "price" : consumable.price,
            "currency" : consumable.currency,
            "carbs" : consumable.carbs,
            "carbsPercentage" : consumable.carbsPercentage,
            "fat" : consumable.fat,
            "fatPercentage": consumable.fatPercentage,
            "protein": consumable.protein,
            "proteinPercentage": consumable.proteinPercentage,
            "extras": consumable.extras,
            "allergens": consumable.allergens,
            "options": consumable.options,
            "hasExtras": consumable.hasExtras,
            "hasOptions": consumable.hasOptions,
            "hasNutrition": consumable.hasNutrition,
            "hasIngredients": consumable.hasIngredients,
            "isPopular": consumable.isPopular,
           
            ] as [String : Any]
        refConsumable.setData(newConsumable) { err in
            if let err = err {
                print("Error: creating new Consumable document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding booking")))
            } else {
                if let newConsumable = Consumable(dictionary: newConsumable) {
                    //self.consumables.append(newConsumable)
                    completionHandler(.success(newConsumable))
                    print("Success: Restaurat created")
                } else {
                    completionHandler(.failure(.failed(reason: err?.localizedDescription ?? "unKnown")))
                }
            }
        }
    }
   
    func updateConsumable(consumable : Consumable, completionHandler: @escaping (Result<Consumable, CoreError>) -> Void){
        
        let path = createPath(collectionName: collectionName,languageType : languageType)
   
        let refConsumable = db.collection(path).document(consumable.consumableID)
        let newConsumable = [
            "consumableID" : consumable.consumableID,
            "headline": consumable.headline,
            "colorTone": consumable.colorTone,
            "image": consumable.image,
            "title": consumable.title,
            "subtitle": consumable.subtitle,
            "calories": consumable.calories,
            "price" : consumable.price,
            "currency" : consumable.currency,
            "carbs" : consumable.carbs,
            "carbsPercentage" : consumable.carbsPercentage,
            "fat" : consumable.fat,
            "fatPercentage": consumable.fatPercentage,
            "protein": consumable.protein,
            "proteinPercentage": consumable.proteinPercentage,
            "extras": consumable.extras,
            "allergens": consumable.allergens,
            "options": consumable.options,
            "hasExtras": consumable.hasExtras,
            "hasOptions": consumable.hasOptions,
            "hasNutrition": consumable.hasNutrition,
            "hasIngredients": consumable.hasIngredients,
            "isPopular": consumable.isPopular,
           
            ] as [String : Any]
        refConsumable.setData(newConsumable) { err in
            if let err = err {
                print("Error: Updating Consumable document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when updating consumable")))
            } else {
                if let updateConsumable = Consumable(dictionary: newConsumable) {
                    completionHandler(.success(updateConsumable))
                    print("Success: Consumable Updated")
                } else {
                    completionHandler(.failure(.failed(reason: err?.localizedDescription ?? "unKnown")))
                }
            }
        }
    }
  
    func deleteConsumable(consumable : Consumable, completionHandler: @escaping (Result<Response, CoreError>) -> Void){
       
        let path = createPath(collectionName:  collectionName == .Meals ? .Meals : .Beverages,languageType : languageType)
        db.collection(path).document(consumable.consumableID).delete() { err in
                if let err = err {
                    print("Error: deleting  Restaurant document: \(err)")
                    completionHandler(.failure(.failed(reason: "Something went wrong when deleting Restaurant")))
                } else {
                        completionHandler(.success(.documentDeleted))
                        print("Success: Restaurant Deleted")
                  
                }
        }
        
    }
    
    
    // MARK: - CUD categories
    func createConsumableCategorie(consumableCategorie : ConsumableCategorie,completionHandler: @escaping (Result<ConsumableCategorie, CoreError>) -> Void){
      
        let path = createPath(collectionName: collectionName == .Meals ? .MealCategories : .BeveragesCategories,languageType : languageType)

        let refConsumableCategorie = db.collection(path).document()
        let newConsumableCategorie = [
            "id" : refConsumableCategorie.documentID,
            "title" : consumableCategorie.title,
            "subtitle" : consumableCategorie.subtitle,
            "image": consumableCategorie.image,
            "color": consumableCategorie.color,
            "iconColor": consumableCategorie.iconColor,
            "consumableSectionGroup": consumableCategorie.consumableSectionGroup,
            "consumablesByID" : consumableCategorie.consumablesByID
            ] as [String : Any]
        refConsumableCategorie.setData(newConsumableCategorie) { err in
            if let err = err {
                print("Error: creating new ConsumableCategorie document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding ConsumableCategorie")))
            } else {
                if let consumableCategorie = ConsumableCategorie(dictionary: newConsumableCategorie) {
                    completionHandler(.success(consumableCategorie))
                    print("Success: ConsumableCategorie created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: something went wrong when adding ConsumableCategorie")))
                }
            }
        }
        
        
    }
    
    func updateConsumableCategorie(selectedCategorie : ConsumableCategorie, consumablesByID : [String] , completionHandler: @escaping (Result<ConsumableCategorie, CoreError>) -> Void){
        
        let path = createPath(collectionName:  collectionName == .Meals ? .MealCategories : .BeveragesCategories,languageType : languageType)
            
//            if language == .Dutch {
//                path = "Restaurants/\(restaurant.restaurantID)/MaaltijdCategorieen"
//            } else if language == .English {
//                path = "Restaurants/\(restaurant.restaurantID)/EnglishCategories"
//            }
            

        let refConsumableCategorie = db.collection(path).document(selectedCategorie.id)
            let newConsumableCategorie = [
                "id" : refConsumableCategorie.documentID,
                "title" : selectedCategorie.title,
                "subtitle" : selectedCategorie.subtitle,
                "image": selectedCategorie.image,
                "color": selectedCategorie.color,
                "iconColor": selectedCategorie.iconColor,
                "consumablesByID" : selectedCategorie.consumablesByID,
                "consumableSectionGroup" : selectedCategorie.consumableSectionGroup
                ] as [String : Any]
        refConsumableCategorie.setData(newConsumableCategorie) { err in
            if let err = err {
                print("Error: creating new ConsumableCategorie document: \(err)")
                completionHandler(.failure(.failed(reason: "Something went wrong when adding ConsumableCategorie")))
            } else {
                if let consumableCategorie = ConsumableCategorie(dictionary: newConsumableCategorie) {
                    if let row = self.consumableCategories.firstIndex(where: {$0.id == consumableCategorie.id}) {
                        self.consumableCategories[row] = consumableCategorie
                    }
                    completionHandler(.success(consumableCategorie))
                    print("Success: ConsumableCategorie created")
                } else {
                    completionHandler(.failure(.failed(reason: "Error: something went wrong when adding ConsumableCategorie")))
                }
            }
        }
        
        
    }
    
    func deleteCategorie(selectedCategorie: ConsumableCategorie,completionHandler: @escaping (Result<Response, CoreError>) -> Void){
       
        let path = createPath(collectionName:  collectionName == .Meals ? .MealCategories : .BeveragesCategories,languageType : languageType)
            db.collection(path).document(selectedCategorie.id).delete() { err in
                if let err = err {
                    print("Error: deleting  ConsumableCategorie document: \(err)")
                    completionHandler(.failure(.failed(reason: "Something went wrong when deleting ConsumableCategorie")))
                } else {
                    
                        if let row = self.consumableCategories.firstIndex(where: {$0.id == selectedCategorie.id}) {
                            self.consumableCategories.remove(at: row)
                        }
                        completionHandler(.success(.documentDeleted))
                        print("Success: ConsumableCategorie Deleted")
                  
                }
        }
        
    }
    
   
    
    
  
}
//if let row = self.upcoming.firstIndex(where: {$0.eventID == id}) {
//       array[row] = newValue
//}
