// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class TrialTimer {
    let trialEndDate: Date
    let licenseChangeBroadcaster: LicenseChangeBroadcaster
    
    public init(trialEndDate: Date, licenseChangeBroadcaster: LicenseChangeBroadcaster) {
        self.trialEndDate = trialEndDate
        self.licenseChangeBroadcaster = licenseChangeBroadcaster
    }

    deinit {
        stop()
    }

    public var isRunning: Bool {
        return hasValue(timerWorkItem)
    }

    private var timerWorkItem: DispatchWorkItem?

    public func start() {
        guard !isRunning else {
            NSLog("Invalid re-starting of a running timer")
            return
        }

        NSLog("Starting trial timer for: \(trialEndDate)")
        self.timerWorkItem = dispatch(fireAt: trialEndDate) { [unowned self] in
            self.timerDidFire()
        }
    }

    fileprivate func timerDidFire() {
        self.timerWorkItem = nil
        self.licenseChangeBroadcaster.broadcast(.trialExpired)
    }

    public func stop() {
        guard isRunning else { return }
        self.timerWorkItem?.cancel()
        self.timerWorkItem = nil
    }
}

fileprivate func dispatch(fireAt deadline: Date,
                          queue: DispatchQueue = .main,
                          block: @escaping () -> Void) -> DispatchWorkItem {
    let workItem = DispatchWorkItem(block: block)
    let delay = Int(deadline.timeIntervalSinceNow)
    queue.asyncAfter(wallDeadline: .now() + .seconds(delay), execute: workItem)
    return workItem
}
