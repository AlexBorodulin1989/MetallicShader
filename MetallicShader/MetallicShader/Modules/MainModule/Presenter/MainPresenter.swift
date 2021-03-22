//
//  MainPresenter.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import CoreData

class MainPresenter {
    weak var view: MainViewInput!
    var router: MainRouterInput!
    var interactor: MainInteractorInput!
}

extension MainPresenter: MainViewOutput {
    func onViewDidLoad() {
        interactor.initFetchController()
    }
    
    func addProjectPressed() {
        router.addNewProjectAlert()
    }
    
    func selectRow() {
        router.showProject()
    }
}

extension MainPresenter: MainInteractorOutput {
    func createFetchController(fetchController: NSFetchedResultsController<Project>) {
        view.injectFetchController(fetchController: fetchController)
    }
}

extension MainPresenter: MainRouterOutput {
    func addNewProject(name: String) {
        interactor.addProject(name: name)
        router.showProject()
    }
}
