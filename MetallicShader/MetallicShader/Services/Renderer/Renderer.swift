//
//  Renderer.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

import MetalKit
import simd

struct Uniforms {
    let modelMatrix: float4x4
    let viewMatrix: float4x4
    let projectionMatrix: float4x4
}

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
    
    var uniformArr = [Uniform]()
    
    var timer: Float = 0
    var shader: String = ""
    
    var uniforms: Uniforms!
    
    init(metalView: MTKView, shader: String) {
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
        metalView.delegate = self
        mtkView = metalView
        
        setupMVP(viewSize: metalView.bounds.size)
        
        ScriptService.shared.renderer = self
        ScriptService.shared.reloadService()
        
        setShader(shader: shader)
        
        do {
            addMesh()
            addVertexBuffer()
            try createPipeline()
        } catch {
            fatalError(error.localizedDescription)
        }
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
        setupMVP(viewSize: size)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = mtkView.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        
        renderEncoder.setRenderPipelineState(pipelineState)

        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        for (index, element) in uniformArr.enumerated() {
            renderEncoder.setVertexBuffer(element.buffer, offset: 0, index: index + 2)
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
        uniformArr = [Uniform]()
        ScriptService.shared.reloadService(script: script)
        setShader(shader: shader)
        do {
            try createPipeline()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK:- Setup MVP

extension Renderer {
    func setupMVP(viewSize: CGSize) {
        let translation = float4x4(translation: [0, -0.3, 0])
        let rotation = float4x4(rotation: [0, Float(45).degreesToRadians, 0])
        let modelMatrix = translation * rotation;
        let viewMatrix = float4x4(translation: [0.0, 0, -3]).inverse
        let ratio = Float(viewSize.width) / Float(viewSize.height)
        let projectionMatrix = float4x4(projectionFov: Float(45).degreesToRadians,
                                        near: 0.1,
                                        far: 100,
                                        aspect: ratio)
        
        uniforms = Uniforms(modelMatrix: modelMatrix, viewMatrix: viewMatrix, projectionMatrix: projectionMatrix)
    }
}

// MARK:- Set Matrix buffer

extension Renderer {
    func setMatrixBuffer(_ buffer: float4x4, _ name : String) {
        if let uniformBuffer = device.makeBuffer(length: MemoryLayout<float4x4>.size,
                                                 options: []) {
            memcpy(uniformBuffer.contents(), [buffer], MemoryLayout<float4x4>.size)
            
            uniformArr.append(Uniform(name: name, buffer: uniformBuffer))
        }
    }
}

// MARK:- Set Shader

extension Renderer {
    func setShader(shader: String) {
        let preprocessor = Preprocessor()
        
        var paramStr = "const VertexIn vertex_in [[stage_in]],constant Uniforms &uniforms [[buffer(1)]]"
        
        for (index, element) in uniformArr.enumerated() {
            paramStr += ",constant matrix_float4x4 &\(element.name) [[buffer(\(index + 2))]]"
        }
        
        self.shader = preprocessor.replaceParamsToFunc(program: shader, funcName: "vertex_main", replaceParams: paramStr)
    }
}
