// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

public class ValidLicenseFactory {
    public let licenseVerifier: LicenseVerifier

    public convenience init() {
        self.init(licenseVerifier: LicenseVerifier())
    }

    public init(licenseVerifier: LicenseVerifier) {
        self.licenseVerifier = licenseVerifier
    }

    public func license(name: String, licenseCode: String) -> License? {
        guard licenseVerifier.isValid(licenseCode: licenseCode, forName: name)
            else { return nil }

        return License(name: name, licenseCode: licenseCode)
    }
}
