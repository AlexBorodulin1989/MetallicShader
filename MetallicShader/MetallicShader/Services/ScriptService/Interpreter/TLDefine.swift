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
            let identifier = lexer.currentValue() ?? ""
            if lexer.match(.IDENTIFIER) {
                if lexer.currentType() == .ASSIGN {
                    env.setVar(id: identifier, value: TLObject(type: type, value: nil))
                    node = try TLAssign(env: env, lexer: lexer, identifier: identifier).getInstance()
                } else {
                    throw "Not correct variable definition"
                }
            } else if lexer.match(.FUNCTION) && lexer.match(.RIGHT_BRACKET) {
                let funcNode = try TLBlock(env: env, lexer: lexer)
                if TLInterpreter.subscribedFunctions[identifier] != nil || env.getVarValue(id: identifier) != nil {
                    throw "Redefenition function \(identifier)"
                }
                env.setVar(id: identifier, value: TLObject(type: .FUNCT, value: funcNode, identifier: identifier, subtype: nil, size: 0))
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
