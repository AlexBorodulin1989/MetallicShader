//
//  TLNumber.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLNumber {
    static func parseNumber(lexer: Lexer) -> TLObject? {
        guard var value = lexer.currentValue(),
              lexer.match(.INT) else {
            return nil
        }
        
        if lexer.match(.POINT) {
            let frac = lexer.currentValue()
            if lexer.match(.INT) {
                value += ("." + (frac ?? "0"))
            }
            return TLObject(type: .FLOAT, value: (value as NSString).floatValue)
        }
        
        return TLObject(type: .INTEGER, value: (value as NSString).intValue)
    }
}
