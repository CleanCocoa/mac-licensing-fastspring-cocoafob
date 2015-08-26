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
