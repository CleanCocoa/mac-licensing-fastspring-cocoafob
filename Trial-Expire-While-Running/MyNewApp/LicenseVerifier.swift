// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseVerifier {
    
    static let AppName = "MyNewApp"
    let appName: String
    
    public convenience init() {
        
        self.init(appName: LicenseVerifier.AppName)
    }
    
    public init(appName: String) {
        
        self.appName = appName
    }
    
    public func licenseCodeIsValid(licenseCode: String, forName name: String) -> Bool {
        
        // Same format as on FastSpring
        let registrationName = "\(appName),\(name)"
        let publicKey = self.publicKey()
        
        guard let verifier = verifierWithPublicKey(publicKey) else {
            assertionFailure("CocoaFobLicenseVerifier cannot be constructed")
            return false
        }
        
        return verifier.verify(licenseCode, forName: registrationName)
    }
    
    private func verifierWithPublicKey(publicKey: String) -> CocoaFobLicVerifier? {

        return CocoaFobLicVerifier(publicKeyPEM: publicKey)
    }
    
    private func publicKey() -> String {
        
        var parts = [String]()
        
        parts.append("-----BEGIN DSA PUBLIC KEY-----\n")
        parts.append("MIHwMIGoBgcqhkjOOAQBMIGcAkEAoKLaPXkgAPng5YtV")
        parts.append("G14BUE1I5Q")
        parts.append("aGesaf9PTC\nnmUlYMp4m7M")
        parts.append("rVC2/YybXE")
        parts.append("QlaILBZBmyw+A4Kps2k/T12q")
        parts.append("L8EUwIVAPxEzzlcqbED\nKaw6oJ9THk1i4Lu")
        parts.append("TAkAG")
        parts.append("RPr6HheNNnH9GQZGjCuv")
        parts.append("6pLUOBo64QJ0WNEs2c9QOSBU\nHpWZU")
        parts.append("m8bGMQevt38P")
        parts.append("iSZZwU0hCAJ6pd09eeTP983A0MAAkB+yDfp+53KPSk")
        parts.append("5dH")
        parts.append("xh\noBm6kTBKsYk")
        parts.append("xonpPlBrFJTJeyvZInHIKrd0N8Du")
        parts.append("i3XKDtqrLWPIQcM0mWOj")
        parts.append("YHUlf\nUpIg\n")
        parts.append("-----END DSA PUBLIC KEY-----\n")
        
        let publicKey = parts.joinWithSeparator("")
        
        return publicKey
    }
}
