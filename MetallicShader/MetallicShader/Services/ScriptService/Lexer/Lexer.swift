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

enum TokenType: Int {
    case UNKNOWN
    case STRING
    case FLOAT
    case INT
    case EMPTY
    case IDENTIFIER
    case VERTEX
    case FRAGMENT
    case VALUE_TYPE
    case RIGHT_BRACKET
    case LEFT_BRACKET
    case LEFT_CURLY_BRACE
    case RIGHT_CURLY_BRACE
    case LEFT_SQUARE_BRACKET
    case RIGHT_SQUARE_BRACKET
    case SEMICOLON
    case COMMA
    case POINT
    case ASSIGN
    case FUNCTION
    case PLUS
    case MINUS
    case MUL
    case DIV
};

enum LexerError: Error {
    case endTokens
}

class Lexer {
    let keywords: [String: TokenType] = ["vertex": .VERTEX,
                                         "fragment": .FRAGMENT,
                                         "float4": .VALUE_TYPE,
                                         "float": .VALUE_TYPE,
                                         "int": .VALUE_TYPE,
                                         "string": .VALUE_TYPE,
                                         "void": .VALUE_TYPE]
    
    private var tokens = [Token]()
    
    private var currentIndex = 0
    
    private var currentToken: Token? //Dont set public access!
    
    let programText: [String.Element]
    private var currentSymbolIndex = 0
    
    init(program: String) {
        programText = Array(program)
        
        var buffer = ""
        let chars = Array(program)
        
        while(!endProgram()) {
            // This is simple case only for testing need to implement state machine for cases sach as \n, \t, \\, \"
            if match("\"") {
                let literalSM = LiteralStateMachine()
                let startIndex = currentSymbolIndex - 1
                
                while !endProgram() && !match("\"") {
                    buffer += "\(currentSymbol())"
                    let _ = match(currentSymbol())
                }
                let endIndex = currentSymbolIndex - 1
                
                tokens.append(Token(type: .STRING, start: startIndex, end: endIndex, value: buffer))
                buffer = ""
            } else if isDigit(currentSymbol()) {
                buffer += "\(currentSymbol())"
                let startIndex = currentSymbolIndex - 1
                let _ = match(currentSymbol())
                while !endProgram() && isDigit(currentSymbol()) {
                    buffer += "\(currentSymbol())"
                    let _ = match(currentSymbol())
                }
                
                if !endProgram() && match(".") {
                    buffer += "."
                    while !endProgram() && isDigit(currentSymbol()) {
                        buffer += "\(currentSymbol())"
                        let _ = match(currentSymbol())
                    }
                    
                    let endIndex = currentSymbolIndex - 1
                    tokens.append(Token(type: .FLOAT, start: startIndex, end: endIndex, value: buffer))
                } else {
                    let endIndex = currentSymbolIndex - 1
                    tokens.append(Token(type: .INT, start: startIndex, end: endIndex, value: buffer))
                }
                
                buffer = ""
            } else if isID("\(currentSymbol())") {
                buffer += "\(currentSymbol())"
                let startIndex = currentSymbolIndex
                let _ = match(currentSymbol())
                while !endProgram() && isID("\(currentSymbol())") {
                    buffer += "\(currentSymbol())"
                    let _ = match(currentSymbol())
                }
                
                let endIndex = currentSymbolIndex - 1
                
                if let type = keywords[buffer] {
                    tokens.append(Token(type: type, start: startIndex, end: endIndex, value: buffer))
                } else {
                    while !endProgram() && "\(currentSymbol())" == " " {let _ = match(currentSymbol())} // check on tabs
                    if !endProgram() && "\(currentSymbol())" == "(" {
                        tokens.append(Token(type: .FUNCTION, start: startIndex, end: currentSymbolIndex, value: buffer))
                        let _ = match(currentSymbol())
                    } else {
                        tokens.append(Token(type: .IDENTIFIER, start: startIndex, end: endIndex, value: buffer))
                    }
                }
                
                buffer = ""
            } else {
                let endIndex = currentSymbolIndex
                let startIndex = currentSymbolIndex
                let val = "\(currentSymbol())"
                
                //Space linebreak will not take part in sintax
                if (val != " " && val != "\n") {
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
                    } else if (val == ".") {
                        tokens.append(Token(type: .POINT, start: startIndex, end: endIndex, value: val))
                    } else if (val == "=") {
                        tokens.append(Token(type: .ASSIGN, start: startIndex, end: endIndex, value: val))
                    } else if (val == "[") {
                        tokens.append(Token(type: .LEFT_SQUARE_BRACKET, start: startIndex, end: endIndex, value: val))
                    } else if (val == "]") {
                        tokens.append(Token(type: .RIGHT_SQUARE_BRACKET, start: startIndex, end: endIndex, value: val))
                    } else if (val == "+") {
                        tokens.append(Token(type: .PLUS, start: startIndex, end: endIndex, value: val))
                    } else if (val == "-") {
                        tokens.append(Token(type: .MINUS, start: startIndex, end: endIndex, value: val))
                    } else if (val == "*") {
                        tokens.append(Token(type: .MUL, start: startIndex, end: endIndex, value: val))
                    } else if (val == "/") {
                        tokens.append(Token(type: .DIV, start: startIndex, end: endIndex, value: val))
                    } else {
                        tokens.append(Token(type: .UNKNOWN, start: startIndex, end: endIndex, value: val))
                    }
                }
                let _ = match(currentSymbol())
            }
        }
        
        currentToken = tokens[currentIndex]
    }
    
    func match(_ symbol: String.Element) -> Bool {
        if endProgram() {
            return false
        }
        let currentSymbol = programText[currentSymbolIndex]
        if currentSymbol == symbol {
            currentSymbolIndex += 1
            return true
        }
        return false
    }
    
    func currentSymbol() -> String.Element {
        if endProgram() {
            return "\u{1F1F7}\u{1F1FA}"
        }
        let currentSymbol = programText[currentSymbolIndex]
        return currentSymbol
    }
    
    func endProgram() -> Bool {
        if currentSymbolIndex >= programText.count {
            return true
        }
        return false
    }
    
    private func isID(_ str: String) -> Bool {
        return str.range(of: "[^a-zA-Z0-9_]", options: .regularExpression) == nil
    }
    
    func isDigit(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }
    
    func nextToken() throws -> Token {
        currentIndex += 1
        if currentIndex < tokens.count {
            let token = tokens[currentIndex]
            return token
        }
        
        throw LexerError.endTokens
    }
    
    func currentValue() -> String? {
        return currentToken?.value
    }
    
    func match(_ tokenType: TokenType) -> Bool {
        if tokenType == currentToken?.type {
            currentToken = try? self.nextToken()
            return true
        }
        return false
    }
    
    func lookahead() -> TokenType? {
        let lookaheadIndex = currentIndex + 1
        if lookaheadIndex < tokens.count {
            return tokens[lookaheadIndex].type
        }
        return nil
    }
    
    func currentType() -> TokenType? {
        if currentIndex < tokens.count {
            return tokens[currentIndex].type
        }
        return nil
    }
    
    func valueType() -> TLType {
        var type: TLType
        switch currentValue() {
        case "int":
            type = .INTEGER
        case "float":
            type = .FLOAT
        case "string":
            type = .STRING
        default:
            type = .UNKNOWN
        }
        
        return type
    }
}
