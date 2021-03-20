//
//  VolumeItem.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

class VolumeItem {
    static func createBox(device: MTLDevice) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [1, 1, 1],
                           segments: [1, 1, 1],
                           inwardNormals: false,
                           geometryType: .triangles,
                           allocator: allocator)
        
        return mesh
    }
}
