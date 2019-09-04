// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class RegisterApplication: HandlesRegistering {
    
    let licenseVerifier: LicenseVerifier
    let licenseWriter: LicenseWriter
    let changeBroadcaster: LicenseChangeBroadcaster
    
    public init(licenseVerifier: LicenseVerifier, licenseWriter: LicenseWriter, changeBroadcaster: LicenseChangeBroadcaster) {
        
        self.licenseVerifier = licenseVerifier
        self.licenseWriter = licenseWriter
        self.changeBroadcaster = changeBroadcaster
    }
    
    public func register(name: String, licenseCode: String) {
        
        if !licenseVerifier.isValid(licenseCode: licenseCode, forName: name) {
            
            displayLicenseCodeError()
            return
        }

        let license = License(name: name, licenseCode: licenseCode)
        let licensing: Licensing = .registered(license)
        
        licenseWriter.store(license)
        changeBroadcaster.broadcast(licensing)
    }
    
    func displayLicenseCodeError() {
        
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
}
