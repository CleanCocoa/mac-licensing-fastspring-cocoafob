// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import class Foundation.UserDefaults

public class TrialWriter {
    public init() { }

    lazy var userDefaults: Foundation.UserDefaults = .standard

    public func store(trialPeriod: TrialPeriod) {
        userDefaults.set(trialPeriod.startDate, forTrialKey: .startDate)
        userDefaults.set(trialPeriod.endDate, forTrialKey: .endDate)
    }
}

extension Foundation.UserDefaults {
    func set(_ date: Date, forTrialKey trialKey: TrialPeriod.DefaultsKey) {
        self.set(date, forKey: trialKey.rawValue)
    }
}
