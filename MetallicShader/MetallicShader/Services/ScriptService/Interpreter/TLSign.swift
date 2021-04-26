//
//  TLSign.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 26.04.2021.
//

import Foundation

class TLSign: TLNode {
    var intValue: Int?
    var floatValue: Float?
    private(set) var identifier: String?
    private var op = TokenType.PLUS
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        if lexer.match(.MINUS) {
            op = .MINUS
            let term = try TLTerm(env: env, lexer: lexer)
            if term.identifier != nil {
                leftNode = term
                identifier = term.identifier
            } else if term.floatValue != nil {
                floatValue = term.floatValue! * -1
            } else if term.intValue != nil {
                intValue = term.intValue! * -1
            } else {
                throw "Thomething wrong"
            }
        } else {
            let _ = lexer.match(.PLUS)
            let term = try TLTerm(env: env, lexer: lexer)
            
            intValue = term.intValue
            floatValue = term.floatValue
            identifier = term.identifier
            if identifier != nil {
                leftNode = term
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if op == .MINUS {
            var value = env.getVarValue(id: identifier!)
            if ((value?.value as? Int) != nil) {
                value!.value = (value!.value as! Int) * -1
                env.setVar(id: identifier!, value: value!)
            } else if ((value?.value as? Float) != nil) {
                value!.value = (value!.value as! Float) * -1
                env.setVar(id: identifier!, value: value!)
            } else {
                throw "Thomething wrong"
            }
        }
    }
}
