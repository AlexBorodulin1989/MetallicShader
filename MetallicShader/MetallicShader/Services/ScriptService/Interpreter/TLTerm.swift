//
//  TLTerm.swift
//  MetallicShader
//
//  Created by alexbor on 19.04.2021.
//

import Foundation

class TLTerm: TLNode {
    var intValue: Int?
    var floatValue: Float?
    private(set) var identifier: String?
    private var leftIdentifier: String?
    private var rightIdentifier: String?
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let factor = try TLFactor(env: env, lexer: lexer)
        if lexer.match(.MUL) {
            let term = try TLTerm(env: env, lexer: lexer)
            if factor.identifier != nil || term.identifier != nil {
                identifier = identifier ?? TLInterpreter.generateUniqueID()
                leftIdentifier = factor.identifier
                rightIdentifier = term.identifier
                intValue = factor.intValue ?? term.intValue
                floatValue = factor.floatValue ?? term.floatValue
                if factor.identifier != nil {
                    leftNode = factor
                }
                if term.identifier != nil {
                    rightNode = term
                }
            } else if factor.floatValue != nil || term.floatValue != nil {
                floatValue = (factor.floatValue ?? Float(factor.intValue ?? 0)) * (term.floatValue ?? Float(term.intValue ?? 0))
            } else {
                intValue = (factor.intValue ?? 0) * (term.intValue ?? 0)
            }
        } else {
            floatValue = factor.floatValue
            intValue = factor.intValue
            identifier = factor.identifier
            if identifier != nil {
                leftNode = factor
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if leftIdentifier != nil && rightIdentifier != nil {
            let leftValue = env.getVarValue(id: leftIdentifier!)
            let rightValue = env.getVarValue(id: rightIdentifier!)
            if leftValue?.type == .FLOAT || rightValue?.type == .FLOAT {
                let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) * (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
            } else {
                let result = (leftValue?.value as? Int ?? 0) * (rightValue?.value as? Int ?? 0)
                env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
            }
        }
    }
}
