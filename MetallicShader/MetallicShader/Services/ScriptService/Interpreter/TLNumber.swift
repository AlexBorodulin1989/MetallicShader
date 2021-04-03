//
//  TLNumber.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLNumber {
    static func parseNumber(lexer: Lexer, intValue: String) -> Float? {
        var res = intValue
        if lexer.match(.POINT) {
            let frac = lexer.currentValue()
            if lexer.match(.INT) {
                res += ("." + frac)
            }
        }
        
        return (res as NSString).floatValue
    }
}
