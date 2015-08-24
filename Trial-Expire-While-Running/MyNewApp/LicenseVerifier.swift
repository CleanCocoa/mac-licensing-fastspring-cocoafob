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
        
        var error: NSError?
        if let verifier = verifierWithPublicKey(publicKey, error: &error) {
            
            error = nil
            let verified = verifier.verifyRegCode(licenseCode, forName: registrationName, error: &error)
            
            if hasValue(error) {
                // handle error
            }
            
            return verified
        } else {
            // handle optional public key error (programmer error)
            assertionFailure("CFobLicVerifier could not be constructed")
        }
        
        return false
    }
    
    private func verifierWithPublicKey(publicKey: String, error errorPointer: NSErrorPointer) -> CFobLicVerifier? {
        
        let verifier = CFobLicVerifier()
        let success = verifier.setPublicKey(publicKey, error: errorPointer)
        
        if !success {
            return nil
        }
        
        return verifier
    }
    
    private func publicKey() -> String {
        
        var parts = [String]()
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
        
        let partialPublicKey = "".join(parts)
        
        return CFobLicVerifier.completePublicKeyPEM(partialPublicKey)
    }
}
