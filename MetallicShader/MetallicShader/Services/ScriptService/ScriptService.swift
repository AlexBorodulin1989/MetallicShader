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
        
        let progpath = Bundle.main.path(forResource: "Test", ofType: "tl")
        do {
            let prog = try String(contentsOfFile:progpath!, encoding: String.Encoding.utf8)
            interpreter.analizeFunctionCall(lexer: Lexer(program: prog))
        } catch {
            fatalError("Initial file not found")
        }
        
        initBlockID += 1
        
        queue = DispatchQueue(label: "Queue (\(initBlockID)")
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key:key, value:())
        
        let blockID = initBlockID
        
        queue.async { [weak self, blockID] in
            ScriptService.shared.jsContext = JSContext()
            self?.scriptValues = [:]
            
            // Need to use context as weak value to prevent blocking java context when it need to be reset from other init closure in refresh
            weak var context = ScriptService.shared.jsContext
            
            context?.exceptionHandler = { context, exception in
                if let exc = exception {
                    foreground {
                        print("JS Exception", exc.toString() ?? "")
                    }
                }
            }
            
            var mainScript = script
            
            let mathjspath = Bundle.main.path(forResource: "math", ofType: "js")
            let helperjspath = Bundle.main.path(forResource: "Helper", ofType: "js")
            let mainjspath = Bundle.main.path(forResource: "InitialJavaScript", ofType: "js")
            do {
                let math = try String(contentsOfFile:mathjspath!, encoding: String.Encoding.utf8)
                let helper = try String(contentsOfFile:helperjspath!, encoding: String.Encoding.utf8)
                if mainScript == nil {
                    mainScript = try String(contentsOfFile:mainjspath!, encoding: String.Encoding.utf8)
                }
                context?.evaluateScript(math)
                context?.evaluateScript(helper)
            } catch {
                fatalError("Initial file not found")
            }
            self?.initSystemLogger()
            self?.initMatrixSetter()
            self?.initBackgroundColorHandler()
            context?.evaluateScript(mainScript)
            
            if blockID == self?.initBlockID ?? 0 {
                foreground {
                    completion()
                }
            }
        }
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
    
    // MARK:- Set background color
    
    let setBackground: @convention(block) ([Double]) -> Void = { color in
        foreground {
            ScriptService.shared.renderer.mtkView.clearColor = MTLClearColor(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
        }
    }
    
    func initBackgroundColorHandler() {
        let setBackgroundObject = unsafeBitCast(self.setBackground, to: AnyObject.self)
     
        self.jsContext.setObject(setBackgroundObject, forKeyedSubscript: "setViewBackground" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("setViewBackground")
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
        queue.async {  [weak jsContext, weak self] in
            let val = self?.scriptValues[functionName]
            if val == nil {
                if let function = jsContext?.objectForKeyedSubscript(functionName), !function.isUndefined {
                    completion(function)
                } else {
                    self?.scriptValues[functionName] = .notExists
                    completion(nil)
                }
            } else {
                switch val {
                case .value(let function):
                    completion(function)
                default:
                    completion(nil)
                }
            }
        }
    }
}
