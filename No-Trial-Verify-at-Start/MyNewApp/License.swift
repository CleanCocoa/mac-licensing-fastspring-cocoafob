// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct License {
    
    public let name: String
    public let licenseCode: String
    
    public init(name: String, licenseCode: String) {
        
        self.name = name
        self.licenseCode = licenseCode
    }
    
    enum UserDefaultsKeys: String, CustomStringConvertible {

        case name = "licensee"
        case licenseCode = "license_code"
        
        public var description: String { return rawValue }
    }
}

extension License: Equatable { }

public func ==(lhs: License, rhs: License) -> Bool {
    
    return lhs.name == rhs.name && lhs.licenseCode == rhs.licenseCode
}

public enum LicenseState {
    case unregistered
    case registered(License)
}

extension LicenseState: Equatable { }

public func ==(lhs: LicenseState, rhs: LicenseState) -> Bool {
    
    switch (lhs, rhs) {
    case (.unregistered, .unregistered): return true
    case let (.registered(lLicense), .registered(rLicense)): return lLicense == rLicense
    default: return false
    }
}
