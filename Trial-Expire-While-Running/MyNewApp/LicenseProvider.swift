import Foundation

public class LicenseProvider {
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: LicenseInformation {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            licenseCode = userDefaults.stringForKey("\(License.UserDefaultsKeys.LicenseCode)") {
                
                return .Registered(License(name: name, licenseCode: licenseCode))
        }
        
        return .Unregistered
    }
    
    public init() { }
}
