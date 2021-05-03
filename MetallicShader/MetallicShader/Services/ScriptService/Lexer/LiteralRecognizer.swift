//
//  StringStateMachine.swift
//  MetallicShader
//
//  Created by Aleksandr Borodulin on 29.04.2021.
//

import Foundation
import GameplayKit

class LiteralStateMachine: GKStateMachine {
    init() {
        super.init(states: [Start(), End(), Symbol(), BackSlashActive(), BackSlashInactive()])
        self.enter(Start.self)
    }
    override init(states: [GKState]) {
        super.init(states: states)
    }
}

class Start: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == Symbol.self ||
            stateClass == End.self
    }
}

class End: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}

class Symbol: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == BackSlashActive.self ||
            stateClass == End.self
    }
}

class BackSlashActive: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == BackSlashInactive.self ||
            stateClass == Symbol.self
    }
}

class BackSlashInactive: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == Symbol.self ||
            stateClass == End.self
    }
}
