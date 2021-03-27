//
//  ProjectViewInput.swift
//  MetallicShader
//
//  Created by Aleks on 20.03.2021.
//

import UIKit

protocol ProjectViewInput: AnyObject {
    func showText(_ text: String)
    func willShowKeyboard(frame: CGRect, duration: Double, curve: UInt)
    func willHideKeyboard()
    func expandEditor()
    func collapseEditor()
}
