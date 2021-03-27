//
//  ProjectInteractorInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

protocol ProjectInteractorInput {
    func mtkViewDidLoad(_ mtkView: MTKView)
    func refreshShader(shader: String)
    func resizeEditorPressed()
    func switchTextSource(_ currentText: String)
}
