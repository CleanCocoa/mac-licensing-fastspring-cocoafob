import Foundation

public protocol KnowsTimeAndDate {
    
    func now() -> NSDate
}

public class Clock: KnowsTimeAndDate {
    
    public init() { }
    
    public func now() -> NSDate {
        return NSDate()
    }
}

public struct Trial {
    
    public let trialPeriod: TrialPeriod
    public let clock: KnowsTimeAndDate
    
    public init(trialPeriod: TrialPeriod, clock: KnowsTimeAndDate) {
        
        self.trialPeriod = trialPeriod
        self.clock = clock
    }
    
    public var daysLeft: Int {
        return trialPeriod.daysLeft(clock).userFacingAmount
    }
    
    public var ended: Bool {
        return trialPeriod.ended(clock)
    }
}
