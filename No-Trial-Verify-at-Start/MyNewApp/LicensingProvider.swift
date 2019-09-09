// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicensingProvider {
    let licenseProvider: LicenseProvider
    
    public init(licenseProvider: LicenseProvider) {
        self.licenseProvider = licenseProvider
    }

    fileprivate var license: License? {
        return licenseProvider.license
    }
    
    public var licensing: Licensing {
        guard let license = self.license else { return .unregistered }
        return .registered(license)
    }
}
