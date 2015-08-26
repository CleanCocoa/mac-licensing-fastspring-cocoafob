import Foundation

typealias CancelableDispatchBlock = (cancel: Bool) -> Void

func timespecFromInterval(interval: NSTimeInterval) -> timespec {
    
    let nowWholeSecsFloor = floor(interval)
    let nowNanosOnly = interval - nowWholeSecsFloor
    let nowNanosFloor = floor(nowNanosOnly * Double(NSEC_PER_SEC))
    
    return timespec(tv_sec: Int(nowWholeSecsFloor), tv_nsec: Int(nowNanosFloor))
}

func dispatchCancelableBlockAtDate(date: NSDate, block: dispatch_block_t) -> CancelableDispatchBlock? {
    
    var cancelableBlock: CancelableDispatchBlock? = nil
    
    var delayBlock: CancelableDispatchBlock = { (cancel: Bool) -> Void in
        
        if !cancel {
            dispatch_async(dispatch_get_main_queue(), block)
        }
        
        cancelableBlock = nil
    }
    
    cancelableBlock = delayBlock
    
//    let interval = date.timeIntervalSince1970
//    var time = timespecFromInterval(interval)
//    
//    dispatch_after(dispatch_walltime(&time, 0), dispatch_get_main_queue()) {

    let interval = Int64(date.timeIntervalSinceNow)
    let delay = interval * Int64(NSEC_PER_SEC)

    dispatch_after(dispatch_walltime(nil, delay), dispatch_get_main_queue()) {
    
        if hasValue(cancelableBlock) {
            cancelableBlock!(cancel: false)
        }
    }
    
    return cancelableBlock
}

func dispatchCancelableBlockAfterDelay(delay: Double, block: dispatch_block_t) -> CancelableDispatchBlock? {
    
    return dispatchCancelableBlockAtDate(NSDate(timeIntervalSinceNow: delay), block)
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
        
        if isRunning {
            NSLog("invalid re-starting of a running timer")
            return
        }
        
        if let delayedBlock = dispatchCancelableBlockAtDate(trialEndDate, timerDidFire) {
            
            NSLog("Starting trial timer for: \(trialEndDate)")
            self.delayedBlock = delayedBlock
        }
    }
    
    private func timerDidFire() {
        
        licenseChangeBroadcaster.broadcast(.TrialUp)
    }
    
    public func stop() {
        
        if !isRunning {
            NSLog("attempting to stop non-running timer")
            return
        }
        
        cancelBlock(delayedBlock)
    }
}
