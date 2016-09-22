// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class LicenseProvider {
    
    public init() { }
    
    lazy var userDefaults: Foundation.UserDefaults = UserDefaults.standardUserDefaults()
    
    open var currentLicense: License? {
        
        guard let name = userDefaults.string(forKey: "\(License.UserDefaultsKeys.Name)"),
            let licenseCode = userDefaults.string(forKey: "\(License.UserDefaultsKeys.LicenseCode)") else {
                
            return .none
        }
        
        return License(name: name, licenseCode: licenseCode)
    }
}
