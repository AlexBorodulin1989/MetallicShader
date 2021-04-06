//
//  Analizator.swift
//  MetallicShader
//
//  Created by Aleks on 31.03.2021.
//

import Foundation

typealias TLInterpretCallback = ([Any]) -> TLObject?

struct TLCallbackInfo: Hashable {
    let identifier: String
    let callback: TLInterpretCallback
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: TLCallbackInfo, rhs: TLCallbackInfo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class TLInterpreter {
    var lexer: Lexer!
    
    private static var uniqueID = 0
    
    static private(set) var subscribedFunctions = [String: TLCallbackInfo]()
    
    static func generateUniqueID() -> String {
        uniqueID += 1
        return "\(uniqueID)"
    }
    
    func subscribeToFunction(_ funct: TLCallbackInfo) {
        Self.subscribedFunctions[funct.identifier] = funct
    }
    
    func startInterpret(lexer: Lexer) {
        self.lexer = lexer
        let env = TLEnvironment(prev: nil)
        do {
            let seq = try TLSequence(env: env, lexer: lexer)
            try seq.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
}
