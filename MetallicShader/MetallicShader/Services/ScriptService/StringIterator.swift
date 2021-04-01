//
//  StringIterator.swift
//  MetallicShader
//
//  Created by Aleks on 01.04.2021.
//

import Foundation

enum CharType {
    case digit
    case empty
    case other
}

class StringIterator {
    var string: String!
    var counter = 0
    var maxIndex = 0
    
    init(str: String) {
        self.string = str
        maxIndex = str.count
    }
    
    func isDigit() -> CharType {
        if counter < maxIndex {
            let c = string[counter]
            if c >= "0" && c <= "9" {
                counter += 1
                return .digit
            }
        } else {
            return .empty
        }
        
        counter += 1
        
        return .other
    }
    
    func getRawValue() -> String {
        return string
    }
}
