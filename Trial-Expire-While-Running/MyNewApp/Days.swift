import Foundation

public struct Days {
    
    public static func timeIntervalFromAmount(amount: Double) -> Double {
        return amount * 60 * 60 * 24
    }
    
    public static func amountFromTimeInterval(timeInterval: NSTimeInterval) -> Double {
        return timeInterval / 60 / 60 / 24
    }
    
    public let amount: Double
    
    /// Rounded to the next integer.
    public var userFacingAmount: Int {
        
        return Int(ceil(amount))
    }
    
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

extension Days: Equatable { }

public func ==(lhs: Days, rhs: Days) -> Bool {
    
    return lhs.amount == rhs.amount
}
