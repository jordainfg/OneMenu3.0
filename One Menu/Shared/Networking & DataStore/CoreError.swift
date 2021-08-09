//
//  CoreError.swift
//  BaseSwiftUIAPP (iOS)
//
//  Created by Jordain Gijsbertha on 30/07/2020.
//

import Foundation
public enum CoreError: Error {
    case mapping
    case noInternet
    case unknown
    case unAuthenticated
    case badURL
    case googleLoginFailed
    case error(error: Error)
    case errorDescription(error: String)
    case failed(reason: String)
    case noSuchCollection
    case noSuchDocument
    case deleteFailed
    
}

public enum Response {
    case collectionRetrieved
    case collectionRetrievedButIsEmpty
    case noSuchCollection
    case documentRetrieved
    case documentAdded
    case documentDeleted
    case tokenRefreshed
}
