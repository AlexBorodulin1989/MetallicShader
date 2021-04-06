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
            if lexer.currentType() == .FLOAT && type == .FLOAT {
                if let floatValue = TLNumber.parseNumber(lexer: lexer), lexer.match(.SEMICOLON) {
                    env.setVar(id: identifier, value: floatValue)
                } else {
                    throw "Not correct variable definition"
                }
            } else if lexer.currentType() == .STRING && type == .STRING {
                let value = lexer.currentValue()
                if lexer.match(.STRING),  lexer.match(.SEMICOLON) {
                    env.setVar(id: identifier, value: TLObject(type: .STRING, value: value, identifier: identifier))
                } else {
                    throw "Not correct variable definition"
                }
            } else {
                node = try TLExpression(env: env, lexer: lexer, identifier: identifier)
            }
        }
    }
}
