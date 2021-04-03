//
//  Environment.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

class TLEnvironment {
    private var table = [String: String]()
    private let previous: TLEnvironment?
    
    init(prev: TLEnvironment?) {
        previous = prev
    }
    
    func setVar(id: String, value: String) {
        table[id] = value
    }
    
    func getVarValue(id: String) -> String? {
        var block: TLEnvironment? = self
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
