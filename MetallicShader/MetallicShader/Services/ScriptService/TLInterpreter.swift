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
    
    var functName: String!
    
    private var subscribedFunctions = Set<String>()
    
    func subscribeToFunction(_ functName: String) {
        subscribedFunctions.insert(functName)
        print("Succces")
    }
    
    private func match(_ tokenType: TokenType) -> Bool {
        if tokenType == lookahead?.type {
            lookahead = try? lexer.nextToken()
            if lookahead != nil {
                return true
            }
        }
        return false
    }
}

/*
Syntaxis:
functCall -> id(optparams
optparams -> params | );
params -> param, params | param);
param -> floatnumber
 

*/

extension TLInterpreter {
    
    func analizeFunctionCall(lexer: Lexer) {
        self.lexer = lexer
        if let lookAhead = try? self.lexer.nextToken() {
            lookahead = lookAhead
            functCall()
        } else {
            print("Expression is not a function")
        }
    }
    
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
        
        params()
    }
    
    func params() {
        if match(.IDENTIFIER) {
            if match(.COMMA) {
                params()
                return
            } else if match(.RIGHT_BRACKET) && match(.SEMICOLON) {
                callToSubscribedFunct()
                return
            }
        }
        
        print("Expression is not a function")
    }
    
    func callToSubscribedFunct() {
        if subscribedFunctions.contains(functName) {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: functName),
                object: nil,
                userInfo: nil
            )
        } else {
            print("Function is not defined")
        }
    }
}
