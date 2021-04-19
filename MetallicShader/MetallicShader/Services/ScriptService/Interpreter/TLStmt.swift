//
//  Stmt.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLStmt: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let type = lexer.currentType()
        if type == nil {
        } else if type == .VALUE_TYPE {
            leftNode = try TLDefine(env: env, lexer: lexer)
        } else if type != nil {
            leftNode = try TLExpression(env: env, lexer: lexer)
        }
    }
}
