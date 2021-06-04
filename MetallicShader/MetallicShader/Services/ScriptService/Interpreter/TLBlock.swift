//
//  Block.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 02.04.2021.
//

import Foundation

class TLBlock: TLNode {
    init(env: TLEnvironment, lexer: Lexer, initialParams: [TLObject]? = nil) throws {
        let environment = TLEnvironment(prev: env)
        try super.init(env: environment, lexer: lexer)
        
        for value in initialParams ?? [] {
            env.setVar(id: value.identifier, value: value)
        }
        
        if lexer.match(.LEFT_CURLY_BRACE) {
            do {
                leftNode = try TLSequence(env: environment, lexer: lexer)
            } catch CodeThrow.Return {
                
                while lexer.currentType() != .RIGHT_CURLY_BRACE {
                    if lexer.currentType() == nil {
                        throw "Expect } at the end of block"
                    }
                    let _ = lexer.match(lexer.currentType()!)
                }
                let _ = lexer.match(.RIGHT_CURLY_BRACE)
                return
            }
        } else {
            throw "Block difinition not correct"
        }
    }
}
