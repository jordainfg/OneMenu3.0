//
//  ParameterEncoding.swift
//  NetworkingInSwiftUI
//
//  Created by Jordain Gijsbertha on 26/10/2020.
//

import Foundation


public typealias Parameters = [String:Any] // We use a typealias to make our code cleaner and more concise.


public protocol ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
