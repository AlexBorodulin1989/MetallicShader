//
//  Sequence.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLSequence: TLNode {
    var stmt: TLNode?
    override init(env: TLEnvironment, lexer: Lexer) {
        super.init(env: env, lexer: lexer)
        stmt = TLStmt(env: env, lexer: lexer).getInstance()
        if stmt != nil {
            node = TLSequence(env: env, lexer: lexer)
        }
    }
    
    override func execute() {
        stmt?.execute()
        node?.execute()
    }
}
