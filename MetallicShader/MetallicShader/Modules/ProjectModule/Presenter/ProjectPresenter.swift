//
//  ProjectPresenter.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import MetalKit

class ProjectPresenter {
    var interactor: ProjectInteractorInput!
    weak var view: ProjectViewInput!
}

extension ProjectPresenter: ProjectViewOutput {
    func mtkViewDidLoad(_ mtkView: MTKView) {
        interactor.mtkViewDidLoad(mtkView)
    }
}

extension ProjectPresenter: ProjectInteractorOutput {
    func initialShaderFetched(shader: String) {
        view.showInitialShader(shader: shader)
    }
}
