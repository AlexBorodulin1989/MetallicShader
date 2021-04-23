//
//  TLAdd.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLAdd: TLNode {
    var intValue: Int?
    var floatValue: Float?
    private(set) var identifier: String?
    private var leftIdentifier: String?
    private var rightIdentifier: String?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let term = try TLTerm(env: env, lexer: lexer)
        if lexer.match(.PLUS) {
            let add = try TLAdd(env: env, lexer: lexer)
            if term.identifier != nil || add.identifier != nil {
                identifier = identifier ?? TLInterpreter.generateUniqueID()
                leftIdentifier = term.identifier
                rightIdentifier = add.identifier
                intValue = term.intValue ?? add.intValue
                floatValue = term.floatValue ?? add.floatValue
                if term.identifier != nil {
                    leftNode = term
                }
                if add.identifier != nil {
                    rightNode = add
                }
            } else if term.floatValue != nil || add.floatValue != nil {
                floatValue = (term.floatValue ?? Float(term.intValue ?? 0)) + (add.floatValue ?? Float(add.intValue ?? 0))
            } else {
                intValue = (term.intValue ?? 0) + (add.intValue ?? 0)
            }
        } else {
            floatValue = term.floatValue
            intValue = term.intValue
            identifier = term.identifier
            if identifier != nil {
                leftNode = term
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if leftIdentifier != nil && rightIdentifier != nil {
            let leftValue = env.getVarValue(id: leftIdentifier!)
            let rightValue = env.getVarValue(id: rightIdentifier!)
            if leftValue?.type == .FLOAT || rightValue?.type == .FLOAT {
                let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) + (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
            } else {
                let result = (leftValue?.value as? Int ?? 0) + (rightValue?.value as? Int ?? 0)
                env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
            }
        }
    }
}
