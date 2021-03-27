//
//  MainInteractor.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import CoreData
import RealmSwift

class MainInteractor {
    weak var output: MainInteractorOutput!
    
    var projectToDelete: Project!
}

extension MainInteractor: MainInteractorInput {
    func addProject(name: String) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            let newProject = Project(name: name)
            realm.add(newProject, update: .modified)
            
            ProjectNetworkService.defaultItem.postProjects([newProject]) { result in}
        }
    }
    
    func initRealm() {
        guard let realm = try? Realm() else { return }
        let results = realm.objects(Project.self)
        output.projectResultsFetched(results: results)
    }
    
    func deleteProject(_ project: Project) {
        projectToDelete = project
        output.makeSureDeleteProject()
    }
    
    func deleteProjectAccepted() {
        guard let realm = try? Realm() else { return }
        
        ProjectNetworkService.defaultItem.deleteProjects([projectToDelete]) { result in}
        
        try? realm.write {
            realm.delete(projectToDelete)
        }
    }
}
