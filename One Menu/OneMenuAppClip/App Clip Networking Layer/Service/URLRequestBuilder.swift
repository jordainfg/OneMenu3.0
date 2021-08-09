/*
 
 
 
 Abstract
 
 A NetworkRouter has an EndPoint which it uses to make requests and once the request is made it passes the response to the completion.
 
 */

import Foundation
import Combine


class URLRequestBuilder<Endpoint: EndPointType>{
    
    // MARK: - Build URLRequest
    /// Builds a URL Request for us based on the data we defined in the Endpoints.
    /// - Parameter endPoint: Contains baseURL,path,HTTPMethod,HTTPTask(bodyParameters,urlParameters) & Headers
    /// - Throws: Error
    /// - Returns: A URL Request that we can pas to our dataTaskPublisher
    
    func buildRequest(from endPoint: Endpoint) throws -> URLRequest {
        
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do {
            
            switch endPoint.task {
                
                case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                case .requestParameters(bodyParameters: let bodyParameters, urlParameters: let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
                case .requestParametersAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, additionalHeaders: let additionalHeaders):
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                self.additionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
                
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    // MARK: - Build URLRequest Helpers
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
   
    
}
