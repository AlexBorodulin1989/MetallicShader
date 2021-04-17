//
//  Sequence.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLSequence: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        leftNode = try TLStmt(env: env, lexer: lexer)
        if lexer.currentType() != nil && !lexer.match(.RIGHT_CURLY_BRACE) {
            rightNode = try TLSequence(env: env, lexer: lexer)
        }
    }
}
