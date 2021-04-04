//
//  Environment.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

enum TLType {
    case INTEGER
    case FLOAT
    case STRING
    case FUNCT
    case ARRAY
}

struct TLObject {
    let type: TLType
    var value: Any?
    var identifier = ""
}

class TLEnvironment {
    private var table = [String: TLObject]()
    private let previous: TLEnvironment?
    
    init(prev: TLEnvironment?) {
        previous = prev
    }
    
    func setVar(id: String, value: TLObject) {
        table[id] = value
    }
    
    func getVarValue(id: String) -> TLObject? {
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
