//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

/*
expr -> func | add ;
add -> term + add | term
term -> factor * term | factor
factor -> num | ( add )
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
            if lexer.match(.SEMICOLON) {
                intValue = add.intValue
                floatValue = add.floatValue
            } else {
                throw "Expect semicolon at the end of expression"
            }
            
            if add.identifier != nil {
                leftNode = add
                resultIdentifier = add.identifier
            } else if let identif = self.identifier {
                if env.getVarValue(id: identif)?.type == .INTEGER {
                    env.setVar(id: identif, value: TLObject(type: .INTEGER, value: intValue ?? Int(floatValue ?? 0.0), identifier: identif, subtype: nil, size: 0))
                } else if env.getVarValue(id: identif)?.type == .FLOAT {
                    env.setVar(id: identif, value: TLObject(type: .FLOAT, value: floatValue ?? Float(intValue ?? 0), identifier: identif, subtype: nil, size: 0))
                } else {
                    throw "Not correct value type"
                }
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if let resIdentif = self.resultIdentifier {
            let value = env.getVarValue(id: resIdentif)?.value
            if env.getVarValue(id: identifier)?.type == .INTEGER {
                env.setVar(id: identifier, value: TLObject(type: .INTEGER, value: value as? Int ?? Int(value as? Float ?? 0.0), identifier: identifier, subtype: nil, size: 0))
            } else if env.getVarValue(id: identifier)?.type == .FLOAT {
                env.setVar(id: identifier, value: TLObject(type: .FLOAT, value: value as? Float ?? Float(value as? Int ?? 0), identifier: identifier, subtype: nil, size: 0))
            } else {
                throw "Not correct value type"
            }
        }
    }
}
