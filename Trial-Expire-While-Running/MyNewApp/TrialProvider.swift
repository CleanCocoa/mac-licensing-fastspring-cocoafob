// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import class Foundation.UserDefaults

public class TrialProvider {

    public init() { }

    lazy var userDefaults: Foundation.UserDefaults = .standard

    public var trialPeriod: TrialPeriod? {
        
        guard let startDate = userDefaults.object(forKey: TrialPeriod.UserDefaultsKeys.startDate.rawValue) as? Date,
            let endDate = userDefaults.object(forKey: TrialPeriod.UserDefaultsKeys.endDate.rawValue) as? Date
            else { return nil }
                
        return TrialPeriod(startDate: startDate, endDate: endDate)
    }

    public func trial(clock: KnowsTimeAndDate) -> Trial? {
        
        guard let trialPeriod = self.trialPeriod else {
            return nil
        }

        return Trial(trialPeriod: trialPeriod, clock: clock)
    }
}
