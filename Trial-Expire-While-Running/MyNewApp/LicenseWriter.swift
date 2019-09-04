// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class LicenseWriter {
    
    lazy var userDefaults: Foundation.UserDefaults = MyNewApp.UserDefaults.standardUserDefaults()
    
    public init() { }
    
    public func store(licenseCode: String, forName name: String) {
        
        userDefaults.setValue(name, forLicenseKey: .name)
        userDefaults.setValue(licenseCode, forLicenseKey: .licenseCode)
    }
}

extension Foundation.UserDefaults {
    func setValue(_ value: String, forLicenseKey licenseKey: License.DefaultsKey) {
        self.setValue(value, forKey: licenseKey.rawValue)
    }
}
