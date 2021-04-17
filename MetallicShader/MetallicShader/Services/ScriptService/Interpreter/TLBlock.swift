//
//  Block.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 02.04.2021.
//

import Foundation

class TLBlock: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        let environment = TLEnvironment(prev: env)
        try super.init(env: environment, lexer: lexer)
        
        if lexer.match(.LEFT_CURLY_BRACE) {
            leftNode = try TLSequence(env: environment, lexer: lexer)
        } else {
            throw "Block difinition not correct"
        }
    }
}
