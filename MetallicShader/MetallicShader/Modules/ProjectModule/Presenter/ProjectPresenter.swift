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
    var router: ProjectRouterInput!
}

extension ProjectPresenter: ProjectViewOutput {
    func mtkViewDidLoad(_ mtkView: MTKView) {
        interactor.mtkViewDidLoad(mtkView)
    }
    
    func refreshShader(shader: String) {
        interactor.refreshShader(shader: shader)
    }
    
    func backPressed() {
        router.back()
    }
    
    func resizeEditorPressed() {
        interactor.resizeEditorPressed()
    }
}

extension ProjectPresenter: ProjectInteractorOutput {
    func initialShaderFetched(shader: String) {
        view.showInitialShader(shader: shader)
    }
    
    func willShowKeyboard(frame: CGRect, duration: Double, curve: UInt) {
        view.willShowKeyboard(frame: frame, duration: duration, curve: curve)
    }
    
    func willHideKeyboard() {
        view.willHideKeyboard()
    }
    
    func showEditorFullSize(_ fullSize: Bool) {
        if fullSize {
            view.expandEditor()
        } else {
            view.collapseEditor()
        }
    }
}
