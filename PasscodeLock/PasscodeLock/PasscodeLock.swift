//
//  PasscodeLock.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
import LocalAuthentication

open class PasscodeLock: PasscodeLockType {
    
    open weak var delegate: PasscodeLockTypeDelegate?
    open let configuration: PasscodeLockConfigurationType
    
    open var repository: PasscodeRepositoryType {
        return configuration.repository
    }
    
    open var state: PasscodeLockStateType {
        return lockState
    }
    
    open var isBioAuthAllowed: Bool {
        return isBioAuthEnabled() && configuration.isBioAuthAllowed && lockState.isBioAuthAllowed
    }
    
    fileprivate var lockState: PasscodeLockStateType
    fileprivate lazy var passcode = String()
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType) {
        
        precondition(configuration.passcodeLength > 0, "Passcode length sould be greather than zero.")
        
        self.lockState = state
        self.configuration = configuration
    }
    
    open func addSign(_ sign: String) {
        
        passcode.append(sign)
        delegate?.passcodeLock(self, addedSignAt: passcode.count - 1)
        
        if passcode.count >= configuration.passcodeLength {
            
            lockState.accept(passcode: passcode, from: self)
            passcode.removeAll(keepingCapacity: true)
        }
    }
    
    open func removeSign() {
        
        guard passcode.count > 0 else { return }
        passcode.remove(at: passcode.index(before: passcode.endIndex))
        //passcode.removeLast()
        delegate?.passcodeLock(self, removedSignAt: passcode.utf8.count)
    }
    
    open func changeState(_ state: PasscodeLockStateType) {
        
        lockState = state
        delegate?.passcodeLockDidChangeState(self)
    }
    
    open func authenticateWithBio() {
        
        guard isBioAuthAllowed else { return }
        
        let context = LAContext()
        let reason = localizedStringFor("PasscodeLockBioAuthReason", comment: "Biometrics authentication reason")

        context.localizedFallbackTitle = localizedStringFor("PasscodeLockBioAuthButton", comment: "Biometric authentication fallback button")
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            success, error in
            
            self.handleBioAuthResult(success)
        }
    }
    
    fileprivate func handleBioAuthResult(_ success: Bool) {
        
        DispatchQueue.main.async {
            
            if success {
                
                self.delegate?.passcodeLockDidSucceed(self)
            }
        }
    }
    
    fileprivate func isBioAuthEnabled() -> Bool {
        
        let context = LAContext()
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
