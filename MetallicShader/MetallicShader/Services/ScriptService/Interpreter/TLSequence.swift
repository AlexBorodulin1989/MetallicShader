//
//  Sequence.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLSequence: TLNode {
    
    override var nodeName: String {
        return "Node"
    }
    
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        leftNode = try TLStmt(env: env, lexer: lexer)
        
        let currentType = lexer.currentType()
        
        if currentType == .RETURN {
            rightNode = try TLReturn(env: env, lexer: lexer)
        } else if lexer.currentType() != nil && lexer.currentType() != .RIGHT_CURLY_BRACE {
            rightNode = try TLSequence(env: env, lexer: lexer)
        }
    }
}
