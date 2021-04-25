//
//  TLDefine.swift
//  MetallicShader
//
//  Created by Aleks on 04.04.2021.
//

import Foundation

class TLDefine: TLNode {
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let type = lexer.valueType()
        
        if lexer.match(.VALUE_TYPE) {
            let identifier = lexer.currentValue() ?? ""
            if lexer.match(.IDENTIFIER) {
                if lexer.currentType() == .ASSIGN {
                    if env.getVarValue(id: identifier) != nil {
                        throw "Variable redifinition"
                    }
                    env.setVar(id: identifier, value: TLObject(type: type, value: nil))
                    leftNode = try TLAssign(env: env, lexer: lexer, identifier: identifier)
                } else {
                    throw "Not correct variable definition"
                }
            } else if lexer.currentType() == .FUNCTION {
                let _ = try TLFunction(env: env, lexer: lexer)
            } else if lexer.match(.LEFT_SQUARE_BRACKET) && lexer.match(.RIGHT_SQUARE_BRACKET) {
                if let identifier = lexer.currentValue(),
                   lexer.match(.IDENTIFIER) {
                    env.setVar(id: identifier, value: TLObject(type: .ARRAY, value: nil, identifier: identifier, subtype: type))
                    if lexer.currentType() == .ASSIGN {
                        leftNode = try TLAssign(env: env, lexer: lexer, identifier: identifier)
                    } else if !lexer.match(.SEMICOLON) {
                        throw "Not correct variable definition"
                    }
                } else {
                    throw "Not correct variable definition"
                }
            } else {
                throw "Not correct variable definition"
            }
        }
    }
}
