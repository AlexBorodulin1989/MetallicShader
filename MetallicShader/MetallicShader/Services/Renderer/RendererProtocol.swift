//
//  RendererProtocol.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

protocol RendererProtocol {
    func refresh(shader: String, script: String)
}
