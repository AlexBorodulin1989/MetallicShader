//
//  StringStateMachine.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 29.04.2021.
//

import Foundation
import GameplayKit

enum FunctType {
    case nextChar
    case writeChar
    case none
}

struct State {
    let input: String
    let fail: Int
    let success: Int
    let failFunct: FunctType
    let successFunct: FunctType
}

class StringLiteralStateMachine {
    static var buffer = ""
    
    static let stateTable =
        [State(input: "", fail: 0, success: 0, failFunct: .none, successFunct: .none),
         State(input: "\"", fail: 0, success: 2, failFunct: .none, successFunct: .nextChar),
         State(input: "\"", fail: 3, success: 0, failFunct: .none, successFunct: .none),
         State(input: "\\", fail: 2, success: 4, failFunct: .writeChar, successFunct: .nextChar),
         State(input: "\\", fail: 2, success: 5, failFunct: .nextChar, successFunct: .nextChar),
         State(input: "\\", fail: 6, success: 4, failFunct: .none, successFunct: .nextChar),
         State(input: "\"", fail: 2, success: 0, failFunct: .none, successFunct: .none)]
    
    class func getStringLiteral(lexer: Lexer) -> Token? {
        buffer = ""
        let start = lexer.currentSymbolIndex
        
        var currentState = 1
        
        while !lexer.endProgram() && currentState != 0 {
            let stateItem = stateTable[currentState]
            if stateItem.input == "\(lexer.currentSymbol())" {
                currentState = stateItem.success
                startFunct(type: stateItem.successFunct, lexer: lexer)
            } else {
                currentState = stateItem.fail
                startFunct(type: stateItem.failFunct, lexer: lexer)
            }
        }
        
        let end = lexer.currentSymbolIndex
        
        if end - start > 0 {
            lexer.nextChar()
            return Token(type: .STRING, start: start, end: end, value: buffer)
        }
        
        return nil
    }
    
    class func startFunct(type: FunctType, lexer: Lexer) {
        switch type {
        case .nextChar:
            lexer.nextChar()
        case .writeChar:
            self.writeLetter(letter: "\(lexer.currentSymbol())", lexer: lexer)
        default:
            break
        }
    }
    
    class func writeLetter(letter: String, lexer: Lexer) {
        buffer += letter
        lexer.nextChar()
    }
}
