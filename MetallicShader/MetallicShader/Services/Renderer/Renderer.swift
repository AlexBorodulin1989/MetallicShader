//
//  Renderer.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

import MetalKit
import simd

struct Uniform {
    let name: String
    let buffer: MTLBuffer
}

class Renderer: NSObject {
    private(set) var device: MTLDevice!
    private(set) var commandQueue: MTLCommandQueue!
    private(set) var mesh: MTKMesh!
    private(set) var vertexBuffer: MTLBuffer!
    private(set) var pipelineState: MTLRenderPipelineState!
    unowned var mtkView: MTKView!
    
    var uniformDict = [String: Uniform]()
    
    var timer: Float = 0
    var shader: String = ""
    
    var shaderInitialized = false
    
    init(metalView: MTKView, shader: String, script: String) {
        super.init()
        
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        metalView.device = device
        
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        mtkView = metalView
        mtkView.isPaused = true
        mtkView.delegate = self
        
        setScriptSystemFunctions()
        
        ScriptService.shared.reloadService(script: script) {
        }
        self.setShader(shader: shader)
        self.mtkView.isPaused = false
        do {
            self.addMesh()
            self.addVertexBuffer()
            try self.createPipeline()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addMesh() {
        let mdlMesh = VolumeItem.createBox(device: device)
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addVertexBuffer() {
        vertexBuffer = mesh.vertexBuffers[0].buffer
    }
    
    func createPipeline() throws {
        
        let library = try device.makeLibrary(source: shader, options: nil)
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat
        
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let width = TLObject(type: .FLOAT, value: Float(size.width), identifier: "UpdateScreenSize", subtype: nil, size: 0)
        let height = TLObject(type: .FLOAT, value: Float(size.height), identifier: "UpdateScreenSize", subtype: nil, size: 0)
        ScriptService.shared.executeFunct(name: "UpdateScreenSize", params: [width, height])
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = mtkView.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)

        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        for (index, element) in uniformDict.values.enumerated() {
            renderEncoder.setVertexBuffer(element.buffer, offset: 0, index: index + 1)
        }
        
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }

        renderEncoder.endEncoding()

        guard let drawable = mtkView.currentDrawable else {
            fatalError()
        }

        commandBuffer.present(drawable)
        
        
        commandBuffer.commit()
    }
}

extension Renderer: RendererProtocol {
    func refresh(shader: String, script: String) {
        uniformDict = [String: Uniform]()
        shaderInitialized = false
        ScriptService.shared.reloadService(script: script) {}
        self.setShader(shader: shader)
        
        if self.pipelineState == nil {
            do {
                self.addMesh()
                self.addVertexBuffer()
                try self.createPipeline()
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            do {
                try self.createPipeline()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

// MARK:- Set Matrix buffer

extension Renderer {
    func setMatrixBuffer(_ buffer: float4x4, _ name : String) {
        if shaderInitialized {
            print("Set matrix not available after init")
            return
        }
        if let uniformBuffer = device.makeBuffer(length: MemoryLayout<float4x4>.size,
                                                 options: []) {
            memcpy(uniformBuffer.contents(), [buffer], MemoryLayout<float4x4>.size)
            uniformDict[name] = Uniform(name: name, buffer: uniformBuffer)
        }
    }
    
    func resetMatrixBuffer(_ buffer: float4x4, _ name : String) {
        if let uniformBuffer = device.makeBuffer(length: MemoryLayout<float4x4>.size,
                                                 options: []) {
            memcpy(uniformBuffer.contents(), [buffer], MemoryLayout<float4x4>.size)
            if uniformDict[name] == nil {
                print("No value to reset")
                return
            }
            uniformDict[name] = Uniform(name: name, buffer: uniformBuffer)
        }
    }
}

// MARK:- Set Shader

extension Renderer {
    func setShader(shader: String) {
        let preprocessor = Preprocessor()
        
        var paramStr = "const VertexIn vertex_in [[stage_in]]"
        
        for (index, element) in uniformDict.values.enumerated() {
            paramStr += ",constant matrix_float4x4 &\(element.name) [[buffer(\(index + 1))]]"
        }
        
        self.shader = preprocessor.replaceParamsToFunc(program: shader, funcName: "vertex_main", replaceParams: paramStr)
        shaderInitialized = true
    }
}

extension Renderer {
    func setScriptSystemFunctions() {
        
        ScriptService.shared.addCallback(TLCallbackInfo(identifier: "logger") { params -> TLObject? in
            print(params.first ?? "")
            return nil
        })
        
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
    }
}
