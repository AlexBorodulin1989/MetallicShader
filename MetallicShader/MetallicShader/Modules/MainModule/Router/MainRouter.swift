//
//  MainRouter.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

class MainRouter: MainRouterInput {
    weak var view: UIViewController!
    weak var output: MainRouterOutput!
    
    func addNewProjectAlert() {
        let alert = UIAlertController(title: "Add new project", message: "Set project name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "New project"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] (_) in
            let text = alert?.textFields![0].text ?? "New project"
            self?.output.addNewProject(name: text)
        }))
        
        view.present(alert, animated: true, completion: nil)
    }
    
    func showProject() {
        view.performSegue(withIdentifier: "ProjectSegue", sender: nil)
    }
}
