//
//  Analizator.swift
//  MetallicShader
//
//  Created by Aleks on 31.03.2021.
//

import Foundation

class TLInterpreter {
    var lookahead: Token?
    var lexer: Lexer!
    
    private var subscribedFunctions = Set<String>()
    
    var stringIterator: StringIterator!
    
    //Intermediate values
    var functName: String!
    var num = ""
    var functParams = [Float]()
    
    func subscribeToFunction(_ functName: String) {
        subscribedFunctions.insert(functName)
        print("Succces")
    }
    
    func startInterpret(lexer: Lexer) {
        self.lexer = lexer
        if let lookAhead = try? self.lexer.nextToken() {
            lookahead = lookAhead
            functCall()
        } else {
            print("Expression is not a function")
        }
    }
    
    private func match(_ tokenType: TokenType) -> Bool {
        if tokenType == lookahead?.type {
            lookahead = try? lexer.nextToken()
            if lookahead?.type == .LINEBREAK {
                let _ = match(.LINEBREAK)
            }
            return true
        }
        return false
    }
}

/*
functCall -> id(optparams
optparams -> params | );
params -> param, params | param);
param -> number | String
*/

extension TLInterpreter {
    
    func functCall() {
        functName = lookahead?.value ?? ""
        if match(.IDENTIFIER) && match(.LEFT_BRACKET) {
            optparams()
        } else {
            print("Expression is not a function")
        }
    }
    
    func optparams() {
        if match(.RIGHT_BRACKET) && match(.SEMICOLON) {
            callToSubscribedFunct()
            return
        }
        
        functParams = []
        params()
    }
    
    func params() {
        if parseNumber() {
            functParams.append((num as NSString).floatValue)
            if match(.COMMA) {
                params()
                return
            } else if match(.RIGHT_BRACKET)
                        && match(.SEMICOLON) {
                callToSubscribedFunct()
                return
            }
        }
        
        print("Expression is not a function")
    }
    
    func callToSubscribedFunct() {
        if subscribedFunctions.contains(functName) {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: functName),
                object: functParams,
                userInfo: nil
            )
        } else {
            print("Function is not defined")
        }
    }
}

/*
number -> digit integer
integer -> digit integer | empty
empty -> . fraction | e
fraction -> digit fraction | e
digit -> 0|1|2|3|4|5|6|7|8|9
*/

extension TLInterpreter {
    
    func parseNumber() -> Bool {
        stringIterator = StringIterator(str: lookahead?.value ?? "")
        num = lookahead?.value ?? ""
        if match(.IDENTIFIER) {
            if number() {
                return true
            }
        }
        return false
    }
    
    func number() -> Bool  {
        if stringIterator.isDigit() == .digit {
            return integer()
        }
        return false
    }
    
    func integer() -> Bool {
        
        let charType = stringIterator.isDigit()
        if charType == .digit {
            return integer()
        } else if charType != .empty {
            return false
        }
        return empty()
    }
    
    func empty() -> Bool {
        if match(.POINT) {
            return initFraction()
        } else {
            return true
        }
    }
    
    func initFraction() -> Bool {
        let value = lookahead?.value ?? ""
        
        if match(.IDENTIFIER) {
            stringIterator = StringIterator(str: value)
            num += ("." + value)
            return fraction()
        }
        return true
    }
    
    func fraction() -> Bool {
        let charType = stringIterator.isDigit()
        if charType == .digit {
            return fraction()
        } else if charType != .empty {
            return false
        }
        return true
    }
}
