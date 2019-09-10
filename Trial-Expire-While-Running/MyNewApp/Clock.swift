// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import struct Foundation.Date

public protocol Clock: class {
    func now() -> Date
}

public class SystemClock: Clock {
    public init() { }
    
    public func now() -> Date {
        return Date()
    }
}

public class StaticClock: Clock {
    let date: Date
    
    public init(date: Date) {
        self.date = date
    }
    
    public func now() -> Date {
        return date
    }
}
