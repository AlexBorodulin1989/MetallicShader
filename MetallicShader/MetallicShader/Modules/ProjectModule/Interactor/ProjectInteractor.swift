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
    
    deinit {
        unsubscribeKeyboardNotify()
    }
}

extension ProjectInteractor: ProjectInteractorInput {
    func mtkViewDidLoad(_ mtkView: MTKView) {
        
        subscribeKeyboardNotify()
        
        let path = Bundle.main.path(forResource: "InitialShader", ofType: "txt")
        do {
            let shader = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            renderer = Renderer(metalView: mtkView, shader: shader)
            output.initialShaderFetched(shader: shader)
        } catch {
            fatalError("Initial file not found")
        }
    }
    
    func refreshShader(shader: String) {
        renderer.refreshShader(shader: shader)
    }
}

// MARK: Keyboard State

private extension ProjectInteractor {
    func subscribeKeyboardNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardNotify() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        output.willShowKeyboard(frame: frame)
    }
    
    @objc func willHideKeyboard() {
        output.willHideKeyboard()
    }
}
