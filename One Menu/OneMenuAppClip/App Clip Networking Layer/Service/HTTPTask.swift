/*
 
 Abstract:
 
 The HTTPTask is responsible for configuring parameters for a specific endPoint. You can add as many cases as are applicable to your Network Layers requirements. This one has three cases.
 
 */

import Foundation

public typealias HTTPHeaders = [String:String] // HTTPHeaders is simply just a typealias for a dictionary. You can create this typealias at the top of your HTTPTask file.

public enum HTTPTask {
    
    case request
    case requestParameters(bodyParameters: Parameters?,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeaders?)
}


