// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class LicenseInformationProviderTests: XCTestCase {

    var licenseInfoProvider: LicenseInformationProvider!
    
    let licenseProviderDouble = TestLicenseProvider()
    let verifierDouble = TestVerifier()
    
    override func setUp() {
        
        super.setUp()
        
        licenseInfoProvider = LicenseInformationProvider(licenseProvider: licenseProviderDouble)
        licenseInfoProvider.licenseVerifier = verifierDouble
    }

    func testCurrentInfo_NoLicense_ReturnsUnregistered() {
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let unregistered: Bool
        switch licenseInfo {
        case .Unregistered: unregistered = true
        default: unregistered = false
        }
        
        XCTAssert(unregistered)
    }
    
    func testCurrentInfo_WithInvalidLicense_ReturnsUnregistered() {
        
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = License(name: "", licenseCode: "")
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let unregistered: Bool
        switch licenseInfo {
        case .Unregistered: unregistered = true
        default: unregistered = false
        }
        
        XCTAssert(unregistered)
    }
    
    func testCurrentInfo_WithValidLicense_ReturnsRegistered() {
        
        verifierDouble.testValidity = true
        
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        switch licenseInfo {
        case let .Registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .Registered(_)")
        }
    }
    
    
    // MARK: -
    
    class TestLicenseProvider: LicenseProvider {
    
        var testLicense: License?
        override var currentLicense: License? {
            
            return testLicense
        }
    }
    
    class TestVerifier: LicenseVerifier {
        
        init() {
            super.init(appName: "irrelevant app name")
        }
        
        var testValidity = false
        override func licenseCodeIsValid(licenseCode: String, forName name: String) -> Bool {
            
            return testValidity
        }
    }
}
