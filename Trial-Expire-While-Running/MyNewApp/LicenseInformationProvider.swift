// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseInformationProvider {
    
    let trialProvider: TrialProvider
    let licenseProvider: LicenseProvider
    let clock: KnowsTimeAndDate
    
    public init(trialProvider: TrialProvider, licenseProvider: LicenseProvider, clock: KnowsTimeAndDate) {
        
        self.trialProvider = trialProvider
        self.licenseProvider = licenseProvider
        self.clock = clock
    }
    
    public var currentLicenseInformation: LicenseInformation {
        
        if let license = self.license() {
            
            return .Registered(license)
        }
        
        if let trial = self.trial() where !trial.ended {
            
            return .OnTrial(trial.trialPeriod)
        }
        
        return .TrialUp
    }
    
    func trial() -> Trial? {
        
        return trialProvider.currentTrialWithClock(clock)
    }
    
    func license() -> License? {
        
        return licenseProvider.currentLicense
    }
}
