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
    
    fileprivate var jsContext: JSContext! {
        didSet {
            initBackgroundColorHandler()
        }
    }
    
    weak var mtkView: MTKView!
    
    func reloadService(script: String) {
        ScriptService.shared.jsContext = JSContext()
        ScriptService.shared.jsContext.evaluateScript(script)
    }
    
    let setBackground: @convention(block) ([Double]) -> Void = { color in
        ScriptService.shared.mtkView.clearColor = MTLClearColor(red: color[0], green: color[1], blue: color[2], alpha: 1.0)
    }
    
    func initBackgroundColorHandler() {
        let setBackgroundObject = unsafeBitCast(self.setBackground, to: AnyObject.self)
     
        self.jsContext.setObject(setBackgroundObject, forKeyedSubscript: "setViewBackground" as (NSCopying & NSObjectProtocol))
        
        _ = self.jsContext.evaluateScript("setViewBackground")
    }
}
