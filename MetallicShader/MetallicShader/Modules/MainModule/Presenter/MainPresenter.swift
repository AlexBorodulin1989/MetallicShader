//
//  MainPresenter.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

class MainPresenter: MainViewOutput {
    weak var view: MainViewInput!
    var router: MainRouterInput!
    
    func addProjectPressed() {
        router.moveToNewProject()
    }
}
