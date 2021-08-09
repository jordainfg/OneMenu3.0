

import Foundation

/*
 Our EndPointType has a number of HTTP protocols that we need for building an entire endPoint. Let’s explore what these protocols entail.
 
 
 */
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }// This enum will be used to set the HTTP method of our request. GET,POST,PUT
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


