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
        
        if leftNode?.leftNode is TLReturn {
            return
        }
        
        let currentType = lexer.currentType()
        
        if currentType == .RETURN {
            leftNode = try TLReturn(env: env, lexer: lexer)
            throw CodeThrow.Return
        } else if lexer.currentType() != nil && !lexer.match(.RIGHT_CURLY_BRACE) {
            rightNode = try TLSequence(env: env, lexer: lexer)
        }
    }
}
