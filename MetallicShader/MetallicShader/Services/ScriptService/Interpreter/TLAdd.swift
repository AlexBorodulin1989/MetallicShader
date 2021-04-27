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
    private var op = TokenType.PLUS
    override init(env: TLEnvironment, lexer: Lexer) throws {
        try super.init(env: env, lexer: lexer)
        let sign = try TLSign(env: env, lexer: lexer)
        op = lexer.currentType() ?? .PLUS
        if lexer.match(.PLUS) || lexer.match(.MINUS) {
            let add = try TLAdd(env: env, lexer: lexer)
            if sign.identifier != nil || add.identifier != nil {
                identifier = identifier ?? TLInterpreter.generateUniqueID()
                leftIdentifier = sign.identifier
                rightIdentifier = add.identifier
                intValue = sign.intValue ?? add.intValue
                floatValue = sign.floatValue ?? add.floatValue
                if sign.identifier != nil {
                    leftNode = sign
                }
                if add.identifier != nil {
                    rightNode = add
                }
            } else if sign.floatValue != nil || add.floatValue != nil {
                if op == .PLUS {
                    floatValue = (sign.floatValue ?? Float(sign.intValue ?? 0)) + (add.floatValue ?? Float(add.intValue ?? 0))
                } else {
                    floatValue = (sign.floatValue ?? Float(sign.intValue ?? 0)) - (add.floatValue ?? Float(add.intValue ?? 0))
                }
            } else {
                if op == .PLUS {
                    intValue = (sign.intValue ?? 0) + (add.intValue ?? 0)
                } else {
                    intValue = (sign.intValue ?? 0) - (add.intValue ?? 0)
                }
            }
        } else {
            floatValue = sign.floatValue
            intValue = sign.intValue
            identifier = sign.identifier
            if identifier != nil {
                leftNode = sign
            }
        }
    }
    
    override func execute() throws {
        try super.execute()
        if leftIdentifier != nil && rightIdentifier != nil {
            let leftValue = env.getVarValue(id: leftIdentifier!)
            let rightValue = env.getVarValue(id: rightIdentifier!)
            if leftValue?.type == .FLOAT || rightValue?.type == .FLOAT {
                if op == .PLUS {
                    let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) + (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) - (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            } else {
                if op == .PLUS {
                    let result = (leftValue?.value as? Int ?? 0) + (rightValue?.value as? Int ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (leftValue?.value as? Int ?? 0) - (rightValue?.value as? Int ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            }
        } else if leftIdentifier != nil {
            let leftValue = env.getVarValue(id: leftIdentifier!)
            if leftValue?.type == .FLOAT || floatValue != nil {
                if op == .PLUS {
                    let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) + (floatValue ?? Float(intValue ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (leftValue?.value as? Float ?? Float(leftValue?.value as? Int ?? 0)) - (floatValue ?? Float(intValue ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            } else {
                if op == .PLUS {
                    let result = (leftValue?.value as? Int ?? 0) + (intValue ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (leftValue?.value as? Int ?? 0) - (intValue ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            }
        } else if rightIdentifier != nil {
            let rightValue = env.getVarValue(id: rightIdentifier!)
            if rightValue?.type == .FLOAT || rightValue?.type == .FLOAT {
                if op == .PLUS {
                    let result = (floatValue ?? Float(intValue ?? 0)) + (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (floatValue ?? Float(intValue ?? 0)) - (rightValue?.value as? Float ?? Float(rightValue?.value as? Int ?? 0))
                    env.setVar(id: identifier!, value: TLObject(type: .FLOAT, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            } else {
                if op == .PLUS {
                    let result = (intValue ?? 0) + (rightValue?.value as? Int ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                } else {
                    let result = (intValue ?? 0) / (rightValue?.value as? Int ?? 0)
                    env.setVar(id: identifier!, value: TLObject(type: .INTEGER, value: result, identifier: identifier!, subtype: nil, size: 0))
                }
            }
        }
    }
}
