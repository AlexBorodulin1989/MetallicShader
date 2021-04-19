//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

/*
expr -> func | term + expr ; | term ;
term -> factor * term | factor
factor -> num
*/

class TLExpression: TLNode {
    //let resultIdentifier: String!
    var value = 0
    static var test = 0
    var textVal = 0
    init(env: TLEnvironment, lexer: Lexer, identifier: String? = nil) throws {
        try super.init(env: env, lexer: lexer)
        textVal = Self.test
        Self.test += 1
        if lexer.currentType() == .FUNCTION {
            let resultIdentifier = identifier ?? TLInterpreter.generateUniqueID()
            leftNode = try TLFunctCall(env: env, lexer: lexer, returnIdentifier: resultIdentifier)
        } else {
            let term = try TLTerm(env: env, lexer: lexer)
            if lexer.match(.PLUS) {
                let expr = try TLExpression(env: env, lexer: lexer)
                value = term.value + expr.value
            } else if lexer.match(.SEMICOLON) {
                value = term.value
            } else {
                throw "Expect semicolon at the end of expression"
            }
            print("Value = \(value)")
        }
    }
}
