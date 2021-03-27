//
//  ProjectInteractorOutput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

protocol ProjectInteractorOutput: AnyObject {
    func willShowKeyboard(frame: CGRect, duration: Double, curve: UInt)
    func willHideKeyboard()
    func showEditorFullSize(_ fullSize: Bool)
    func setEditingText(_ text: String)
}
