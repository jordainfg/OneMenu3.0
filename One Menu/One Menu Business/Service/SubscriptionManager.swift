//
//  SubscriptionManager.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 21/01/2021.
//

import Foundation
import SwiftUI
import Purchases

public class SubscriptionManager: ObservableObject {
    public static let shared = SubscriptionManager()
    
    public enum SubscriptionStatus {
        case subscribed, notSubscribed
    }
    
    @Published public var monthlySubscription: Purchases.Package?
    
    
    @Published var subscriptionPlans : [subscriptionPlanOption] = []
    @Published  var packages: [Purchases.Package] = []
    
    //@AppStorage("isStarterUser") var isStarterUser: Bool = false
    @AppStorage("isPremiumUser") var isPremiumUser: Bool = false
    init() {
        start()
    }
    func start(){
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "tAcNqtKknHxuMoQsYMqXyojiLGpLTzRV")
        getSubscriptions()
        
    }
    
    func getSubscriptions(){
        self.subscriptionPlans.removeAll()
        Purchases.shared.offerings { (offerings, error) in
            self.checkIfUserIsSubscribed(){ _ in}
            if let packages = offerings?.current?.availablePackages {
                // Display packages for sale
                self.packages = packages
                for package in self.packages {
                    //                    if package.product.localizedTitle.contains("Starter") {
                    //                        self.subscriptionPlans.append(subscriptionPlanOption(name: package.product.localizedTitle, price: "\(package.product.localizedPricee )", features: ["One Restaurant","Unlimted consumables and drinks"],package: package))
                    //                    }
                    if package.product.localizedTitle.contains("Premium")  {
                        self.subscriptionPlans.append(subscriptionPlanOption(name: package.product.localizedTitle, price: "\(package.product.localizedPricee )", features: ["Three restaurants","Unlimited consumables and drinks","Weekly news notifications","QR code scanning","IOS 14 App clips"],package: package))
                    }
                    
                }
            }
        }
        
        
    }
    func purchasePackage(plan: subscriptionPlanOption ,completionHandler: @escaping (Result<resultSuccess, Purchases.ErrorCode>) -> Void){
        
        Purchases.shared.purchasePackage(plan.package) { (transaction, purchaserInfo, error, userCancelled) in
            if let err = error as NSError? {
                completionHandler(.failure(Purchases.ErrorCode(_nsError: err)))
            }
            
            if let purchaserInfo = purchaserInfo{
                if purchaserInfo.entitlements["Premium"]?.isActive == true {
                    // Unlock that great "pro" content
                    self.isPremiumUser = true
                    completionHandler(.success(.purchaseResult(.isPremiumSubscriber)))
                    print("Premium unlocked")
                }
            }
            
            if userCancelled {
                completionHandler(.success(.purchaseResult(.userCanceld)))
            } else {
                completionHandler(.failure(Purchases.ErrorCode(_nsError:CoreError.unknown as NSError)))
            }
        }
    }
    
    func checkIfUserIsSubscribed(completionHandler: @escaping (Result<resultSuccess, CoreError>) -> Void){
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let err = error as NSError? {
                print(err)
                completionHandler(.failure(CoreError.unknown))
            }
            if let purchaserInfo = purchaserInfo{
                
                if purchaserInfo.activeSubscriptions.contains("OneMenuBusiness_LaunchPrice_1m_1w0") {
                     self.isPremiumUser = true
                    completionHandler(.success(.userSubscriptionStatus(.isPremiumSubscriber)))
                }
                if purchaserInfo.activeSubscriptions.isEmpty {
                    self.isPremiumUser = false
                    completionHandler(.success(.userSubscriptionStatus(.userIsUnSubscribed)))
                }
            } else {
                self.isPremiumUser = false
                print("USER NOT SUBSCRIBED")
                completionHandler(.failure(CoreError.unknown))
            }
        }
    }
    
    func restorePurchases(completionHandler: @escaping (Result<resultSuccess, CoreError>) -> Void){
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let err = error as NSError? {
                print(err)
                completionHandler(.failure(CoreError.unknown))
            }
            if let purchaserInfo = purchaserInfo{
                
                if purchaserInfo.activeSubscriptions.contains("OneMenuBusiness_LaunchPrice_1m_1w0") {
                    // user has access to "your_entitlement_id"
                    self.isPremiumUser = true
                    completionHandler(.success(.userSubscriptionStatus(.isPremiumSubscriber)))
                }
                if purchaserInfo.activeSubscriptions.isEmpty {
                    self.isPremiumUser = false
                    print("USER NOT SUBSCRIBED")
                    completionHandler(.failure(CoreError.unknown))
                }
            } else {
                self.isPremiumUser = false
                print("USER NOT SUBSCRIBED")
                completionHandler(.failure(CoreError.unknown))
            }
        }
    }
    
    
    
}
extension SKProduct {
    var localizedPricee: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: price)!
    }
}
