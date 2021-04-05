//
//  Analizator.swift
//  MetallicShader
//
//  Created by Aleks on 31.03.2021.
//

import Foundation

class TLInterpreter {
    var lexer: Lexer!
    
    static private(set) var subscribedFunctions = Set<String>()
    
    func subscribeToFunction(_ functName: String) {
        Self.subscribedFunctions.insert(functName)
    }
    
    func startInterpret(lexer: Lexer) {
        self.lexer = lexer
        let env = TLEnvironment(prev: nil)
        do {
            let seq = try TLSequence(env: env, lexer: lexer)
            seq.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
}
