//
//  TLNode.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

protocol TLNodeProtocol {
    func execute() throws
    func getInstance() -> TLNode?
}

class TLNode: TLNodeProtocol {
    var env: TLEnvironment!
    var node: TLNode?
    
    init(env: TLEnvironment, lexer: Lexer) throws {
        self.env = env
        self.node = nil
    }
    
    func execute() throws {
        try node?.execute()
    }
    
    final func getInstance() -> TLNode? {
        return node
    }
}
