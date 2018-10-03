//
//  NetworkService.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol CancelableTask {
    func cancel()
    func resume()
}

extension URLSessionDataTask: CancelableTask { }

class NetworkOperation: CancelableTask {
    
    var request: URLRequest
    var sessionDataTask: URLSessionDataTask?
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func cancel() {
        sessionDataTask?.cancel()
    }
    
    func resume() {
        sessionDataTask?.resume()
    }
}

protocol NetworkServiceInterface {
    
    func request(endpoint: Requestable, completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> NetworkOperation
}

enum NetworkError: Error, Equatable {
    case errorStatusCode(statusCode: Int)
    case notConnected
    case cancelled
}

extension NetworkError {
    var isNotFoundError: Bool { return hasCodeError(404) }
    
    func hasCodeError(_ codeError: Int) -> Bool {
        switch self {
        case let (.errorStatusCode(code)):
            return code == codeError
        default: return false
        }
    }
}

// MARK: - Implementation

class NetworkService {
    
    private let session: URLSession
    private let config: NetworkConfigurable
    
    init(session: URLSession, config: NetworkConfigurable) {
        self.session = session
        self.config = config
    }
    
    private func request(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkOperation {
        let operation = NetworkOperation(request: request)
        operation.sessionDataTask = session.dataTask(with: request) { (data, response, requestError) in
            
            var error: Error? = requestError
            
            if let response = response as? HTTPURLResponse {
                
                switch response.statusCode {
                case 400..<600:
                    error = NetworkError.errorStatusCode(statusCode: response.statusCode)
                default: break
                }
            }
            
            if var error = error {
                if error._code == NSURLErrorNotConnectedToInternet {
                    error = NetworkError.notConnected
                } else if error._code == NSURLErrorCancelled {
                    error = NetworkError.cancelled
                }
                completion(nil, nil, error)
            }
            else {
                completion(data, response, nil)
            }
        }
        operation.resume()
        
        return operation
    }
}

extension NetworkService: NetworkServiceInterface {
    
    func request(endpoint: Requestable, completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws -> NetworkOperation {
        
        let urlRequest = try endpoint.urlRequest(with: config)
        return request(request: urlRequest, completion: completion)
    }
}
