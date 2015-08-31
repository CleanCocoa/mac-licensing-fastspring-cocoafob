// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

extension License {
    
    func isValid(licenseVerifier: LicenseVerifier) -> Bool {
        
        return licenseVerifier.licenseCodeIsValid(licenseCode, forName: name)
    }
}

public class LicenseInformationProvider {
    
    let trialProvider: TrialProvider
    let licenseProvider: LicenseProvider
    let clock: KnowsTimeAndDate
    
    public init(trialProvider: TrialProvider, licenseProvider: LicenseProvider, clock: KnowsTimeAndDate) {
        
        self.trialProvider = trialProvider
        self.licenseProvider = licenseProvider
        self.clock = clock
    }
    
    public lazy var licenseVerifier: LicenseVerifier = LicenseVerifier()
    
    public var licenseIsInvalid: Bool {
        
        if let license = self.license() where !license.isValid(licenseVerifier) {
            return true
        }
        
        return false
    }
    
    public var currentLicenseInformation: LicenseInformation {
        
        if let license = self.license() where license.isValid(licenseVerifier) {
            
            return .Registered(license)
        }
        
        if let trial = self.trial() where trial.isActive {
            
            return .OnTrial(trial.trialPeriod)
        }
        
        return .TrialUp
    }
    
    func license() -> License? {
        
        return licenseProvider.currentLicense
    }
    
    func trial() -> Trial? {
        
        return trialProvider.currentTrialWithClock(clock)
    }
}
