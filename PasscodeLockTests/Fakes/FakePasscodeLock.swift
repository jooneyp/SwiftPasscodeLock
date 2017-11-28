//
//  FakePasscodeLock.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeLock: PasscodeLockType {
    
    weak var delegate: PasscodeLockTypeDelegate?
    let configuration: PasscodeLockConfigurationType
    var repository: PasscodeRepositoryType { return configuration.repository }
    var state: PasscodeLockStateType { return lockState }
    let isBioAuthAllowed = false
    var lockState: PasscodeLockStateType
    
    var changeStateCalled = false
    
    init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType) {
        
        self.lockState = state
        self.configuration = configuration
    }
    
    func addSign(_ sign: String) {
        
    }
    
    func removeSign() {
        
    }
    
    func changeState(_ state: PasscodeLockStateType) {
        
        lockState = state
        changeStateCalled = true
        delegate?.passcodeLockDidChangeState(self)
    }
    
    func authenticateWithBio() {
        
    }
}
