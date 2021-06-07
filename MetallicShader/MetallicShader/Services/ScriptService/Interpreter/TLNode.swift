//
//  TLNode.swift
//  MetallicShader
//
//  Created by Aleks on 03.04.2021.
//

import Foundation

protocol TLNodeProtocol {
    func execute() throws
}

class TextArray {
    private var debugText = [String]()
    
    func linesCount() -> Int {
        return debugText.count
    }
    
    func appendLine(_ str: String) {
        debugText.append(str)
    }
    
    func lineAtIndex(_ index: Int) -> String {
        return debugText[index]
    }
    
    func setLineAtIndex(str: String, index: Int) {
        debugText[index] = str
    }
    
    func printText() {
        for line in debugText {
            print(line)
        }
    }
}

class TLNode: TLNodeProtocol {
    private(set) var env: TLEnvironment!
    var leftNode: TLNode?
    var rightNode: TLNode?
    
    //debug
    static var nodeCounter = 0
    var nodeNumber = 0
    private var debugText = TextArray()
    var nodeName: String {
        return "Node"
    }
    var startTextIndex = 0
    var endTextIndex = 0
    var level = 0
    
    init(env: TLEnvironment, lexer: Lexer) throws {
        self.env = env
        self.leftNode = nil
        
        nodeNumber = Self.nodeCounter
        Self.nodeCounter += 1
    }
    
    func execute() throws {
        try leftNode?.execute()
        try rightNode?.execute()
    }
    
    func debug() {
        leftNode?.level = level + 1
        rightNode?.level = level + 1
        leftNode?.debugText = debugText
        leftNode?.startTextIndex = startTextIndex
        leftNode?.debug()
        
        if let leftNodeEndIndex = leftNode?.endTextIndex, leftNodeEndIndex > 0 {
            rightNode?.startTextIndex = leftNodeEndIndex + 1
        } else {
            rightNode?.startTextIndex = startTextIndex
        }
        
        rightNode?.debugText = debugText
        rightNode?.debug()
        
        if nodeNumber == 162 {
            print("Success");
        }
        
        startTextIndex = leftNode?.startTextIndex ?? startTextIndex
        endTextIndex = rightNode?.endTextIndex ?? startTextIndex
        while debugText.linesCount() < ((level + 1) * 2 - 1) {
            debugText.appendLine("")
        }
        var debugString = debugText.lineAtIndex(level * 2)
        
        while debugString.count < startTextIndex {
            debugString += " "
        }
        
        let tempEndTextIndex = endTextIndex
        
        while debugString.count < (startTextIndex + ((tempEndTextIndex - startTextIndex) - nodeName.count) / 2) {
            debugString += " "
            endTextIndex += 1
        }
        
        debugString += nodeName
        while debugString.count > endTextIndex {
            endTextIndex += 1
        }
        
        debugText.setLineAtIndex(str: debugString, index: level * 2)
    }
    
    func printDebug() {
        debugText.printText()
    }
}
