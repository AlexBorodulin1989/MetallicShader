//
//  StringExtension.swift
//  MetallicShader
//
//  Created by Aleks on 05.04.2021.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
