//
//  ProjectViewController.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit
import MetalKit

class ProjectViewController: UIViewController {

    @IBOutlet weak var mtkView: MTKView!
    @IBOutlet weak var shaderEditorView: UITextView!
    
    var output: ProjectViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.mtkViewDidLoad(mtkView)
    }
}

// MARK: Input

extension ProjectViewController: ProjectViewInput {
    func showInitialShader(shader: String) {
        shaderEditorView.text = shader
    }
}

//MARK: - Actions

extension ProjectViewController {
    @IBAction func refreshPressed(_ sender: Any) {
        output.refreshShader(shader: shaderEditorView.text)
    }
}
