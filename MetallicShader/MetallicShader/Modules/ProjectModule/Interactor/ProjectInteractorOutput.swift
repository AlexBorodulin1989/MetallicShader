//
//  ProjectInteractorOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import Foundation

protocol ProjectInteractorOutput: AnyObject {
    func initialShaderFetched(shader: String)
}
