//
//  AuthService.swift
//  MetallicShader
//
//  Created by Aleks on 03.05.2021.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    
    private var jwTokenKey = "JWTokenKey";
    
    private init(){}
    
    func setToken(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: jwTokenKey)
    }
    
    func getToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: jwTokenKey)
    }
}
