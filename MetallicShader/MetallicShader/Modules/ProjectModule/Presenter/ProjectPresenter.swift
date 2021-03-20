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
    
    func refreshShader(shader: String) {
        interactor.refreshShader(shader: shader)
    }
}

extension ProjectPresenter: ProjectInteractorOutput {
    func initialShaderFetched(shader: String) {
        view.showInitialShader(shader: shader)
    }
    
    func willShowKeyboard(frame: CGRect) {
        view.willShowKeyboard(frame: frame)
    }
    
    func willHideKeyboard() {
        view.willHideKeyboard()
    }
}
