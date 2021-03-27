//
//  HTTPService.swift
//  MetallicShader
//
//  Created by Aleks on 23.03.2021.
//

import Foundation

let localHost = "localhost:3012"
let globalHost = "194.87.95.43:3012"
let host = localHost

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
    func post(request: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void)
    func delete(request: URLRequest, completion: @escaping (Result<Bool, HTTPError>) -> Void)
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
        
        session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            } else if data == nil {
                completion(.failure(.dataNotExists))
            } else {
                completion(.success(data!))
            }
        }.resume()
    }
    
    func post(request: URLRequest, completion: @escaping (Result<Data, HTTPError>) -> Void) {
        var urlRequest = request
        
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            } else if data == nil {
                completion(.failure(.dataNotExists))
            } else {
                completion(.success(data!))
            }
        }.resume()
    }
    
    func delete(request: URLRequest, completion: @escaping (Result<Bool, HTTPError>) -> Void) {
        var urlRequest = request
        
        urlRequest.httpMethod = "DELETE"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            } else if data == nil {
                completion(.failure(.dataNotExists))
            } else {
                completion(.success(true))
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
