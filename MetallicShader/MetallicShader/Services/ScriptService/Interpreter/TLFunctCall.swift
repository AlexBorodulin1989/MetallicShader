//
//  TLFunctCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLFunctCall: TLNode {
    let lexer: Lexer!
    
    var functParams = [TLObject]()
    var functName: String!
    
    init(env: TLEnvironment, lexer: Lexer, functName: String) {
        self.lexer = lexer
        super.init(env: env, lexer: lexer)
        
        node = self
        
        self.functName = functName
        
        optparams()
    }
    
    func optparams() {
        if lexer.match(.RIGHT_BRACKET) && lexer.match(.SEMICOLON) {
            return
        }
        params()
    }
    
    func params() {
        let value = lexer.currentValue()
        if lexer.match(.INT) {
            functParams.append(TLNumber.parseNumber(lexer: lexer, intValue: value))
            if lexer.match(.COMMA) {
                params()
                return
            }
        } else if lexer.match(.IDENTIFIER) {
            
        } else {
            print("Expected param of function")
        }
        
        if lexer.match(.RIGHT_BRACKET)
            && lexer.match(.SEMICOLON) {
            return
        }
        
        print("Expression is not a function")
    }
    
    override func execute() {
        if TLInterpreter.subscribedFunctions.contains(functName) {
            var params = [Any]()
            for param in functParams {
                if param.idName.isEmpty {
                    params.append(param.value)
                }
            }
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: functName),
                object: params,
                userInfo: nil
            )
        } else {
            print("Function is not defined")
        }
    }
}
