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
    
    let licenseProvider: LicenseProvider
    
    public init(licenseProvider: LicenseProvider) {
        
        self.licenseProvider = licenseProvider
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
        
        return .Unregistered
    }
    
    func license() -> License? {
        
        return licenseProvider.currentLicense
    }
}
