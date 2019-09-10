// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import struct Foundation.Date

public struct TrialPeriod {
    public let startDate: Date
    public let endDate: Date

    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension TrialPeriod {
    public init(numberOfDays duration: Days, clock: Clock) {
        let startDate = clock.now()
        let endDate = startDate.addingTimeInterval(duration.timeInterval)
        self.init(startDate: startDate, endDate: endDate)
    }
    
    public func ended(clock: Clock) -> Bool {
        let now = clock.now()
        return endDate < now
    }

    public func daysLeft(clock: Clock) -> Days {
        let now = clock.now()
        let timeUntil = now.timeIntervalSince(endDate)
        return Days(timeInterval: timeUntil)
    }
}

extension TrialPeriod {
    internal struct DefaultsKey: RawRepresentable {
        let rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        static let startDate = DefaultsKey(rawValue: "trial_starting")
        static let endDate = DefaultsKey(rawValue: "trial_ending")
    }
}

extension TrialPeriod: Equatable { }
