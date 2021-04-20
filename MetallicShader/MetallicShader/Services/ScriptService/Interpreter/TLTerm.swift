//
//  TLTerm.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLTerm: TLNode {
    var intValue: Int?
    var floatValue: Float?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let factor = try TLFactor(env: env, lexer: lexer)
        if lexer.match(.MUL) {
            let term = try TLTerm(env: env, lexer: lexer)
            if factor.floatValue != nil || term.floatValue != nil {
                floatValue = (factor.floatValue ?? Float(factor.intValue ?? 0)) * (term.floatValue ?? Float(term.intValue ?? 0))
            } else {
                intValue = (factor.intValue ?? 0) * (term.intValue ?? 0)
            }
        } else {
            floatValue = factor.floatValue
            intValue = factor.intValue
        }
    }
}
