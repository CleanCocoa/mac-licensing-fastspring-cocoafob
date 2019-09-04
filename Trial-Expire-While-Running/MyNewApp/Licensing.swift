// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

public enum Licensing {
    case registered(License)
    case onTrial(TrialPeriod)
    case trialUp
}

extension Licensing: Equatable { }

public func ==(lhs: Licensing, rhs: Licensing) -> Bool {
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
