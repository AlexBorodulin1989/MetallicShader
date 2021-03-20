//
//  ProjectInteractor.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

class ProjectInteractor {
    private var renderer: Renderer!
    weak var output: ProjectInteractorOutput!
}

extension ProjectInteractor: ProjectInteractorInput {
    func mtkViewDidLoad(_ mtkView: MTKView) {
        let path = Bundle.main.path(forResource: "InitialShader", ofType: "txt")
        do {
            let shader = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            renderer = Renderer(metalView: mtkView, shader: shader)
            output.initialShaderFetched(shader: shader)
        } catch {
            fatalError("Initial file not found")
        }
    }
}
