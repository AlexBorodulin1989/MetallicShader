//
//  TLFactor.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLFactor: TLNode {
    var intValue: Int?
    var floatValue: Float?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        guard let val = lexer.currentValue()
        else {
            throw "Not correct value"
        }
        if lexer.match(.INT) {
            intValue = (val as NSString).integerValue
        } else if lexer.match(.FLOAT) {
            floatValue = (val as NSString).floatValue
        } else if lexer.match(.LEFT_BRACKET) {
            let add = try TLAdd(env: env, lexer: lexer)
            floatValue = add.floatValue
            intValue = add.intValue
            if !lexer.match(.RIGHT_BRACKET) {
                throw "Need ) after expression"
            }
        } else {
            throw "Not correct value"
        }
    }
}
