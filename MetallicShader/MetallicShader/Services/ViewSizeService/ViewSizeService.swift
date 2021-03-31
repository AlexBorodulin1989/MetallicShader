//
//  JSViewSizeService.swift
//  MetallicShader
//
//  Created by Aleks on 29.03.2021.
//

import Foundation
import MetalKit

class ViewSizeService {
    func setSize(_ viewSize: CGSize) {
        ScriptService.shared.requestFunction(name: "UpdateViewSize") { function in
            function?.call(withArguments: [Double(viewSize.width), Double(viewSize.height)])
        }
    }
}
