//
//  TLNode.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

protocol TLNodeProtocol {
    func execute() throws
}

class TLNode: TLNodeProtocol {
    private(set) var env: TLEnvironment!
    var leftNode: TLNode?
    var rightNode: TLNode?
    
    init(env: TLEnvironment, lexer: Lexer) throws {
        self.env = env
        self.leftNode = nil
    }
    
    func execute() throws {
        try leftNode?.execute()
        try rightNode?.execute()
    }
}
