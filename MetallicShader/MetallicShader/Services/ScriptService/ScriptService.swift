//
//  ScriptService.swift
//  MetallicShader
//
//  Created by Aleks on 27.03.2021.
//

import Foundation
import MetalKit
import JavaScriptCore

enum ScriptValue {
    case notExists
    case value(JSValue)
}

class ScriptService {
    
    static var shared: ScriptService = {
        let instance = ScriptService()
        
        let callback = TLCallbackInfo(identifier: "logger") { params -> TLObject? in
            print(params.first ?? "")
            return nil
        }
        
        instance.addCallback(callback)
        
        instance.addCallback(TLCallbackInfo(identifier: "testFunc", callback: { params -> TLObject? in
            return TLObject(type: .FLOAT, value: Float(0.5), identifier: "")
        }))
        
        return instance
    }()
    
    fileprivate var jsContext: JSContext!
    
    var initBlockID: Int = 0
    
    weak var renderer: Renderer!
    
    var scriptValues = [String : ScriptValue]()
    
    let interpreter = TLInterpreter()
    
    var queue: DispatchQueue!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func interpretFile() {
        
    }
    
    func addCallback(_ funct: TLCallbackInfo) {
        interpreter.subscribeToFunction(funct)
    }
    
    func reloadService(script: String? = nil, completion: @escaping () -> Void){
        
        interpreter.startInterpret(lexer: Lexer(program: script ?? ""))
    }
}

// MARK:- Java Script Function handler

extension ScriptService {
    func requestFunction(name functionName: String, completion: @escaping (_ function: JSValue?) -> Void) {
        
    }
}
