//
//  MainViewOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

protocol MainViewOutput {
    func onViewDidLoad()
    func addProjectPressed()
    func selectRow()
    func deleteProject(_ project: Project)
}
