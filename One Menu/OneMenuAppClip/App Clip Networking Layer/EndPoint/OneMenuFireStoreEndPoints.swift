//
//  MovieEndPoint.swift
//  NetworkingInSwiftUI
//
//  Created by Jordain Gijsbertha on 26/10/2020.
//

import Foundation

enum NetworkEnvironment {
    
    case qa
    case production
    case staging
}

public enum OneMenuFireStoreEndPoints {
    // EndPoints
    case Restaurants
    case Restaurant(id: String)
    case MaaltijdCategorieen(restaurantID: String)
    case Maaltijden(restaurantID: String)
    case DrankenCategorieen(restaurantID: String)
    case Dranken(restaurantID: String)
    
    // English
    case MealCategories(restaurantID: String)
    case Meals(restaurantID: String)
    case BeverageCategories(restaurantID: String)
    case Beverages(restaurantID: String)
}

extension OneMenuFireStoreEndPoints: EndPointType {
    
    var environmentBaseURL: String {
        
        switch NetworkController.environment {
        case .production:
            return "https://us-central1-one-menu-40f52.cloudfunctions.net"
            
        case .qa:
            return "https://us-central1-one-menu-40f52.cloudfunctions.net"
            
        case .staging:
            return "https://us-central1-one-menu-40f52.cloudfunctions.net"
        }
    }
    
    var baseURL: URL {
        
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured") }
        
        return url
    }
    
    var path: String {
        
        switch self {
         
        
        case .Restaurants:
            return "/restaurants"
            
        case .Restaurant(let id):
            return "/restaurants/\(id)"
       
        case .MaaltijdCategorieen(let restaurantID):
            return "/restaurants/\(restaurantID)/MaaltijdCategorieen"
            
        case .Maaltijden(let restaurantID):
            return "/restaurants/\(restaurantID)/Maaltijden"
            
        case .DrankenCategorieen(let restaurantID):
            return "/restaurants/\(restaurantID)/DrankenCategorieen"
        case .Dranken(let restaurantID):
            return "/restaurants/\(restaurantID)/Dranken"
            
        case .MealCategories(let restaurantID):
            return "/restaurants/\(restaurantID)/MealCategories"
            
        case .Meals(let restaurantID):
            return "/restaurants/\(restaurantID)/Meals"
            
        case .BeverageCategories(let restaurantID):
            return "/restaurants/\(restaurantID)/BeverageCategories"
            
        case .Beverages(let restaurantID):
            return "/restaurants/\(restaurantID)/Beverages"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        let FireStoreBearerToken = UserDefaults.standard.value(forKey: "token")
        switch self { // Self is the
            
        case .Restaurant:
            //return .request
         return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
            
        case .MaaltijdCategorieen:
         return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
            
        case .Maaltijden:
         return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
            
        case .Dranken:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
        
        case .DrankenCategorieen:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
            
        default:
            return .requestParametersAndHeaders(bodyParameters: nil, urlParameters: ["": ""], additionalHeaders: ["Authorization":"Bearer \(FireStoreBearerToken ?? "")"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


