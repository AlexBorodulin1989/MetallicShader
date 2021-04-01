//
//  Lexer.swift
//  MetallicShader
//
//  Created by Aleks on 28.03.2021.
//

import Foundation

struct Token {
    var type = TokenType.UNKNOWN
    var start = 0
    var end = 0;
    var value = ""
}

enum TokenType {
    case UNKNOWN
    case EMPTY
    case IDENTIFIER
    case VERTEX
    case FRAGMENT
    case VALUE_TYPE
    case LINEBREAK
    case LEFT_BRACKET
    case RIGHT_BRACKET
    case LEFT_CURLY_BRACE
    case RIGHT_CURLY_BRACE
    case SEMICOLON
    case COMMA
    case POINT
};

enum LexerError: Error {
    case endTokens
}

class Lexer {
    let keywords: [String: TokenType] = ["vertex": .VERTEX, "fragment": .FRAGMENT, "float4": .VALUE_TYPE]
    
    private var tokens = [Token]()
    
    private var currentIndex = 0
    
    func nextToken() throws -> Token {
        if currentIndex < tokens.count {
            let token = tokens[currentIndex]
            currentIndex += 1
            return token
        }
        
        throw LexerError.endTokens
    }
    
    init(program: String) {
        
        var buffer = ""
        
        let progWithEndElement = program + "?"
        
        var charIndex = 0
        for char in progWithEndElement {
            
            if ("\(char)".range(of: "[^a-zA-Z0-9_]", options: .regularExpression) == nil) {
                buffer += "\(char)"
            } else {
                if (!buffer.isEmpty) {
                    let endIndex = charIndex - 1
                    let startIndex = endIndex - (buffer.count - 1)
                    if let type = keywords[buffer] {
                        tokens.append(Token(type: type, start: startIndex, end: endIndex, value: buffer))
                    } else {
                        tokens.append(Token(type: .IDENTIFIER, start: startIndex, end: endIndex, value: buffer))
                    }
                    
                    buffer = ""
                }
                
                let endIndex = charIndex
                let startIndex = endIndex - (buffer.count - 1)
                let val = "\(char)"
                
                //Space will not take part in sintax
                if (val != " ") {
                    if (val == "(") {
                        tokens.append(Token(type: .LEFT_BRACKET, start: startIndex, end: endIndex, value: val))
                    } else if (val == ")") {
                        tokens.append(Token(type: .RIGHT_BRACKET, start: startIndex, end: endIndex, value: val))
                    } else if (val == "{") {
                        tokens.append(Token(type: .LEFT_CURLY_BRACE, start: startIndex, end: endIndex, value: val))
                    } else if (val == "}") {
                        tokens.append(Token(type: .RIGHT_CURLY_BRACE, start: startIndex, end: endIndex, value: val))
                    } else if (val == ";") {
                        tokens.append(Token(type: .SEMICOLON, start: startIndex, end: endIndex, value: val))
                    } else if (val == ",") {
                        tokens.append(Token(type: .COMMA, start: startIndex, end: endIndex, value: val))
                    }else if (val == ".") {
                        tokens.append(Token(type: .POINT, start: startIndex, end: endIndex, value: val))
                    } else if (val == "\n") {
                        tokens.append(Token(type: .LINEBREAK, start: startIndex, end: endIndex, value: val))
                    } else {
                        tokens.append(Token(type: .UNKNOWN, start: startIndex, end: endIndex, value: val))
                    }
                }
            }
            
            charIndex += 1
        }
    }
}
