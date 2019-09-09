// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import class Foundation.UserDefaults

public class TrialWriter {
    
    public init() { }
    
    lazy var userDefaults: Foundation.UserDefaults = .standard
    
    public func store(trialPeriod: TrialPeriod) {
        
        userDefaults.set(trialPeriod.startDate, forKey: TrialPeriod.UserDefaultsKeys.startDate.rawValue)
        userDefaults.set(trialPeriod.endDate, forKey: TrialPeriod.UserDefaultsKeys.endDate.rawValue)
    }
}
