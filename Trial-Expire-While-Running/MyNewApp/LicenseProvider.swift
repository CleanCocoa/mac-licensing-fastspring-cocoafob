import Foundation

public class LicenseProvider {
    
    public init() { }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: LicenseInformation {
        
        if let license = self.license() {
                
            return .Registered(license)
        }
        
        if let trial = self.trial() {
            
            return .OnTrial(trial)
        }
        
        return .TrialUp
    }
    
    func license() -> License? {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            licenseCode = userDefaults.stringForKey("\(License.UserDefaultsKeys.LicenseCode)") {
                
                return License(name: name, licenseCode: licenseCode)
        }
        
        return .None
    }

    func trial() -> TrialPeriod? {
        
        return .None
    }
}
