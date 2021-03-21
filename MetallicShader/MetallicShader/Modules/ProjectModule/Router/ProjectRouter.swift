//
//  Router.swift
//  MetallicShader
//
//  Created by Aleks on 21.03.2021.
//

import UIKit

class ProjectRouter: ProjectRouterInput {
    weak var viewController: UIViewController?
    
    func back() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
