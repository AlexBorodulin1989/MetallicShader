//
//  TLArray.swift
//  MetallicShader
//
//  Created by Aleks on 10.04.2021.
//

import Foundation

class TLArray: TLNode {
    let lexer: Lexer!
    let tokenType: TokenType!
    let objectType: TLType!
    init(env: TLEnvironment, lexer: Lexer, identifier: String, type: Int) throws {
        self.lexer = lexer
        self.tokenType = TokenType(rawValue: type)
        self.objectType = TLType(rawValue: type)
        try super.init(env: env, lexer: lexer)
        
        var resArray = [Any]()
        if lexer.match(.LEFT_SQUARE_BRACKET) {
            try addArray(array: &resArray)
            env.setVar(id: identifier, value: TLObject(type: .ARRAY, value: resArray, identifier: identifier, subtype: self.objectType, size: resArray.count))
        } else {
            throw "Not correct array"
        }
    }
    
    func addArray(array: inout [Any]) throws {
        if lexer.currentType() == tokenType {
            try fillValues(array: &array)
        } else if lexer.match(.LEFT_SQUARE_BRACKET) {
            var internalArray = [Any]()
            try addArray(array: &internalArray)
            if internalArray.count > 0 {
                array.append(internalArray)
            } else {
                throw "Not correct array definition"
            }
            if lexer.match(.COMMA) {
                try addArray(array: &array)
            } else if !lexer.match(.RIGHT_SQUARE_BRACKET) {
                throw "Not correct array definition"
            }
        } else {
            throw "Not correct array definition"
        }
    }
    
    func fillValues( array: inout [Any]) throws {
        let value = lexer.currentValue()
        if lexer.match(tokenType) {
            switch tokenType {
            case .FLOAT:
                array.append((value as NSString?)?.floatValue ?? Float(0))
            case .INT:
                array.append((value as NSString?)?.integerValue ?? 0)
            default:
                array.append(value ?? "")
            }
            
            
            if lexer.match(.COMMA) {
                try fillValues(array: &array)
            } else if !lexer.match(.RIGHT_SQUARE_BRACKET) {
                throw "Not correct array definition"
            }
        } else {
            throw "Value of array is not supported"
        }
    }
}
