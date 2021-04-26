//
//  TLAssign.swift
//  MetallicShader
//
//  Created by Aleks on 05.04.2021.
//

import Foundation

class TLAssign: TLNode {
    init(env: TLEnvironment, lexer: Lexer, identifier: String) throws {
        try super.init(env: env, lexer: lexer)
        guard let type = env.getVarValue(id: identifier)?.type
        else {
            throw "Variable type not found"
        }
        if lexer.match(.ASSIGN) {
            if lexer.currentType() == .STRING && type == .STRING {
                let value = lexer.currentValue()
                if lexer.match(.STRING),  lexer.match(.SEMICOLON) {
                    env.setVar(id: identifier, value: TLObject(type: .STRING, value: value, identifier: identifier))
                } else {
                    throw "Not correct variable definition"
                }
            } else if lexer.currentType() == .LEFT_SQUARE_BRACKET {
                guard let subtype = env.getVarValue(id: identifier)?.subtype
                else {
                    throw "Variable type not correct"
                }
                env.setVar(id: identifier, value: TLObject(type: .ARRAY, value: nil, identifier: identifier, subtype: .FLOAT, size: 0))
                leftNode = try TLArray(env: env, lexer: lexer, identifier: identifier, type: subtype.rawValue)
                if !lexer.match(.SEMICOLON) {
                    throw "Not correct variable definition"
                }
            } else {
                leftNode = try TLExpression(env: env, lexer: lexer, identifier: identifier)
                if !lexer.match(.SEMICOLON) {
                    throw "; need at the end of expression"
                }
            }
        }
    }
}
