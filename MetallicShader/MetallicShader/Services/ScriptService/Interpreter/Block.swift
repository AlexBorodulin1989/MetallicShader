//
//  Block.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 02.04.2021.
//

import Foundation

class Block {
    private var table = [String: String]()
    private let previous: Block?
    
    init(prev: Block) {
        previous = prev
    }
    
    func setVar(id: String, value: String) {
        table[id] = value
    }
    
    func getVarValue(id: String) -> String? {
        var block: Block? = self
        repeat {
            let val = block?.table[id]
            if let value = val {
                return value
            }
            block = block?.previous
        } while block != nil
        
        return nil
    }
}
