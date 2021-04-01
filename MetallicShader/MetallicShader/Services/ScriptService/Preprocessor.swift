//
//  Preprocessor.swift
//  MetallicShader
//
//  Created by Aleks on 28.03.2021.
//

import Foundation

class Preprocessor {
    func replaceParamsToFunc(program: String, funcName: String, replaceParams: String) -> String {
        
        let lexer = Lexer(program: program)
        
        do {
            while true {
                var token = try lexer.nextToken()
                if token.type == .VERTEX {
                    token = try lexer.nextToken()
                    while token.type == .LINEBREAK { token = try lexer.nextToken() }
                    if token.type == .VALUE_TYPE {
                        token = try lexer.nextToken()
                        while token.type == .LINEBREAK { token = try lexer.nextToken() }
                        if token.type == .IDENTIFIER {
                            if token.value != funcName { continue }
                            token = try lexer.nextToken()
                            while token.type == .LINEBREAK { token = try lexer.nextToken() }
                            if token.type == .LEFT_BRACKET {
                                let startIndex = token.start
                                token = try lexer.nextToken()
                                while token.type == .LINEBREAK { token = try lexer.nextToken() }
                                if token.type == .RIGHT_BRACKET {
                                    var resultProg = program
                                    resultProg.insert(contentsOf: replaceParams, at: program.index(program.startIndex, offsetBy: startIndex))
                                    return resultProg
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
