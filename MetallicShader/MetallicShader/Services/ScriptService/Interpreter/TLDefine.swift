//
//  TLDefine.swift
//  MetallicShader
//
//  Created by Aleks on 04.04.2021.
//

import Foundation

class TLDefine: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) {
        super.init(env: env, lexer: lexer)
        let type = lexer.currentValue()
        if lexer.match(.VALUE_TYPE) {
            let identifier = lexer.currentValue()
            if lexer.match(.IDENTIFIER) {
                if lexer.match(.ASSIGN) {
                    
                }
            }
        }
    }
}
