//
//  ScriptService.swift
//  MetallicShader
//
//  Created by Aleks on 27.03.2021.
//

import Foundation
import MetalKit
import JavaScriptCore

struct BufferMatrix {
    let matrix: float4x4
    let name: String
}

enum ScriptValue {
    case notExists
    case value(JSValue)
}

class ScriptService {
    
    static var shared: ScriptService = {
        let instance = ScriptService()
        
        instance.addCallback(TLCallbackInfo(identifier: "logger") { params -> TLObject? in
            print(params.first ?? "")
            return nil
        })
        
        return instance
    }()
    
    let interpreter = TLInterpreter()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addCallback(_ funct: TLCallbackInfo) {
        interpreter.subscribeToFunction(funct)
    }
    
    func reloadService(script: String? = nil, completion: @escaping () -> Void){
        interpreter.startInterpret(lexer: Lexer(program: script ?? ""))
    }
    
    func executeFunct(name: String, params: [TLObject]) {
        interpreter.executeFunct(name: name, params: params)
    }
}
