//
//  TLTerm.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLTerm: TLNode {
    var value = 0
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let factor = try TLFactor(env: env, lexer: lexer)
        if lexer.match(.MUL) {
            let term = try TLTerm(env: env, lexer: lexer)
            value = factor.value * term.value
        } else {
            value = factor.value
        }
    }
}
