//
//  TLReturn.swift
//  MetallicShader
//
//  Created by alexbor on 13.05.2021.
//

import Foundation

let returnValueKey = "@ReturnValueKey"

class TLReturn: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        
        if lexer.match(.RETURN) {
            if !lexer.match(.SEMICOLON) {
                leftNode = try TLExpression(env: env, lexer: lexer, identifier: returnValueKey)
                if !lexer.match(.SEMICOLON) {
                    throw "; need at the end of return"
                }
            }
        } else {
            throw "Not correct expression"
        }
    }
}
