//
//  Stmt.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLStmt: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) {
        super.init(env: env, lexer: lexer)
        let value = lexer.currentValue()
        if value == nil {
            node = nil
        } else {
            node = TLExpression(env: env, lexer: lexer).getInstance()
        }
    }
}
