//
//  Renderer+Script.swift
//  MetallicShader
//
//  Created by alexbor on 28.04.2021.
//

import Foundation
import MetalKit

extension Renderer {
    func setScriptSystemFunctions() {
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "setViewBackground") {[weak self] params -> TLObject? in
            if params.count > 2 {
                self?.mtkView.clearColor = MTLClearColor(red: Double(params[0] as? Float ?? 0), green:  Double(params[1] as? Float ?? 0), blue: Double(params[2] as? Float ?? 0), alpha: 1.0)
            }
            return nil
        })
        
        let matrixToArray = {(_ matrix: float4x4) -> [Any] in
            var resultArray = [Any]()
            for i in 0...3 {
                var rowArray = [Any]()
                for c in 0...3 {
                    rowArray.append(matrix[i][c])
                }
                resultArray.append(rowArray)
            }
            
            return resultArray
        }
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "setMatrix", callback: {[weak self] params -> TLObject? in
            guard params.count == 2,
                  let matrix = params[0] as? [Any],
                  let name = params[1] as? String
            else {
                return nil
            }
            
            var resMatrix = float4x4.identity()
            
            if matrix.count == 4 {
                for i in 0...3 {
                    guard let row = matrix[i] as? [Float] else { return nil }
                    if row.count == 4 {
                        for c in 0...3 {
                            resMatrix[i][c] = Float(row[c]);
                        }
                    }
                }
            }
            
            self?.setMatrixBuffer(resMatrix, name)
            
            return nil
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "resetMatrix", callback: {[weak self] params -> TLObject? in
            guard params.count == 2,
                  let matrix = params[0] as? [Any],
                  let name = params[1] as? String
            else {
                return nil
            }
            
            var resMatrix = float4x4.identity()
            
            if matrix.count == 4 {
                for i in 0...3 {
                    guard let row = matrix[i] as? [Float] else { return nil }
                    if row.count == 4 {
                        for c in 0...3 {
                            resMatrix[i][c] = Float(row[c]);
                        }
                    }
                }
            }
            
            self?.resetMatrixBuffer(resMatrix, name)
            
            return nil
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "projectionMatrix", callback: { params -> TLObject? in
            guard params.count == 4
            else {
                print("Not correct number of params");
                return nil
            }
            let fov = params[0] as? Float ?? Float(params[0] as? Int ?? 0)
            let near = params[1] as? Float ?? Float(params[1] as? Int ?? 0)
            let far = params[2] as? Float ?? Float(params[2] as? Int ?? 0)
            let ratio = params[3] as? Float ?? Float(params[3] as? Int ?? 0)
            let projectionMatrix = float4x4(projectionFov: Float(fov).degreesToRadians,
                                            near: near,
                                            far: far,
                                            aspect: ratio)
            
            let resultArray = matrixToArray(projectionMatrix)
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "viewMatrix", callback: { params -> TLObject? in
            guard params.count == 3
            else {
                print("Not correct number of params");
                return nil
            }
            let x = params[0] as? Float ?? Float(params[0] as? Int ?? 0)
            let y = params[1] as? Float ?? Float(params[1] as? Int ?? 0)
            let z = params[2] as? Float ?? Float(params[2] as? Int ?? 0)
            let viewMatrix = float4x4(translation: [x, y, z])
            
            let resultArray = matrixToArray(viewMatrix)
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "modelMatrix", callback: { params -> TLObject? in
            guard params.count == 3
            else {
                print("Not correct number of params");
                return nil
            }
            let x = params[0] as? Float ?? Float(params[0] as? Int ?? 0)
            let y = params[1] as? Float ?? Float(params[1] as? Int ?? 0)
            let z = params[2] as? Float ?? Float(params[2] as? Int ?? 0)
            let viewMatrix = float4x4(translation: [x, y, z])
            
            let resultArray = matrixToArray(viewMatrix)
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "translateMatrix", callback: { params -> TLObject? in
            guard params.count == 3
            else {
                print("Not correct number of params");
                return nil
            }
            let x = params[0] as? Float ?? Float(params[0] as? Int ?? 0)
            let y = params[1] as? Float ?? Float(params[1] as? Int ?? 0)
            let z = params[2] as? Float ?? Float(params[2] as? Int ?? 0)
            let translation = float4x4(translation: [x, y, z])
            
            let resultArray = matrixToArray(translation)
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "rotateMatrix", callback: { params -> TLObject? in
            guard params.count == 3
            else {
                print("Not correct number of params");
                return nil
            }
            let x = params[0] as? Float ?? Float(params[0] as? Int ?? 0)
            let y = params[1] as? Float ?? Float(params[1] as? Int ?? 0)
            let z = params[2] as? Float ?? Float(params[2] as? Int ?? 0)
            let rotation = float4x4(rotation: [Float(x).degreesToRadians, Float(y).degreesToRadians, Float(z).degreesToRadians])
            
            let resultArray = matrixToArray(rotation)
            
            return TLObject(type: .ARRAY, value: resultArray, identifier: "", subtype: .FLOAT, size: 4)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "getScreenSize", callback: { params -> TLObject? in
            
            var size = [Float]()
            
            size.append(Float(self.mtkView.bounds.width))
            size.append(Float(self.mtkView.bounds.height))
            
            return TLObject(type: .ARRAY, value: size, identifier: "", subtype: .FLOAT, size: 2)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "getScreenWidth", callback: { params -> TLObject? in
            
            return TLObject(type: .FLOAT, value: Float(self.mtkView.bounds.width), identifier: "", subtype: nil, size: 0)
        }))
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "getScreenHeight", callback: { params -> TLObject? in
            
            return TLObject(type: .FLOAT, value: Float(self.mtkView.bounds.height), identifier: "", subtype: nil, size: 0)
        }))
    }
}
