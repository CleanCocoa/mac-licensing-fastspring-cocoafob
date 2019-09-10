// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import class Foundation.UserDefaults

public class TrialProvider {
    public init() { }

    lazy var userDefaults: Foundation.UserDefaults = .standard

    public var trialPeriod: TrialPeriod? {
        guard let startDate = userDefaults.date(forTrialKey: .startDate),
            let endDate = userDefaults.date(forTrialKey: .endDate)
            else { return nil }
                
        return TrialPeriod(startDate: startDate, endDate: endDate)
    }

    public func trial(clock: Clock) -> Trial? {
        guard let trialPeriod = self.trialPeriod
            else { return nil }

        return Trial(trialPeriod: trialPeriod, clock: clock)
    }
}

extension Foundation.UserDefaults {
    func date(forTrialKey trialKey: TrialPeriod.DefaultsKey) -> Date? {
        return self.object(forKey: trialKey.rawValue) as? Date
    }
}
