// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

public enum LicenseState {
    case registered(License)
    case onTrial(TrialPeriod)
    case trialUp
}

extension LicenseState: Equatable { }

public func ==(lhs: LicenseState, rhs: LicenseState) -> Bool {
    switch (lhs, rhs) {
    case (.trialUp, .trialUp):
        return true

    case let (.onTrial(lPeriod), .onTrial(rPeriod)):
        return lPeriod == rPeriod

    case let (.registered(lLicense), .registered(rLicense)):
        return lLicense == rLicense

    default:
        return false
    }
}
