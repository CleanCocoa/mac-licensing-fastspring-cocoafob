// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

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

    public var licensing: Licensing {
        if let license = self.license {
            return .registered(license)
        }
        
        if let trial = self.trial {
            return .trial(trial.trialPeriod)
        }
        
        return .trialUp
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
