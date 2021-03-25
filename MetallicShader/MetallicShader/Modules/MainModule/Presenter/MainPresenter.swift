//
//  MainPresenter.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import RealmSwift

class MainPresenter {
    weak var view: MainViewInput!
    var router: MainRouterInput!
    var interactor: MainInteractorInput!
}

extension MainPresenter: MainViewOutput {
    func onViewDidLoad() {
        interactor.initRealm()
    }
    
    func addProjectPressed() {
        router.addNewProjectAlert()
    }
    
    func selectRow() {
        router.showProject()
    }
}

extension MainPresenter: MainInteractorOutput {
    func projectResultsFetched(results: Results<Project>) {
        view.injectProjectResults(results: results)
    }
}

extension MainPresenter: MainRouterOutput {
    func addNewProject(name: String) {
        interactor.addProject(name: name)
        router.showProject()
    }
}
