//
//  ProjectInteractorOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

protocol ProjectInteractorOutput: AnyObject {
    func initialShaderFetched(shader: String)
    func willShowKeyboard(frame: CGRect)
    func willHideKeyboard()
}
