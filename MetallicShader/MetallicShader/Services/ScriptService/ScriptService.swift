//
//  ScriptService.swift
//  MetallicShader
//
//  Created by Aleks on 27.03.2021.
//

import Foundation
import MetalKit
import JavaScriptCore

class ScriptService {
    static var shared: ScriptService = {
        let instance = ScriptService()
        instance.jsContext = JSContext()
        
        return instance
    }()
    
    fileprivate var jsContext: JSContext!
    
    weak var renderer: Renderer!
    
    func reloadService(script: String? = nil) {
        ScriptService.shared.jsContext = JSContext()
        
        ScriptService.shared.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception", exc.toString() ?? "")
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
            ScriptService.shared.jsContext.evaluateScript(math)
            ScriptService.shared.jsContext.evaluateScript(helper)
        } catch {
            fatalError("Initial file not found")
        }
        initSystemLogger()
        initMatrixSetter()
        initBackgroundColorHandler()
        ScriptService.shared.jsContext.evaluateScript(mainScript)
    }
    
    let systemLog: @convention(block) (String) -> Void = { log in
        print(log)
    }
    
    func initSystemLogger() {
        let systemLogObject = unsafeBitCast(self.systemLog, to: AnyObject.self)
     
        self.jsContext.setObject(systemLogObject, forKeyedSubscript: "systemLog" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("systemLog")
    }
    
    // MARK:- Set background color
    
    let setBackground: @convention(block) ([Double]) -> Void = { color in
        ScriptService.shared.renderer.mtkView.clearColor = MTLClearColor(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
    }
    
    func initBackgroundColorHandler() {
        let setBackgroundObject = unsafeBitCast(self.setBackground, to: AnyObject.self)
     
        self.jsContext.setObject(setBackgroundObject, forKeyedSubscript: "setViewBackground" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("setViewBackground")
    }
    
    // MARK:- Get projection matrix
    
    let setMatrix: @convention(block) ([[Double]], Int32) -> Void = { matrix, index in
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
        
        ScriptService.shared.renderer.setMatrixBuffer(resMatrix, 2)
    }
    
    func initMatrixSetter() {
        let setMatrixObject = unsafeBitCast(self.setMatrix, to: AnyObject.self)
     
        self.jsContext.setObject(setMatrixObject, forKeyedSubscript: "setMatrix" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("setMatrix")
    }
}
