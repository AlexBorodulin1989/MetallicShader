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
}

extension MainInteractor: MainInteractorInput {
    func addProject(name: String) {
    }
    
    func initRealm() {
        guard let realm = try? Realm() else { return }
        let results = realm.objects(Project.self)
        output.projectResultsFetched(results: results)
    }
}
