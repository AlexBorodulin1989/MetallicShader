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
    @IBOutlet fileprivate weak var keyboardHeight: NSLayoutConstraint!
    
    var output: ProjectViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.mtkViewDidLoad(mtkView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: Input

extension ProjectViewController: ProjectViewInput {
    func showInitialShader(shader: String) {
        shaderEditorView.text = shader
    }
    
    func willShowKeyboard(frame: CGRect) {
        keyboardHeight.constant = -frame.size.height
    }
    
    func willHideKeyboard() {
        keyboardHeight.constant = 0
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
}
