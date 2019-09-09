// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseProvider {
    public init() { }

    lazy var userDefaults: Foundation.UserDefaults = .standard
    lazy var validLicenseFactory: ValidLicenseFactory = ValidLicenseFactory()

    public var licenseInformation: (name: String, licenseCode: String)? {
        guard let name = userDefaults.string(forLicenseKey: .name),
            let licenseCode = userDefaults.string(forLicenseKey: .licenseCode)
            else { return nil }

        return (name, licenseCode)
    }

    /// Returns a valid license, or nil.
    public var license: License? {
        guard let (name, licenseCode) = self.licenseInformation else { return nil }
        return validLicenseFactory.license(name: name, licenseCode: licenseCode)
    }

    public var hasInvalidLicenseInformation: Bool {
        return self.licenseInformation != nil
            && self.license == nil
    }
}

extension Foundation.UserDefaults {
    func string(forLicenseKey licenseKey: License.DefaultsKey) -> String? {
        return self.string(forKey: licenseKey.rawValue)
    }
}
