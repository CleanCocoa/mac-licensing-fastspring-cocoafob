// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseProvider {
    
    public init() { }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: License? {
        
        guard let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            licenseCode = userDefaults.stringForKey("\(License.UserDefaultsKeys.LicenseCode)") else {
                
            return .None
        }
        
        return License(name: name, licenseCode: licenseCode)
    }
}
