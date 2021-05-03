//
//  ProjectViewController.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit
import MetalKit

class ProjectViewController: UIViewController {

    @IBOutlet fileprivate weak var mtkView: MTKView!
    @IBOutlet fileprivate weak var shaderEditorView: UITextView!
    @IBOutlet fileprivate weak var editorResizeBtn: UIButton!
    
    @IBOutlet fileprivate weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var shaderEditorTopToContainer: NSLayoutConstraint!
    @IBOutlet fileprivate weak var shaderEditorTopToNavigation: NSLayoutConstraint!
    
    var output: ProjectViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.mtkViewDidLoad(mtkView)
    }
}

// MARK: Input

extension ProjectViewController: ProjectViewInput {
    func showText(_ text: String) {
        shaderEditorView.text = text
    }
    
    func willShowKeyboard(frame: CGRect, duration: Double, curve: UInt) {
        keyboardHeight.constant = -frame.size.height
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: UIView.KeyframeAnimationOptions(rawValue: curve),
                                animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func willHideKeyboard() {
        keyboardHeight.constant = 0
    }
    
    func expandEditor() {
        shaderEditorTopToContainer.isActive = false
        shaderEditorTopToNavigation.isActive = true
        UIView.animate(withDuration: 0.4,
            animations: {[weak self] () -> Void in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
        editorResizeBtn.setTitle("Collapse", for: .normal)
    }
    
    func collapseEditor() {
        shaderEditorTopToContainer.isActive = true
        shaderEditorTopToNavigation.isActive = false
        UIView.animate(withDuration: 0.4,
            animations: {[weak self] () -> Void in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
        editorResizeBtn.setTitle("Expand", for: .normal)
    }
}

//MARK: - Actions

extension ProjectViewController {
    @IBAction func backPressed(_ sender: Any) {
        output.backPressed()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        output.refreshShader(shader: shaderEditorView.text)
    }
    
    @IBAction func resizeEditorPressed(_ sender: Any) {
        output.resizeEditorPressed()
    }
    
    @IBAction func switchTextEditingType(_ sender: Any) {
        output.switchTextSource(shaderEditorView.text)
    }
}
