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
                if lexer.match(.ASSIGN) {
                    if type == .FLOAT {
                        if let floatValue = TLNumber.parseNumber(lexer: lexer), lexer.match(.SEMICOLON) {
                            env.setVar(id: identifier, value: floatValue)
                        } else {
                            throw "Not correct variable definition"
                        }
                    } else if type == .STRING {
                        let value = lexer.currentValue()
                        if lexer.match(.STRING),  lexer.match(.SEMICOLON) {
                            env.setVar(id: identifier, value: TLObject(type: .STRING, value: value, identifier: identifier))
                        } else {
                            throw "Not correct variable definition"
                        }
                    } else {
                        throw "Not correct type of variable"
                    }
                } else if lexer.match(.SEMICOLON) {
                    env.setVar(id: identifier, value: TLObject(type: type, value: nil))
                } else {
                    throw "Not correct variable definition"
                }
            }
        }
    }
}
