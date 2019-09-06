// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

public class RegisterApplication {

    let licenseFactory: ValidLicenseFactory
    let licenseWriter: LicenseWriter
    let changeBroadcaster: LicenseChangeBroadcaster

    public init(licenseFactory: ValidLicenseFactory = ValidLicenseFactory(),
                licenseWriter: LicenseWriter = LicenseWriter(),
                changeBroadcaster: LicenseChangeBroadcaster = LicenseChangeBroadcaster()) {
        self.licenseFactory = licenseFactory
        self.licenseWriter = licenseWriter
        self.changeBroadcaster = changeBroadcaster
    }

    public func register(name: String, licenseCode: String) {
        guard let license = licenseFactory.license(name: name, licenseCode: licenseCode) else {
            displayLicenseCodeError()
            return
        }

        licenseWriter.store(license)
        changeBroadcaster.broadcast(.registered(license))
    }

    func displayLicenseCodeError() {
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
}

// Implement the UI protocol to be a valid event handler:
extension RegisterApplication: HandlesRegistering { }
