//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLExpression: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) {
        super.init(env: env, lexer: lexer)
        let value = lexer.currentValue() ?? ""
        if lexer.lookahead() == .LEFT_BRACKET {
            node = TLFunctCall(env: env, lexer: lexer).getInstance()
        } else {
            node = nil
        }
    }
}
