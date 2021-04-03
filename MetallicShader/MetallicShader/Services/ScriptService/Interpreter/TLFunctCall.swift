//
//  TLFunctCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLFunctCall: TLNode {
    let lexer: Lexer!
    
    var functParams = [Float]()
    var functName: String!
    
    init(env: TLEnvironment, lexer: Lexer, functName: String) {
        self.lexer = lexer
        super.init(env: env, lexer: lexer)
        
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
        let intNumber = lexer.currentValue()
        if lexer.match(.INT) {
            if let flParam = TLNumber.parseNumber(lexer: lexer, intValue: intNumber) {
                functParams.append(flParam)
                if lexer.match(.COMMA) {
                    params()
                    return
                }
            }
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
