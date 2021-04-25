//
//  TLNumber.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLNumber {
    static func parseNumber(lexer: Lexer) -> TLObject? {
        guard let value = lexer.currentValue()
        else {
            return nil
        }
        
        if lexer.match(.INT) {
            return TLObject(type: .INTEGER, value: (value as NSString).integerValue)
        }
        
        if lexer.match(.FLOAT) {
            return TLObject(type: .FLOAT, value: (value as NSString).floatValue)
        }
        
        return nil
    }
}
