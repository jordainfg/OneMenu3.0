//
/*
 
 
 
 
 Abstract;
 
 Responsible for working directly with URLSessionTasks and decoding a Codable model from the data. For example, it has a generic get() method that returns a publisher containing a model.
 */

import Foundation
import Combine

protocol NetworkControllerProtocol: class {
   
    
    func get<T>(type: T.Type,
                urlRequest: URLRequest
    ) -> AnyPublisher<T, Error> where T: Decodable
}

final class NetworkController : NetworkControllerProtocol {
    
    static let environment: NetworkEnvironment = .production
    static let FireStoreWebAPIKey = "AIzaSyCXn1_MTbYwTWp6bu80JKRU3wTIRI7Gkas"
    static let FireStoreBearerToken = UserDefaults.standard.value(forKey: "token")
    enum HTTPError: LocalizedError {
        case httpStatusCode(code : String)
    }
    
    func get<T>(type: T.Type, urlRequest: URLRequest) -> AnyPublisher<T, Error> where T : Decodable {
        /*
          This function does the following
          1. Create and launch a URLSessionDataTask
          2. Obtain the data if no error occurred
          3. Decode a model object
          4. Return a publisher containing either a model object or an error
          */ // Note: Still needs to handle send back Errors.

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .retry(1)
            //.mapError { FailureReason.sessionFailed(error: $0) }
            .tryMap { output in
                    if let response = output.response as? HTTPURLResponse{
                        print( HTTPError.httpStatusCode(code: "\(response.description)"))
                    }
                    return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    
}
enum FailureReason : Error {
      case sessionFailed(error: URLError)
      case decodingFailed
      case other(Error)
  }
