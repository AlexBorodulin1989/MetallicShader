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
        
        return instance
    }()
    
    fileprivate var jsContext: JSContext!
    
    var initBlockID: Int = 0
    
    weak var renderer: Renderer!
    
    var scriptValues = [String : ScriptValue]()
    
    let interpreter = TLInterpreter()
    
    var queue: DispatchQueue!
    
    func interpretFile() {
        
    }
    
    func subscribeToFunct(_ name: String) {
        interpreter.subscribeToFunction(name)
    }
    
    func reloadService(script: String? = nil, completion: @escaping () -> Void){
        
        interpreter.startInterpret(lexer: Lexer(program: script ?? ""))
    }
    
    let systemLog: @convention(block) (String) -> Void = { log in
        foreground {
            print(log)
        }
    }
    
    func initSystemLogger() {
        let systemLogObject = unsafeBitCast(self.systemLog, to: AnyObject.self)
     
        self.jsContext.setObject(systemLogObject, forKeyedSubscript: "systemLog" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("systemLog")
    }
    
    // MARK:- Get projection matrix
    
    let setMatrix: @convention(block) ([[Double]], String) -> Void = { matrix, name in
        foreground {
            var resMatrix = float4x4.identity()
            
            if matrix.count == 4 {
                for i in 0...3 {
                    if matrix[i].count == 4 {
                        for c in 0...3 {
                            resMatrix[i][c] = Float(matrix[i][c]);
                        }
                    }
                }
            }
            
            ScriptService.shared.renderer.setMatrixBuffer(resMatrix, name)
        }
    }
    
    func initMatrixSetter() {
        let setMatrixObject = unsafeBitCast(self.setMatrix, to: AnyObject.self)
     
        self.jsContext.setObject(setMatrixObject, forKeyedSubscript: "setMatrix" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("setMatrix")
    }
}

// MARK:- Java Script Function handler

extension ScriptService {
    func requestFunction(name functionName: String, completion: @escaping (_ function: JSValue?) -> Void) {
    }
}
