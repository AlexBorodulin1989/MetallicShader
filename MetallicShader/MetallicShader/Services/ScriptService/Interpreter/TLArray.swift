//
//  TLArray.swift
//  MetallicShader
//
//  Created by Aleks on 10.04.2021.
//

import Foundation

class TLArray: TLNode {
    let lexer: Lexer!
    init(env: TLEnvironment, lexer: Lexer, identifier: String) throws {
        self.lexer = lexer
        try super.init(env: env, lexer: lexer)
        
        var resArray = [Any]()
        if lexer.match(.LEFT_SQUARE_BRACKET) {
            try addArray(array: &resArray)
            env.setVar(id: identifier, value: TLObject(type: .ARRAY, value: resArray, identifier: identifier, subtype: .FLOAT, size: resArray.count))
        } else {
            throw "Not correct array"
        }
    }
    
    func addArray(array: inout [Any]) throws {
        if lexer.currentType() == .FLOAT {
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
        if lexer.match(.FLOAT) {
            array.append((value as NSString?)?.floatValue ?? Float(0))
            
            if lexer.match(.COMMA) {
                try fillValues(array: &array)
            } else if !lexer.match(.RIGHT_SQUARE_BRACKET) {
                throw "Not correct array definition"
            }
        } else {
            throw "Value of array is not supported"
        }
    }
    
    /*
    func getArray() throws -> [Any]? {
        if lexer.match(.LEFT_SQUARE_BRACKET) {
            var array = [Any]()
            if lexer.currentType() == .FLOAT {
                try fillValues(array: &array)
                if lexer.match(.RIGHT_SQUARE_BRACKET) {
                    return array
                } else if lexer.match(.COMMA) {
                    throw "Array definition not correct"
                }
            } else if lexer.currentType() == .LEFT_SQUARE_BRACKET {
                
            } else {
                throw "Empty array is not supported"
            }
        } else if lexer.currentType() == .FLOAT {
            var valuesArray = [Any]()
            try fillValues(array: &valuesArray)
            return valuesArray
        } else {
            throw "Empty array is not supported"
        }
    }
    
    func fillValues( array: inout [Any]) throws {
        let value = lexer.currentValue()
        if lexer.match(.FLOAT) {
            array.append((value as NSString?)?.floatValue ?? Float(0))
            
            if lexer.match(.COMMA) {
                try fillValues(array: &array)
            }
        } else {
            throw "Value of array is not supported"
        }
    }*/
}
