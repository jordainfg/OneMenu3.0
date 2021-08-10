/*
 
 
 Abstract:
 
 abstracts the work being done by the network controller from the presentation layer (views) and provides simple methods for querying models. For example, it may have a getMovies() method that calls the required method of a network controller and returns an array of Movies.
 */

import Foundation
import Combine

protocol FirestoreLogicControllerProtocol: AnyObject {
    var networkController: NetworkControllerProtocol { get }

    func getRestaurantDocument(id : String) -> AnyPublisher<Restaurant, Error>
    func getRestaurantConsumableCategories(restaurantID : String, endPoint: OneMenuFireStoreEndPoints) -> AnyPublisher<[ConsumableCategorie], Error>
    func getRestaurantConsumables(restaurantID : String, endPoint: OneMenuFireStoreEndPoints) -> AnyPublisher<[Consumable], Error>
  
}

class FirestoreLogicController : FirestoreLogicControllerProtocol{
    
    
    
    let networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    private let urlRuestBuilder = URLRequestBuilder<OneMenuFireStoreEndPoints>()
    
    func getRestaurantAllRestaurants() -> AnyPublisher<[Restaurant], Error> {
        do {
            let  request = try urlRuestBuilder.buildRequest(from: OneMenuFireStoreEndPoints.Restaurants)
            return networkController.get(type: [Restaurant].self,
                                         urlRequest: request)
        } catch{
            print("An error occurred when creating urlRequest : \(error)")
            return networkController.get(type: [Restaurant].self,
                                         urlRequest: URLRequest(url: URL(string: "")!))
        }
    }
//
    
    
    func getRestaurantDocument(id : String) -> AnyPublisher<Restaurant, Error> {
        do {
            let  request = try urlRuestBuilder.buildRequest(from: OneMenuFireStoreEndPoints.Restaurant(id: id))
            return networkController.get(type: Restaurant.self,
                                         urlRequest: request)
        } catch{
            print("An error occurred when creating urlRequest : \(error)")
            return networkController.get(type: Restaurant.self,
                                         urlRequest: URLRequest(url: URL(string: "")!))
        }
    }
    
    func getRestaurantConsumableCategories(restaurantID : String, endPoint: OneMenuFireStoreEndPoints) -> AnyPublisher<[ConsumableCategorie], Error> {
        do {
            let  request = try urlRuestBuilder.buildRequest(from: endPoint)
            return networkController.get(type: [ConsumableCategorie].self,
                                         urlRequest: request)
        } catch{
            print("An error occurred when creating urlRequest : \(error)")
            return networkController.get(type: [ConsumableCategorie].self,
                                         urlRequest: URLRequest(url: URL(string: "")!))
        }
    }
    
    func getRestaurantConsumables(restaurantID : String, endPoint: OneMenuFireStoreEndPoints) -> AnyPublisher<[Consumable], Error> {
        do {
            let  request = try urlRuestBuilder.buildRequest(from: endPoint)
            return networkController.get(type: [Consumable].self,
                                         urlRequest: request)
        } catch{
            print("An error occurred when creating urlRequest : \(error)")
            return networkController.get(type: [Consumable].self,
                                         urlRequest: URLRequest(url: URL(string: "")!))
        }
    }
    
    
//    func getRestaurantDrankenCategorieen(restaurantID : String) -> AnyPublisher<[BeverageCategorie], Error> {
//        do {
//            let  request = try urlRuestBuilder.buildRequest(from: OneMenuFireStoreEndPoints.DrankenCategorieen(restaurantID: restaurantID))
//            return networkController.get(type: [BeverageCategorie].self,
//                                         urlRequest: request)
//        } catch{
//            print("An error occurred when creating urlRequest : \(error)")
//            return networkController.get(type: [BeverageCategorie].self,
//                                         urlRequest: URLRequest(url: URL(string: "")!))
//        }
//    }
//    
//    func getRestaurantDranken(restaurantID : String) -> AnyPublisher<[Beverage], Error> {
//        do {
//            let  request = try urlRuestBuilder.buildRequest(from: OneMenuFireStoreEndPoints.Dranken(restaurantID: restaurantID))
//            return networkController.get(type: [Beverage].self,
//                                         urlRequest: request)
//        } catch{
//            print("An error occurred when creating urlRequest : \(error)")
//            return networkController.get(type: [Beverage].self,
//                                         urlRequest: URLRequest(url: URL(string: "")!))
//        }
//    }
}
