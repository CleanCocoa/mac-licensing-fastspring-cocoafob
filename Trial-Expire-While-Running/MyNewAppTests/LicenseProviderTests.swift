// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class LicenseProviderTests: XCTestCase {

    let licenseProvider = LicenseProvider()
    
    let userDefaultsDouble: TestUserDefaults = TestUserDefaults()

    override func setUp() {
        
        super.setUp()
        
        // No need to set the double on licenseProvider because 
        // its property is lazily loaded during test cases later.
        UserDefaults.setSharedInstance(UserDefaults(userDefaults: userDefaultsDouble))
    }
    
    override func tearDown() {
        
        UserDefaults.resetSharedInstance()
        
        super.tearDown()
    }

    func provideLicenseDefaults(name: String, licenseCode: String) {
        userDefaultsDouble.testValues = [
            License.UserDefaultsKeys.Name.rawValue : name,
            License.UserDefaultsKeys.LicenseCode.rawValue : licenseCode
        ]
    }
    
    
    // MARK: -
    // MARK: Empty Defaults, no License
    
    func testObtainingCurrentLicense_WithEmptyDefaults_QueriesDefaultsForName() {
        
        _ = licenseProvider.currentLicense
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.Name.rawValue))
        }
    }

    func testObtainingCurrentLicense_WithEmptyDefaults_ReturnsNil() {
        
        XCTAssertFalse(hasValue(licenseProvider.currentLicense))
    }
    
    
    // MARK: Existing Defaults, Registered
    
    func testObtainingCurrentLicense_WithDefaultsValues_QueriesDefaultsForNameAndKey() {
        
        provideLicenseDefaults("irrelevant name", licenseCode: "irrelevant key")
        
        _ = licenseProvider.currentLicense
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssert(hasValue(usedDefaultNames))
        
        if let usedDefaultNames = usedDefaultNames {
            
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.Name.rawValue))
            XCTAssert(contains(usedDefaultNames, License.UserDefaultsKeys.LicenseCode.rawValue))
        }
    }

    func testObtainingCurrentLicense_WithDefaultsValues_ReturnsLicenseWithInfo() {

        let name = "a name"
        let key = "a license key"
        provideLicenseDefaults(name, licenseCode: key)
        
        let licenseInfo = licenseProvider.currentLicense
        
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
        override func stringForKey(defaultName: String) -> String? {
            
            if !hasValue(didCallStringForKeyWith) {
                didCallStringForKeyWith = [String]()
            }
            
            didCallStringForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }
}

