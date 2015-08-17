import Foundation

public class LicenseWriter {
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public init() { }
    
    public func storeLicenseCode(licenseCode: String, forName name: String) {
        
        userDefaults.setValue(name, forKey: "\(License.UserDefaultsKeys.Name)")
        userDefaults.setValue(licenseCode, forKey: "\(License.UserDefaultsKeys.Key)")
    }
}
