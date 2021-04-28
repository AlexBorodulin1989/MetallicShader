//
//  Environment.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

enum TLType: Int {
    case ARRAY
    case STRING
    case FLOAT
    case INTEGER
    case FUNCT
    case UNKNOWN
}

struct TLObject {
    let type: TLType
    var value: Any?
    var identifier = ""
    var subtype: TLType?
    var size = 0
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
    
    func getLocalVarValue(id: String) -> TLObject? {
        let val = self.table[id]
        if let value = val {
            return value
        }
        
        return nil
    }
}
