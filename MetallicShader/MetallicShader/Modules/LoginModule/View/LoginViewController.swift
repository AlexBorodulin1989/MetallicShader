//
//  LoginViewController.swift
//  MetallicShader
//
//  Created by Aleks on 03.05.2021.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
    }
}
