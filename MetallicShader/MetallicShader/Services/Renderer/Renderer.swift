//
//  Renderer.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

import MetalKit

class Renderer: NSObject {
    private(set) var device: MTLDevice!
    private(set) var commandQueue: MTLCommandQueue!
    private(set) var mesh: MTKMesh!
    private(set) var vertexBuffer: MTLBuffer!
    private(set) var pipelineState: MTLRenderPipelineState!
    unowned var mtkView: MTKView!
    
    var timer: Float = 0
    var shader: String = ""
    
    init(metalView: MTKView, shader: String) {
        super.init()
        
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        
        self.shader = shader
        
        self.device = device
        self.commandQueue = commandQueue
        metalView.device = device
        
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
        mtkView = metalView
        
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
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = mtkView.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        timer += 0.05
        var currentTime = sin(timer)
        
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 1)
        
        renderEncoder.setRenderPipelineState(pipelineState)

        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        //renderEncoder.setTriangleFillMode(.lines)
        
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
    func refreshShader(shader: String) {
        self.shader = shader
        do {
            try createPipeline()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
