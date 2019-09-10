// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

public class LicensingProvider {
    let trialProvider: TrialProvider
    let licenseProvider: LicenseProvider
    let clock: Clock
    
    public init(trialProvider: TrialProvider,
                licenseProvider: LicenseProvider,
                clock: Clock) {
        self.trialProvider = trialProvider
        self.licenseProvider = licenseProvider
        self.clock = clock
    }

    public var licensing: Licensing {
        if let license = self.license {
            return .registered(license)
        }
        
        if let trial = self.trial {
            return .trial(trial.trialPeriod)
        }
        
        return .trialExpired
    }

    /// Valid license.
    fileprivate var license: License? {
        return licenseProvider.license
    }

    /// Active trial.
    fileprivate var trial: Trial? {
        guard let trial = trialProvider.trial(clock: clock) else { return nil }
        guard trial.isActive else { return nil }
        return trial
    }
}
