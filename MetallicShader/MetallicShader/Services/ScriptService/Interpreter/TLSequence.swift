//
//  Sequence.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLSequence: TLNode {
    var stmt: TLNode?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        stmt = try TLStmt(env: env, lexer: lexer)
        if lexer.currentType() != nil {
            node = try TLSequence(env: env, lexer: lexer)
        }
    }
    
    override func execute() throws {
        try stmt?.execute()
        try node?.execute()
    }
}
