// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseWriterTests: XCTestCase {

    // MARK: Storing
    
    func testStoring_DelegatesToUserDefaults() {
        
        // Given
        let writer = LicenseWriter()
        let userDefaultsDouble: TestUserDefaults = TestUserDefaults()
        writer.userDefaults = userDefaultsDouble
        let licenseCode = "a license code"
        let name = "a name"
        
        // When
        writer.store(License(name: name, licenseCode: licenseCode))
        
        // Then
        let changedDefaults = userDefaultsDouble.didSetValuesForKeys
        XCTAssertNotNil(changedDefaults)
        
        if let changedDefaults = changedDefaults {
            XCTAssertEqual(changedDefaults[License.DefaultsKey.name.rawValue], name)
            XCTAssertEqual(changedDefaults[License.DefaultsKey.licenseCode.rawValue], licenseCode)
        }
    }


    // MARK: -
    
    class TestUserDefaults: NullUserDefaults {
        var didSetValuesForKeys: [String : String]?
        override func setValue(_ value: Any?, forKey key: String) {
            if didSetValuesForKeys == nil {
                didSetValuesForKeys = [String : String]()
            }
            
            didSetValuesForKeys![key] = value as? String
        }
    }
}
