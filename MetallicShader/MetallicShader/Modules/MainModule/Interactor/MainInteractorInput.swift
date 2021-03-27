//
//  MainInteractorInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func addProject(name: String)
    func initRealm()
    func deleteProject(_ project: Project)
    func deleteProjectAccepted()
}
