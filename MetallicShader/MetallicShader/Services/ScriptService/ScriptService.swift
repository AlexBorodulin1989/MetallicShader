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
        
        let callback = TLCallbackInfo(identifier: "logger") { params -> TLObject? in
            print(params.first ?? "")
            return nil
        }
        
        instance.addCallback(callback)
        
        instance.addCallback(TLCallbackInfo(identifier: "testFunc", callback: { params -> TLObject? in
            return TLObject(type: .FLOAT, value: Float(0.5), identifier: "")
        }))
        
        instance.addCallback(TLCallbackInfo(identifier: "projectionMatrix", callback: { params -> TLObject? in
            guard params.count == 4,
                  let fov = params[0] as? Float,
                  let near = params[1] as? Float,
                  let far = params[2] as? Float,
                  let ratio = params[3] as? Float
            else {
                return nil
            }
            let projectionMatrix = float4x4(projectionFov: Float(fov).degreesToRadians,
                                            near: near,
                                            far: far,
                                            aspect: ratio)
            
            var resultArray = [Any]()
            
            for i in 0...3 {
                var rowArray = [Any]()
                for c in 0...3 {
                    rowArray.append(projectionMatrix[i][c])
                }
                resultArray.append(rowArray)
            }
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        return instance
    }()
    
    var initBlockID: Int = 0
    
    weak var renderer: Renderer!
    
    var scriptValues = [String : ScriptValue]()
    
    let interpreter = TLInterpreter()
    
    var queue: DispatchQueue!
    
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
