//
//  ProjectPresenterProtocol.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

protocol ProjectViewOutput {
    func mtkViewDidLoad(_ mtkView: MTKView)
    func refreshShader(shader: String)
    func backPressed()
    func resizeEditorPressed()
    func switchTextSource(_ currentText: String)
}
