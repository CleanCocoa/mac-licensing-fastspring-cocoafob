// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

fileprivate extension License {
    
    func isValid(licenseVerifier: LicenseVerifier) -> Bool {
        
        return licenseVerifier.isValid(licenseCode: licenseCode, forName: name)
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
        
        guard let license = self.license() else {
            return false
        }
        
        return !license.isValid(licenseVerifier: licenseVerifier)
    }
    
    public var currentLicenseInformation: LicenseInformation {
        
        if let license = self.license(),
            license.isValid(licenseVerifier: licenseVerifier) {
            
            return .Registered(license)
        }
        
        if let trial = self.trial(),
            trial.isActive {
            
            return .OnTrial(trial.trialPeriod)
        }
        
        return .TrialUp
    }
    
    func license() -> License? {
        
        return licenseProvider.currentLicense
    }
    
    func trial() -> Trial? {
        
        return trialProvider.currentTrial(clock: clock)
    }
}
