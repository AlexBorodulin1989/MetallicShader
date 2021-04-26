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
    
    let returnIdentifier: String!
    
    init(env: TLEnvironment, lexer: Lexer, returnIdentifier: String) throws {
        self.lexer = lexer
        self.returnIdentifier = returnIdentifier
        try super.init(env: env, lexer: lexer)
        
        self.functName = lexer.currentValue()
        guard TLInterpreter.subscribedFunctions[functName] != nil || env.getVarValue(id: self.functName)?.type == .FUNCT else {
            throw "Defenition of function \(String(describing: functName)) is not found"
        }
        
        if lexer.match(.FUNCTION) {
            try optparams()
        }
    }
    
    func optparams() throws {
        if lexer.match(.RIGHT_BRACKET) {
            return
        }
        try params()
    }
    
    func params() throws {
        let val = lexer.currentValue() ?? ""
        if let num = TLNumber.parseNumber(lexer: lexer) {
            functParams.append(num)
            if lexer.match(.COMMA) {
                try params()
                return
            }
        } else if lexer.match(.STRING) {
            functParams.append(TLObject(type: .STRING, value: val, identifier: ""))
            if lexer.match(.COMMA) {
                try params()
                return
            }
        } else if var variable = env.getVarValue(id: val), lexer.match(.IDENTIFIER) {
            variable.identifier = val
            functParams.append(variable)
            if lexer.match(.COMMA) {
                try params()
                return
            }
        } else {
            let identifier = TLInterpreter.generateUniqueID()
            let variable = TLObject(type: .UNKNOWN, value: nil, identifier: identifier, subtype: nil, size: 0)
            env.setVar(id: identifier, value: variable)
            try leftNode = TLExpression(env: env, lexer: lexer, identifier: identifier)
            functParams.append(variable)
            if lexer.match(.COMMA) {
                try params()
                return
            }
        }
        
        if lexer.match(.RIGHT_BRACKET) {
            return
        }
        
        throw "Expression is not a function"
    }
    
    override func execute() throws {
        try super.execute()
        if let callback = TLInterpreter.subscribedFunctions[functName] {
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
            
            let returnValue = callback.callback(params)
            
            if let envValue = env.getVarValue(id: returnIdentifier) {
                if envValue.type == returnValue?.type {
                    env.setVar(id: returnIdentifier, value: returnValue!)
                } else {
                    throw "Return type is not allowed for assigning"
                }
            }
        } else if let functObj = env.getVarValue(id: self.functName), functObj.type == .FUNCT {
            try (functObj.value as? TLFunction)?.setParams(functParams)
            try (functObj.value as? TLNode)?.execute()
        } else {
            throw "Function is not defined"
        }
    }
}
