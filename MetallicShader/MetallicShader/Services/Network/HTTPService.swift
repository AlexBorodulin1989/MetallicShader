//
//  HTTPService.swift
//  MetallicShader
//
//  Created by Aleks on 23.03.2021.
//

import Foundation

enum HTTPError: Error {
    case dataNotExists
    case notCorrectURL
    case unknown(String)
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol HTTPServiceProtocol {
    init(session: URLSessionProtocol)
    func get(request: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void)
}

class HTTPService: HTTPServiceProtocol {
    private let session: URLSessionProtocol
    private let timeout: Double = 30
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(request: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = request
        
        urlRequest.httpMethod = "GET"
        
        session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            } else if data == nil {
                completion(.failure(.dataNotExists))
            } else {
                completion(.success(data!))
            }
        }.resume()
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
