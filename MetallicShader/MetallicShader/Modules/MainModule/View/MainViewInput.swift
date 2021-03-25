//
//  MainViewInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation
import RealmSwift

protocol MainViewInput: AnyObject {
    func injectProjectResults(results: Results<Project>)
}
