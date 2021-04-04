//
//  TLNumber.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLNumber {
    static func parseNumber(lexer: Lexer, intValue: String) -> TLObject? {
        var res = intValue
        
        guard lexer.match(.INT) else {
            return nil
        }
        
        if lexer.match(.POINT) {
            let frac = lexer.currentValue()
            if lexer.match(.INT) {
                res += ("." + (frac ?? "0"))
            }
            return TLObject(type: .FLOAT, value: (res as NSString).floatValue, idName: "")
        }
        
        return TLObject(type: .INTEGER, value: (res as NSString).intValue, idName: "")
    }
}
