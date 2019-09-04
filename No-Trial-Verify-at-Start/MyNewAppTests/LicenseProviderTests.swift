// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseProviderTests: XCTestCase {
    
    let licenseProvider = LicenseProvider()
    
    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()
    
    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on licenseProvider because
        // its property is lazily loaded during test cases later.
        MyNewApp.UserDefaults.sharedInstance = MyNewApp.UserDefaults(userDefaults: userDefaultsDouble)
    }
    
    override func tearDown() {
        
        MyNewApp.UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }
    
    func provideLicenseDefaults(_ name: String, licenseCode: String) {
        userDefaultsDouble.testValues = [
            License.DefaultsKey.name.rawValue : name,
            License.DefaultsKey.licenseCode.rawValue : licenseCode
        ]
    }
    
    
    // MARK: -
    // MARK: Empty Defaults, no License
    
    func testObtainingCurrentLicense_WithEmptyDefaults_QueriesDefaultsForName() {
        
        _ = licenseProvider.license
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.name.rawValue))
        }
    }
    
    func testObtainingCurrentLicense_WithEmptyDefaults_ReturnsNil() {
        
        XCTAssertFalse(hasValue(licenseProvider.license))
    }
    
    
    // MARK: Existing Defaults, Registered
    
    func testObtainingCurrentLicense_WithDefaultsValues_QueriesDefaultsForNameAndKey() {
        
        provideLicenseDefaults("irrelevant name", licenseCode: "irrelevant key")
        
        _ = licenseProvider.license
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.name.rawValue))
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.licenseCode.rawValue))
        }
    }
    
    func testObtainingCurrentLicense_WithDefaultsValues_ReturnsLicenseWithInfo() {
        
        let name = "a name"
        let key = "a license key"
        provideLicenseDefaults(name, licenseCode: key)
        
        let licenseInfo = licenseProvider.license
        
        XCTAssert(hasValue(licenseInfo))
        if let licenseInfo = licenseInfo {
            
            XCTAssertEqual(licenseInfo.name, name)
            XCTAssertEqual(licenseInfo.licenseCode, key)
        }
    }
    
    
    // MARK: -
    
    class TestUserDefaults: NullUserDefaults {
        
        var testValues = [String : String]()
        var didCallStringForKeyWith: [String]?
        override func string(forKey defaultName: String) -> String? {
            
            if !hasValue(didCallStringForKeyWith) {
                didCallStringForKeyWith = [String]()
            }
            
            didCallStringForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }
}

