// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

typealias CancelableDispatchBlock = (cancel: Bool) -> Void

func dispatch(cancelableBlock block: dispatch_block_t, atDate date: NSDate) -> CancelableDispatchBlock? {
    
    // Use two pointers for the same block handle to make
    // the block reference itself.
    var cancelableBlock: CancelableDispatchBlock? = nil
    
    let delayBlock: CancelableDispatchBlock = { cancel in
        
        if !cancel {
            dispatch_async(dispatch_get_main_queue(), block)
        }
        
        cancelableBlock = nil
    }
    
    cancelableBlock = delayBlock
    
    let interval = Int64(date.timeIntervalSinceNow)
    let delay = interval * Int64(NSEC_PER_SEC)
    
    dispatch_after(dispatch_walltime(nil, delay), dispatch_get_main_queue()) {
        
        if hasValue(cancelableBlock) {
            cancelableBlock!(cancel: false)
        }
    }
    
    return cancelableBlock
}

func cancelBlock(block: CancelableDispatchBlock?) {
    
    if hasValue(block) {
        block!(cancel: true)
    }
}

public class TrialTimer {
    
    let trialEndDate: NSDate
    let licenseChangeBroadcaster: LicenseChangeBroadcaster
    
    public init(trialEndDate: NSDate, licenseChangeBroadcaster: LicenseChangeBroadcaster) {
        
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
    
    private func timerDidFire() {
        
        licenseChangeBroadcaster.broadcast(.TrialUp)
    }
    
    public func stop() {
        
        guard isRunning else {
            NSLog("attempting to stop non-running timer")
            return
        }
        
        cancelBlock(delayedBlock)
    }
}
