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
    
    var editorFullSize = false
    
    var textInputShader = true
    var script: String!
    
    deinit {
        unsubscribeKeyboardNotify()
    }
}

extension ProjectInteractor: ProjectInteractorInput {
    func mtkViewDidLoad(_ mtkView: MTKView) {
        
        subscribeKeyboardNotify()
        
        let mtlpath = Bundle.main.path(forResource: "InitialShader", ofType: "txt")
        let scriptpath = Bundle.main.path(forResource: "Test", ofType: "tl")
        do {
            let shader = try String(contentsOfFile:mtlpath!, encoding: String.Encoding.utf8)
            script = try String(contentsOfFile:scriptpath!, encoding: String.Encoding.utf8)
            
            renderer = Renderer(metalView: mtkView, shader: shader, script: script)
            output.setEditingText(shader)
        } catch {
            fatalError("Initial file not found")
        }
    }
    
    func refreshProject(_ currentText: String) {
        if textInputShader {
            renderer.refresh(shader: currentText, script: script)
        } else {
            renderer.refresh(shader: script, script: currentText)
        }
    }
    
    func resizeEditorPressed() {
        editorFullSize = !editorFullSize
        output.showEditorFullSize(editorFullSize)
    }
    
    func switchTextSource(_ currentText: String) {
        textInputShader = !textInputShader
        output.setEditingText(script)
        script = currentText
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
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        output.willShowKeyboard(frame: frame, duration: duration, curve: curve)
    }
    
    @objc func willHideKeyboard() {
        output.willHideKeyboard()
    }
}
