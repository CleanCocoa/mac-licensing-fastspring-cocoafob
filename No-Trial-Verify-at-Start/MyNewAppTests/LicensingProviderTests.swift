// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicensingProviderTests: XCTestCase {

    var licensingProvider: LicensingProvider!
    
    let licenseProviderDouble = TestLicenseProvider()
    let verifierDouble = TestVerifier()
    
    override func setUp() {
        
        super.setUp()
        
        licensingProvider = LicensingProvider(licenseProvider: licenseProviderDouble)
        licensingProvider.licenseVerifier = verifierDouble
    }

    let irrelevantLicense = License(name: "", licenseCode: "")
    
    func testLicenceInvalidity_NoLicense_ReturnsFalse() {
        
        XCTAssertFalse(licensingProvider.licenseIsInvalid)
    }
    
    func testLicenceInvalidity_ValidLicense_ReturnsFalse() {
        
        verifierDouble.testValidity = true
        licenseProviderDouble.testLicense = irrelevantLicense
        
        XCTAssertFalse(licensingProvider.licenseIsInvalid)
    }
    
    func testLicenceInvalidity_InvalidLicense_ReturnsFalse() {
        
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = irrelevantLicense
        
        XCTAssert(licensingProvider.licenseIsInvalid)
    }
    
    func testCurrentInfo_NoLicense_ReturnsUnregistered() {
        
        let licenseInfo = licensingProvider.licensing
        
        let unregistered: Bool
        switch licenseInfo {
        case .unregistered: unregistered = true
        default: unregistered = false
        }
        
        XCTAssert(unregistered)
    }
    
    func testCurrentInfo_WithInvalidLicense_ReturnsUnregistered() {
        
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = irrelevantLicense
        
        let licenseInfo = licensingProvider.licensing
        
        let unregistered: Bool
        switch licenseInfo {
        case .unregistered: unregistered = true
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
        
        let licenseInfo = licensingProvider.licensing
        
        switch licenseInfo {
        case let .registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .Registered(_)")
        }
    }
    
    
    // MARK: -
    
    class TestLicenseProvider: LicenseProvider {
    
        var testLicense: License?
        override var license: License? {
            
            return testLicense
        }
    }
    
    class TestVerifier: LicenseVerifier {
        
        init() {
            super.init(appName: "irrelevant app name")
        }
        
        var testValidity = false
        override func isValid(licenseCode: String, forName name: String) -> Bool {
            
            return testValidity
        }
    }
}
