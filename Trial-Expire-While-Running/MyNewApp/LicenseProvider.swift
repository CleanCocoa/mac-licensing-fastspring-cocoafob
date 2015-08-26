import Foundation

public class LicenseProvider {
    
    public init() { }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: License? {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            licenseCode = userDefaults.stringForKey("\(License.UserDefaultsKeys.LicenseCode)") {
                
                return License(name: name, licenseCode: licenseCode)
        }
        
        return .None
    }
}
