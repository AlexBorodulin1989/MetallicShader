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
        var type = TLType.INTEGER
        switch lexer.currentValue() {
        case "int":
            type = .INTEGER
        case "float":
            type = .FLOAT
        default:
            type = .STRING
        }
        
        if lexer.match(.VALUE_TYPE) {
            if let identifier = lexer.currentValue(),
               lexer.match(.IDENTIFIER) {
                if lexer.currentType() == .ASSIGN {
                    env.setVar(id: identifier, value: TLObject(type: type, value: nil))
                    node = try TLAssign(env: env, lexer: lexer, identifier: identifier).getInstance()
                } else {
                    throw "Not correct variable definition"
                }
            } else if lexer.match(.LEFT_SQUARE_BRACKET) && lexer.match(.RIGHT_SQUARE_BRACKET) {
                if let identifier = lexer.currentValue(),
                   lexer.match(.IDENTIFIER) {
                    env.setVar(id: identifier, value: TLObject(type: .ARRAY, value: nil, identifier: identifier, subtype: type))
                    if lexer.currentType() == .ASSIGN {
                        node = try TLAssign(env: env, lexer: lexer, identifier: identifier).getInstance()
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
