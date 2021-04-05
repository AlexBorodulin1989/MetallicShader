//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLExpression: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        if lexer.currentType() == .FUNCTION {
            node = try TLFunctCall(env: env, lexer: lexer).getInstance()
        } else {
            node = nil
        }
    }
}
