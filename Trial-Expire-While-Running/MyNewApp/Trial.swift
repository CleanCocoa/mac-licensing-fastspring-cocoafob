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
