// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class LicenseWriter {
    
    lazy var userDefaults: Foundation.UserDefaults = UserDefaults.standardUserDefaults()
    
    public init() { }
    
    open func storeLicenseCode(_ licenseCode: String, forName name: String) {
        
        userDefaults.setValue(name, forKey: "\(License.UserDefaultsKeys.Name)")
        userDefaults.setValue(licenseCode, forKey: "\(License.UserDefaultsKeys.LicenseCode)")
    }
}
