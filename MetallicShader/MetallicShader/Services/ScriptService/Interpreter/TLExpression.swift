//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

/*
expr -> func | add
add -> sign + add | sign
sign -> term | -term | +term
term -> factor * term | factor
factor -> num | ( add ) | id
*/

class TLExpression: TLNode {
    let identifier: String!
    var intValue: Int?
    var floatValue: Float?
    var resultIdentifier: String?
    init(env: TLEnvironment, lexer: Lexer, identifier: String? = nil) throws {
        self.identifier = identifier ?? TLInterpreter.generateUniqueID()
        try super.init(env: env, lexer: lexer)
        if lexer.currentType() == .FUNCTION {
            leftNode = try TLFunctCall(env: env, lexer: lexer, returnIdentifier: self.identifier)
        } else {
            let add = try TLAdd(env: env, lexer: lexer)
            
            if add.identifier != nil {
                leftNode = add
                resultIdentifier = add.identifier
            } else if let identif = self.identifier {
                floatValue = add.floatValue
                intValue = add.intValue
                if env.getVarValue(id: identif)?.type == .INTEGER {
                    env.setVar(id: identif, value: TLObject(type: .INTEGER, value: intValue ?? Int(floatValue ?? 0.0), identifier: identif, subtype: nil, size: 0))
                } else if env.getVarValue(id: identif)?.type == .FLOAT {
                    env.setVar(id: identif, value: TLObject(type: .FLOAT, value: floatValue ?? Float(intValue ?? 0), identifier: identif, subtype: nil, size: 0))
                } else {
                    env.setVar(id: identif, value: TLObject(type: floatValue != nil ? .FLOAT : .INTEGER, value: floatValue ?? intValue, identifier: identif, subtype: nil, size: 0))
                }
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if let resIdentif = self.resultIdentifier, let resVariable = env.getVarValue(id: resIdentif) {
            let value = resVariable.value
            let retValueType = env.getVarValue(id: identifier)?.type
            if retValueType == .INTEGER {
                env.setVar(id: identifier, value: TLObject(type: .INTEGER, value: value as? Int ?? Int(value as? Float ?? 0.0), identifier: identifier, subtype: nil, size: 0))
            } else if retValueType == .FLOAT {
                env.setVar(id: identifier, value: TLObject(type: .FLOAT, value: value as? Float ?? Float(value as? Int ?? 0), identifier: identifier, subtype: nil, size: 0))
            } else {
                env.setVar(id: identifier, value: resVariable)
            }
        }
    }
}
