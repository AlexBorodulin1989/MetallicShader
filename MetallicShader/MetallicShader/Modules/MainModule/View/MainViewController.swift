//
//  ViewController.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    var output: MainViewOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: - Actions

extension MainViewController {
    @IBAction func newProjectAction(_ sender: Any) {
        output.addProjectPressed()
    }
}
