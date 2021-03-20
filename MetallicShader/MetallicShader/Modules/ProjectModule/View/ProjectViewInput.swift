//
//  ProjectViewInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

protocol ProjectViewInput: AnyObject {
    func showInitialShader(shader: String)
    func willShowKeyboard(frame: CGRect)
    func willHideKeyboard()
}
