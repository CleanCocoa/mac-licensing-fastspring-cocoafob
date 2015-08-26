// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseInformationProvider {
    
    let licenseProvider: LicenseProvider
    
    public init(licenseProvider: LicenseProvider) {
        
        self.licenseProvider = licenseProvider
    }
    
    public var currentLicenseInformation: LicenseInformation {
        
        if let license = self.license() {
            
            return .Registered(license)
        }
        
        return .Unregistered
    }
    
    func license() -> License? {
        
        return licenseProvider.currentLicense
    }
}
