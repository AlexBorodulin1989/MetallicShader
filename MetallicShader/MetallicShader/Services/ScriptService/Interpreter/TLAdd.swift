//
//  TLAdd.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLAdd: TLNode {
    var intValue: Int?
    var floatValue: Float?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let term = try TLTerm(env: env, lexer: lexer)
        if lexer.match(.PLUS) {
            let add = try TLAdd(env: env, lexer: lexer)
            if term.floatValue != nil || add.floatValue != nil {
                floatValue = (term.floatValue ?? Float(term.intValue ?? 0)) + (add.floatValue ?? Float(add.intValue ?? 0))
            } else {
                intValue = (term.intValue ?? 0) + (add.intValue ?? 0)
            }
        } else {
            floatValue = term.floatValue
            intValue = term.intValue
        }
    }
}
