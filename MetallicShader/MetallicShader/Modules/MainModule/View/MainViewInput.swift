//
//  MainViewInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import CoreData

protocol MainViewInput: AnyObject {
    func injectFetchController(fetchController: NSFetchedResultsController<Project>)
}
