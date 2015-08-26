// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public protocol KnowsTimeAndDate: class {
    
    func now() -> NSDate
}

public class Clock: KnowsTimeAndDate {
    
    public init() { }
    
    public func now() -> NSDate {
        
        return NSDate()
    }
}

public class StaticClock: KnowsTimeAndDate {
    
    let date: NSDate
    
    public init(clockDate: NSDate) {
        
        date = clockDate
    }
    
    public func now() -> NSDate {
        
        return date
    }
}
