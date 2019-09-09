// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicensingProviderTests: XCTestCase {

    var licensingProvider: LicensingProvider!
    
    let licenseProviderDouble = TestLicenseProvider()
    
    override func setUp() {
        
        super.setUp()
        
        licensingProvider = LicensingProvider(licenseProvider: licenseProviderDouble)
    }

    let irrelevantLicense = License(name: "", licenseCode: "")

    func testLicensing_NoLicense_ReturnsUnregistered() {
        
        let licenseInfo = licensingProvider.licensing
        
        let unregistered: Bool = {
            switch licenseInfo {
            case .unregistered:
                return true
            case .registered:
                return false
            }
        }()

        XCTAssert(unregistered)
    }

    func testLicensing_WithValidLicense_ReturnsRegistered() {

        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        let licenseInfo = licensingProvider.licensing
        
        switch licenseInfo {
        case let .registered(foundLicense):
            XCTAssertEqual(foundLicense, license)
        case .unregistered:
            XCTFail("expected .Registered(_)")
        }
    }
    
    
    // MARK: -
    
    class TestLicenseProvider: LicenseProvider {
        var testLicense: License?
        override var license: License? {
            return testLicense
        }
    }
}
