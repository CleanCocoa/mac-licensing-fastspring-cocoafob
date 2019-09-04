// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

fileprivate extension License {
    func isValid(licenseVerifier: LicenseVerifier) -> Bool {
        return licenseVerifier.isValid(licenseCode: licenseCode, forName: name)
    }
}

public class LicensingProvider {
    let trialProvider: TrialProvider
    let licenseProvider: LicenseProvider
    let clock: KnowsTimeAndDate
    
    public init(trialProvider: TrialProvider,
                licenseProvider: LicenseProvider,
                clock: KnowsTimeAndDate) {
        
        self.trialProvider = trialProvider
        self.licenseProvider = licenseProvider
        self.clock = clock
    }
    
    public lazy var licenseVerifier: LicenseVerifier = LicenseVerifier()
    
    public var licenseIsInvalid: Bool {
        
        guard let license = self.license else {
            return false
        }
        
        return !license.isValid(licenseVerifier: licenseVerifier)
    }
    
    public var licensing: Licensing {
        
        if let license = self.license,
            license.isValid(licenseVerifier: licenseVerifier) {
            
            return .registered(license)
        }
        
        if let trial = self.trial,
            trial.isActive {
            
            return .trial(trial.trialPeriod)
        }
        
        return .trialUp
    }
    
    fileprivate var license: License? {
        
        return licenseProvider.license
    }
    
    fileprivate var trial: Trial? {
        
        return trialProvider.trial(clock: clock)
    }
}
