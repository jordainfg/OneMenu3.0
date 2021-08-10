//
//  SuccesCases.swift
//  One Menu Business
//
//  Created by Jordain Gijsbertha on 22/01/2021.
//

import Foundation
public enum purchaseResult{
    case userCanceld
    
}

public enum SubscriptionStatus{
    case isStarterSubscriber
    case isPremiumSubscriber
    case userIsUnSubscribed
    case userCanceld
}
public enum resultSuccess{
    case purchaseResult(SubscriptionStatus)
    case userSubscriptionStatus(SubscriptionStatus)
    
}
