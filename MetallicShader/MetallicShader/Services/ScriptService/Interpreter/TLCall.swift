//
//  TLCall.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLCall: TLNode {
    init(env: TLEnvironment, lexer: Lexer, idName: String) {
        super.init(env: env, lexer: lexer)
        if lexer.match(.LEFT_BRACKET) {
            node = TLFunctCall(env: env, lexer: lexer, functName: idName)
        } else {
            node = nil
        }
    }
}
