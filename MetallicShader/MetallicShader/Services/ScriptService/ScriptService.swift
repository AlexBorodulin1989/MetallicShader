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
        
        instance.subscribeToFunct("logger")
        NotificationCenter.default.addObserver(instance, selector: #selector(logger), name: NSNotification.Name(rawValue: "logger"), object: nil)
        
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
    
    func subscribeToFunct(_ name: String) {
        interpreter.subscribeToFunction(name)
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

// MARK:- Notifications

extension ScriptService {
    @objc fileprivate func logger(with notification: Notification) {
        if let params = notification.object as? [Any] {
            print(params.first ?? "")
        }
    }
}
