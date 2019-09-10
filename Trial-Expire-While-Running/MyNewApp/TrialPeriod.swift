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

    public init(numberOfDays daysLeft: Days, clock: Clock) {
        startDate = clock.now()
        endDate = startDate.addingTimeInterval(daysLeft.timeInterval)
    }
}

extension TrialPeriod {
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
