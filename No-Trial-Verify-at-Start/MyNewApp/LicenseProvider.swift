// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseProvider {

    public init() { }

    lazy var userDefaults: Foundation.UserDefaults = UserDefaults.standardUserDefaults()

    public var license: License? {
        
        guard let name = userDefaults.string(forLicenseKey: .name),
            let licenseCode = userDefaults.string(forLicenseKey: .licenseCode)
            else { return nil }

        return License(name: name, licenseCode: licenseCode)
    }
}

extension Foundation.UserDefaults {
    func string(forLicenseKey licenseKey: License.DefaultsKey) -> String? {
        return self.string(forKey: licenseKey.rawValue)
    }
}
