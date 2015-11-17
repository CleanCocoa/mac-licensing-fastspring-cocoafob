// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct TrialPeriod {
    
    public let startDate: NSDate
    public let endDate: NSDate
    
    public init(startDate aStartDate: NSDate, endDate anEndDate: NSDate) {
        
        startDate = aStartDate
        endDate = anEndDate
    }
    
    public init(numberOfDays daysLeft: Days, clock: KnowsTimeAndDate) {
        
        startDate = clock.now()
        endDate = startDate.dateByAddingTimeInterval(daysLeft.timeInterval)
    }
}

extension TrialPeriod {

    public func ended(clock: KnowsTimeAndDate) -> Bool {
        
        let now = clock.now()
        return endDate.laterDate(now) == now
    }
    
    public func daysLeft(clock: KnowsTimeAndDate) -> Days {
        
        let now = clock.now()
        let timeUntil = now.timeIntervalSinceDate(endDate)
        
        return Days(timeInterval: timeUntil)
    }
}

extension TrialPeriod {
    
    public enum UserDefaultsKeys: String, CustomStringConvertible {
        
        case StartDate = "trial_starting"
        case EndDate = "trial_ending"
        
        public var description: String { return rawValue }
    }
}

extension TrialPeriod: Equatable { }

public func ==(lhs: TrialPeriod, rhs: TrialPeriod) -> Bool {
    
    return lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate
}
