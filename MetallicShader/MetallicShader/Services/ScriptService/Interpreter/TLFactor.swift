//
//  TLFactor.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLFactor: TLNode {
    var value = 0
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        guard let val = lexer.currentValue() else { throw "Not correct value" }
        if lexer.match(.INT) {
            value = (val as NSString).integerValue
        } else {
            throw "Not correct value"
        }
    }
}
