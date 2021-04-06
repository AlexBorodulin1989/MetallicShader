//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLExpression: TLNode {
    let resultIdentifier: String!
    init(env: TLEnvironment, lexer: Lexer, identifier: String? = nil) throws {
        resultIdentifier = identifier ?? TLInterpreter.generateUniqueID()
        try super.init(env: env, lexer: lexer)
        if lexer.currentType() == .FUNCTION {
            node = try TLFunctCall(env: env, lexer: lexer, returnIdentifier: resultIdentifier).getInstance()
        } else {
            node = nil
        }
    }
}
