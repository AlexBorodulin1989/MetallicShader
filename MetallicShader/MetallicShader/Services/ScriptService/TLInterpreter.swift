//
//  Analizator.swift
//  MetallicShader
//
//  Created by Aleks on 31.03.2021.
//

import Foundation

class TLInterpreter {
    var lookahead: Token?
    var lexer: Lexer!
    
    private var subscribedFunctions = Set<String>()
    
    var stringIterator: StringIterator!
    
    //Intermediate values
    var functName: String!
    var num: String?
    var functParams = [Float]()
    
    func subscribeToFunction(_ functName: String) {
        subscribedFunctions.insert(functName)
        print("Succces")
    }
    
    func startInterpret(lexer: Lexer) {
        self.lexer = lexer
        if let lookAhead = try? self.lexer.nextToken() {
            lookahead = lookAhead
            functCall()
        } else {
            print("Expression is not a function")
        }
    }
    
    private func match(_ tokenType: TokenType) -> Bool {
        if tokenType == lookahead?.type {
            lookahead = try? lexer.nextToken()
            if lookahead?.type == .LINEBREAK {
                let _ = match(.LINEBREAK)
            }
            return true
        }
        return false
    }
}

/*
functCall -> id(optparams
optparams -> params | );
params -> param, params | param);
param -> number | String
*/

extension TLInterpreter {
    
    func functCall() {
        functName = lookahead?.value ?? ""
        if match(.IDENTIFIER) && match(.LEFT_BRACKET) {
            optparams()
        } else {
            print("Expression is not a function")
        }
    }
    
    func optparams() {
        if match(.RIGHT_BRACKET) && match(.SEMICOLON) {
            callToSubscribedFunct()
            return
        }
        
        functParams = []
        params()
    }
    
    func params() {
        number()
        if let number = num {
            functParams.append((number as NSString).floatValue)
        }
        
        if match(.COMMA) {
            params()
            return
        } else if match(.RIGHT_BRACKET)
                    && match(.SEMICOLON) {
            callToSubscribedFunct()
            return
        }
        
        print("Expression is not a function")
    }
    
    func callToSubscribedFunct() {
        if subscribedFunctions.contains(functName) {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: functName),
                object: functParams,
                userInfo: nil
            )
        } else {
            print("Function is not defined")
        }
    }
}

/*
number -> int | int fraction
fraction -> . int | .
*/

extension TLInterpreter {
    
    func number()  {
        num = lookahead?.value ?? "0"
        if match(.INT) {
            fraction()
            return
        }
        num = nil
    }
    
    func fraction() {
        if match(.POINT) {
            let frac = lookahead?.value
            if match(.INT) {
                num! += ("." + (frac ?? "0"))
            }
        }
    }
}
