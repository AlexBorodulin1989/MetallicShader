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
        let type = lexer.currentType()
        if type == nil {
            node = nil
        } else if type == .VALUE_TYPE {
            node = TLDefine(env: env, lexer: lexer).getInstance()
        } else {
            node = TLExpression(env: env, lexer: lexer).getInstance()
        }
    }
}
