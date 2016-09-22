// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class TrialWriter {
    
    public init() { }
    
    lazy var userDefaults: Foundation.UserDefaults = MyNewApp.UserDefaults.standardUserDefaults()
    
    public func store(trialPeriod: TrialPeriod) {
        
        userDefaults.set(trialPeriod.startDate, forKey: TrialPeriod.UserDefaultsKeys.StartDate.rawValue)
        userDefaults.set(trialPeriod.endDate, forKey: TrialPeriod.UserDefaultsKeys.EndDate.rawValue)
    }
}
