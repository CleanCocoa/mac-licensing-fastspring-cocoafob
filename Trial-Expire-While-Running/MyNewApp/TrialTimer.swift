// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

typealias CancelableDispatchBlock = (_ cancel: Bool) -> Void

func dispatch(cancelableBlock block: @escaping () -> Void, atDate date: Date) -> CancelableDispatchBlock? {
    
    // Use two pointers for the same block handle to make
    // the block reference itself.
    var cancelableBlock: CancelableDispatchBlock? = nil
    
    let delayBlock: CancelableDispatchBlock = { cancel in
        
        if !cancel {
            DispatchQueue.main.async(execute: block)
        }
        
        cancelableBlock = nil
    }
    
    cancelableBlock = delayBlock
    
    let delay = Int(date.timeIntervalSinceNow)
    DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + .seconds(delay)) {
        
        if hasValue(cancelableBlock) {
            cancelableBlock!(false)
        }
    }
    
    return cancelableBlock
}

func cancelBlock(_ block: CancelableDispatchBlock?) {
    
    if hasValue(block) {
        block!(true)
    }
}

public class TrialTimer {
    
    let trialEndDate: Date
    let licenseChangeBroadcaster: LicenseChangeBroadcaster
    
    public init(trialEndDate: Date, licenseChangeBroadcaster: LicenseChangeBroadcaster) {
        
        self.trialEndDate = trialEndDate
        self.licenseChangeBroadcaster = licenseChangeBroadcaster
    }
    
    public var isRunning: Bool {
        
        return hasValue(delayedBlock)
    }
    
    var delayedBlock: CancelableDispatchBlock?
    
    public func start() {
        
        guard !isRunning else {
            NSLog("invalid re-starting of a running timer")
            return
        }
        
        guard let delayedBlock = dispatch(cancelableBlock: timerDidFire, atDate: trialEndDate) else {
            fatalError("Cannot create a cancellable timer.")
        }
        
        NSLog("Starting trial timer for: \(trialEndDate)")
        self.delayedBlock = delayedBlock
    }
    
    fileprivate func timerDidFire() {
        
        licenseChangeBroadcaster.broadcast(.trialUp)
    }
    
    public func stop() {
        
        guard isRunning else {
            NSLog("attempting to stop non-running timer")
            return
        }
        
        cancelBlock(delayedBlock)
    }
}
