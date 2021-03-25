//
//  MainInteractorOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import RealmSwift

protocol MainInteractorOutput: AnyObject {
    func projectResultsFetched(results: Results<Project>)
}
