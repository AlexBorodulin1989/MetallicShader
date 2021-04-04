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
    
    override init(env: TLEnvironment, lexer: Lexer) {
        self.lexer = lexer
        super.init(env: env, lexer: lexer)
        
        self.functName = lexer.currentValue()
        guard TLInterpreter.subscribedFunctions.contains(functName) || env.getVarValue(id: self.functName)?.type == .FUNCT else {
            print("Defenition of function \(String(describing: functName)) is not found")
            return
        }
        
        if lexer.match(.FUNCTION) {
            optparams()
            node = self
        }
    }
    
    func optparams() {
        if lexer.match(.RIGHT_BRACKET) && lexer.match(.SEMICOLON) {
            return
        }
        params()
    }
    
    func params() {
        let val = lexer.currentValue() ?? ""
        if let num = TLNumber.parseNumber(lexer: lexer) {
            functParams.append(num)
            if lexer.match(.COMMA) {
                params()
                return
            }
        } else if var variable = env.getVarValue(id: val), lexer.match(.IDENTIFIER) {
            variable.identifier = val
            functParams.append(variable)
            if lexer.match(.COMMA) {
                params()
                return
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
            var params = [Any]()
            for param in functParams {
                if param.identifier.isEmpty {
                    if let value = param.value {
                        params.append(value)
                    }
                } else {
                    if let value = env.getVarValue(id: param.identifier)?.value {
                        params.append(value)
                    }
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
