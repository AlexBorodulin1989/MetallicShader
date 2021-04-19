//
//  TLAdd.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLAdd: TLNode {
    var value = 0
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let term = try TLTerm(env: env, lexer: lexer)
        if lexer.match(.PLUS) {
            let add = try TLAdd(env: env, lexer: lexer)
            value = term.value + add.value
        } else {
            value = term.value
        }
    }
}
