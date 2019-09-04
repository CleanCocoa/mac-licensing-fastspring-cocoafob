// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

public enum LicenseState {
    case unregistered
    case registered(License)
}

extension LicenseState: Equatable { }

public func ==(lhs: LicenseState, rhs: LicenseState) -> Bool {
    switch (lhs, rhs) {
    case (.unregistered, .unregistered):
        return true

    case let (.registered(lLicense), .registered(rLicense)):
        return lLicense == rLicense

    default:
        return false
    }
}
