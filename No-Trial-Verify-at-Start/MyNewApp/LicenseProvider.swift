import Foundation

public class LicenseProvider {
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: LicenseInformation {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            key = userDefaults.stringForKey("\(License.UserDefaultsKeys.Key)") {
                
                return .Registered(License(name: name, key: key))
        }
        
        return .Unregistered
    }
    
    public init() { }
}
