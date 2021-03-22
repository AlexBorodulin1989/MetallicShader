//
//  MainInteractor.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import CoreData

class MainInteractor {
    weak var output: MainInteractorOutput!
}

extension MainInteractor: MainInteractorInput {
    func addProject(name: String) {
        CoreDataManager.shared.createProject(name: name)
    }
    
    func initFetchController() {
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:CoreDataManager.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        output.createFetchController(fetchController: fetchedResultsController)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("\(error)")
        }
    }
}
