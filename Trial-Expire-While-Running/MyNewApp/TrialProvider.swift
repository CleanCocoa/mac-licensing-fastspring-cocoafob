// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class TrialProvider {
    
    public init() { }
    
    lazy var userDefaults: Foundation.UserDefaults = MyNewApp.UserDefaults.standardUserDefaults()

    public var currentTrialPeriod: TrialPeriod? {
        
        if let startDate = userDefaults.object(forKey: "\(TrialPeriod.UserDefaultsKeys.StartDate)") as? Date,
            let endDate = userDefaults.object(forKey: "\(TrialPeriod.UserDefaultsKeys.EndDate)") as? Date {
                
            return TrialPeriod(startDate: startDate, endDate: endDate)
        }
        
        return .none
    }
    
    public func currentTrial(clock: KnowsTimeAndDate) -> Trial? {
        
        if let trialPeriod = currentTrialPeriod {
            
            return Trial(trialPeriod: trialPeriod, clock: clock)
        }
        
        return .none
    }
}
