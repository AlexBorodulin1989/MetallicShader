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
    //let resultIdentifier: String!
    var value = 0
    init(env: TLEnvironment, lexer: Lexer, identifier: String? = nil) throws {
        try super.init(env: env, lexer: lexer)
        if lexer.currentType() == .FUNCTION {
            let resultIdentifier = identifier ?? TLInterpreter.generateUniqueID()
            leftNode = try TLFunctCall(env: env, lexer: lexer, returnIdentifier: resultIdentifier)
        } else {
            let add = try TLAdd(env: env, lexer: lexer)
            if lexer.match(.SEMICOLON) {
                value = add.value
            } else {
                throw "Expect semicolon at the end of expression"
            }
            
            if let identif = identifier {
                env.setVar(id: identif, value: TLObject(type: .INTEGER, value: value, identifier: identif, subtype: nil, size: 0))
            }
        }
    }
}
