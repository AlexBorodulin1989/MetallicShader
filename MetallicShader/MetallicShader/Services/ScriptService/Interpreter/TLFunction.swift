//
//  TLFunction.swift
//  MetallicShader
//
//  Created by alexbor on 17.04.2021.
//

import Foundation

class TLFunction: TLNode {
    var functParams = [TLObject]()
    
    private var blockEnvironment: TLEnvironment?
    
    override init(env: TLEnvironment, lexer: Lexer) throws {
        guard let functIdentifier = lexer.currentValue(),
              lexer.match(.FUNCTION)
        else {
            throw "Not correct function define"
        }
        let type = lexer.valueType()
        while lexer.match(.VALUE_TYPE) {
            guard let identifier = lexer.currentValue()
            else {
                throw "Not correct function define"
            }
            if lexer.match(.IDENTIFIER) {
                let object = TLObject(type: type, value: nil, identifier: identifier, subtype: nil, size: 0)
                functParams.append(object)
            } else {
                throw "Not correct function define"
            }
            if !lexer.match(.COMMA) {
                break
            }
        }
        
        try super.init(env: env, lexer: lexer)
        
        if lexer.match(.RIGHT_BRACKET) {
            leftNode = try TLBlock(env: env, lexer: lexer, initialParams: functParams)
            if TLInterpreter.subscribedFunctions[functIdentifier] != nil || env.getVarValue(id: functIdentifier) != nil {
                throw "Redefenition function \(functIdentifier)"
            }
            blockEnvironment = leftNode?.env
            env.setVar(id: functIdentifier, value: TLObject(type: .FUNCT, value: self, identifier: functIdentifier, subtype: nil, size: 0))
        } else {
            throw "Expect ) at function definition"
        }
    }
    
    func setParams(_ params: [TLObject]) throws {
        guard params.count == functParams.count else { throw "Params count not coincide" }
        for (index, param) in params.enumerated() {
            if param.type == leftNode?.env.getVarValue(id: functParams[index].identifier)?.type {
                leftNode?.env.setVar(id: functParams[index].identifier, value: param)
            } else {
                throw "Params not coincide"
            }
        }
    }
    
    func getReturnValue() -> TLObject? {
        return blockEnvironment?.getLocalVarValue(id: returnValueKey)
    }
}
