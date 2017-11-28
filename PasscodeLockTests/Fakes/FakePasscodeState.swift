//
//  FakePasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeState: PasscodeLockStateType {
    
    var title = "A"
    var description = "B"
    var isCancellableAction = true
    var isBioAuthAllowed = true
    
    var acceptPaccodeCalled = false
    var acceptedPasscode = String()
    var numberOfAcceptedPasscodes = 0
    
    init() {}
    
    func accept(passcode: String, from lock: PasscodeLockType) {
        
        acceptedPasscode = passcode
        acceptPaccodeCalled = true
        numberOfAcceptedPasscodes += 1
    }
}
