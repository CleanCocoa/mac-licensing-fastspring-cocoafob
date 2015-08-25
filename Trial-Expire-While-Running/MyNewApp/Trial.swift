import Foundation

public struct Days {
    
    public static func timeIntervalFromAmount(amount: Double) -> Double {
        return amount * 60 * 60 * 24
    }
    
    public static func amountFromTimeInterval(timeInterval: NSTimeInterval) -> Double {
        return timeInterval / 60 / 60 / 24
    }
    
    public let amount: Double
    
    public init(_ anAmount: Double) {
        amount = anAmount
    }
    
    public var timeInterval: NSTimeInterval {
        return Days.timeIntervalFromAmount(amount)
    }
    
    public var isPast: Bool {
        return amount < 0
    }
}

extension Days: Printable {
    
    public var description: String {
        return "\(amount)"
    }
}

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
    
    public func ended(clock: KnowsTimeAndDate) -> Bool {
        
        let now = clock.now()
        return endDate.laterDate(now) == now
    }
    
    public func daysLeft(clock: KnowsTimeAndDate) -> Days {
        
        let now = clock.now()
        let timeUntil = now.timeIntervalSinceDate(endDate)
        let daysUntil: Double = fabs(Days.amountFromTimeInterval(timeUntil))
        
        return Days(daysUntil)
    }
}

public protocol KnowsTimeAndDate {
    
    func now() -> NSDate
}

public class Clock: KnowsTimeAndDate {
    
    public func now() -> NSDate {
        return NSDate()
    }
}

public struct Trial {
    
    public let trialPeriod: TrialPeriod
    public let clock: KnowsTimeAndDate
    
    var daysLeft: Int {
        return Int(trialPeriod.daysLeft(clock).amount)
    }
    
    var ended: Bool {
        return trialPeriod.ended(clock)
    }
}
