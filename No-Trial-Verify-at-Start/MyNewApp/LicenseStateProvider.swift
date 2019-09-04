// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

extension License {
    
    func isValid(_ licenseVerifier: LicenseVerifier) -> Bool {
        
        return licenseVerifier.isValid(licenseCode: licenseCode, forName: name)
    }
}

open class LicenseStateProvider {
    
    let licenseProvider: LicenseProvider
    
    public init(licenseProvider: LicenseProvider) {
        
        self.licenseProvider = licenseProvider
    }

    open lazy var licenseVerifier: LicenseVerifier = LicenseVerifier()
    
    open var licenseIsInvalid: Bool {
        
        guard let license = self.license else {
            return false
        }
        
        return !license.isValid(licenseVerifier)
    }
    
    open var licenseState: LicenseState {
        
        guard let license = self.license,
            license.isValid(licenseVerifier)
            else { return .unregistered }
            
        return .registered(license)
    }
    
    fileprivate var license: License? {
        
        return licenseProvider.license
    }
}
