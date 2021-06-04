//
//  TLReturn.swift
//  MetallicShader
//
//  Created by alexbor on 13.05.2021.
//

import Foundation

class TLReturn: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        
        if lexer.match(.RETURN) {
            if !lexer.match(.SEMICOLON) {
                throw "Not correct expression"
            }
        } else {
            throw "Not correct expression"
        }
    }
}
