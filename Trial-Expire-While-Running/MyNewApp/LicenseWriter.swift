// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseWriter {
    
    lazy var userDefaults: Foundation.UserDefaults = MyNewApp.UserDefaults.standardUserDefaults()
    
    public init() { }
    
    public func store(licenseCode: String, forName name: String) {
        
        userDefaults.setValue(name, forKey: "\(License.UserDefaultsKeys.name)")
        userDefaults.setValue(licenseCode, forKey: "\(License.UserDefaultsKeys.licenseCode)")
    }
}
