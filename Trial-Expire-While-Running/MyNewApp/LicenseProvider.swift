// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseProvider {
    
    public init() { }
    
    lazy var userDefaults: Foundation.UserDefaults = MyNewApp.UserDefaults.standardUserDefaults()
    
    public var currentLicense: License? {
        
        if let name = userDefaults.string(forKey: "\(License.UserDefaultsKeys.Name)"),
            let licenseCode = userDefaults.string(forKey: "\(License.UserDefaultsKeys.LicenseCode)") {
                
                return License(name: name, licenseCode: licenseCode)
        }
        
        return .none
    }
}
