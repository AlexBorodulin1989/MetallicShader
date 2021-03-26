//
//  ProjectNetworkService.swift
//  MetallicShader
//
//  Created by Aleks on 24.03.2021.
//

import Foundation
import RealmSwift

protocol ProjectNetworkServiceProtocol {
    init(httpService: HTTPServiceProtocol)
    func getProjectList(completion: @escaping (Result<Bool, HTTPError>) -> Void)
}

class ProjectNetworkService : ProjectNetworkServiceProtocol {
    private let httpService: HTTPServiceProtocol
    
    static var defaultItem: ProjectNetworkService = {
        let instance = ProjectNetworkService(httpService: HTTPService(session: URLSession.shared))
        return instance
    }()
    
    required init(httpService: HTTPServiceProtocol) {
        self.httpService = httpService
    }
    
    func getProjectList(completion: @escaping (Result<Bool, HTTPError>) -> Void) {
        
        guard let url = URL(string: "http://localhost:3012/projects") else {
            completion(.failure(HTTPError.notCorrectURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        httpService.get(request: request) { result in
            switch result {
            case .success(let data):
                foreground {
                    let decoder = JSONDecoder()
                    do {
                        guard let realm = try? Realm()
                        else {
                            completion(.failure(HTTPError.unknown("Cannot create realm")))
                            return
                        }
                        
                        let projects = try decoder.decode([Project].self, from: data)
                        
                        try? realm.write {
                            realm.add(projects, update: .modified)
                        }
                        completion(.success(true))
                    } catch {
                        completion(.failure(HTTPError.unknown(error.localizedDescription)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postProject(project: Project, completion: @escaping (Result<Bool, HTTPError>) -> Void) {
        
        guard let url = URL(string: "http://localhost:3012/projects") else {
            completion(.failure(HTTPError.notCorrectURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpBody = try? JSONEncoder().encode(project)
        
        httpService.post(request: request) { result in
            switch result {
            case .success(let data):
                foreground {
                    let decoder = JSONDecoder()
                    do {
                        guard let realm = try? Realm()
                        else {
                            completion(.failure(HTTPError.unknown("Cannot create realm")))
                            return
                        }
                        
                        let projects = try decoder.decode([Project].self, from: data)
                        
                        try? realm.write {
                            realm.add(projects, update: .modified)
                        }
                        completion(.success(true))
                    } catch {
                        completion(.failure(HTTPError.unknown(error.localizedDescription)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
