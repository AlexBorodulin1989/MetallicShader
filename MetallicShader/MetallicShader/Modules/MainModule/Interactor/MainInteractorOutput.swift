//
//  MainInteractorOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import CoreData

protocol MainInteractorOutput: AnyObject {
    func createFetchController(fetchController: NSFetchedResultsController<Project>)
}
