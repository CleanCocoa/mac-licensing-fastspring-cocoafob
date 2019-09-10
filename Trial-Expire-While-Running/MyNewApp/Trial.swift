// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public struct Trial {
    
    public let trialPeriod: TrialPeriod
    public let clock: Clock
    
    public init(trialPeriod: TrialPeriod, clock: Clock) {
        
        self.trialPeriod = trialPeriod
        self.clock = clock
    }
    
    public var daysLeft: Int {
        return trialPeriod.daysLeft(clock: clock).userFacingAmount
    }
    
    public var isExpired: Bool {
        return trialPeriod.isExpired(clock: clock)
    }
    
    public var isActive: Bool {
        return !isExpired
    }
}
