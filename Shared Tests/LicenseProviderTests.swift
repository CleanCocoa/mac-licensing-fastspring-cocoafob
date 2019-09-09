// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseProviderTests: XCTestCase {

    var licenseProvider: LicenseProvider!

    var factoryDouble: TestFactory!
    var userDefaultsDouble: TestUserDefaults!

    override func setUp() {
        super.setUp()

        factoryDouble = TestFactory()
        userDefaultsDouble = TestUserDefaults()

        licenseProvider = LicenseProvider()
        licenseProvider.userDefaults = userDefaultsDouble
        licenseProvider.validLicenseFactory = factoryDouble
    }
    
    override func tearDown() {
        factoryDouble = nil
        userDefaultsDouble = nil
        licenseProvider = nil

        super.tearDown()
    }

    func provideLicenseDefaults(_ name: String, licenseCode: String) {
        userDefaultsDouble.testValues = [
            License.DefaultsKey.name.rawValue : name,
            License.DefaultsKey.licenseCode.rawValue : licenseCode
        ]
    }
    
    
    // MARK: -
    // MARK: License Info Reading
    
    func testObtainingCurrentLicenseInfo_WithEmptyDefaults_QueriesDefaultsForName() {
        
        _ = licenseProvider.licenseInformation
        
        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssertNotNil(usedDefaultNames)
        if let usedDefaultNames = usedDefaultNames {
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.name.rawValue))
        }
    }

    func testObtainingCurrentLicenseInfo_WithEmptyDefaults_ReturnsNil() {
        
        XCTAssertNil(licenseProvider.licenseInformation)
    }

    func testObtainingCurrentLicenseInfo_WithDefaultsValues_QueriesDefaultsForNameAndKey() {

        provideLicenseDefaults("irrelevant name", licenseCode: "irrelevant key")

        _ = licenseProvider.licenseInformation

        let usedDefaultNames = userDefaultsDouble.didCallStringForKeyWith
        XCTAssertNotNil(usedDefaultNames)
        if let usedDefaultNames = usedDefaultNames {
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.name.rawValue))
            XCTAssert(usedDefaultNames.contains(License.DefaultsKey.licenseCode.rawValue))
        }
    }

    func testObtainingCurrentLicenseInfo_WithDefaultsValues_ReturnsLicenseInfo() {

        let name = "a name"
        let licenseCode = "a license key"
        provideLicenseDefaults(name, licenseCode: licenseCode)

        let licenseInfo = licenseProvider.licenseInformation

        XCTAssertNotNil(licenseInfo)
        if let licenseInfo = licenseInfo {
            XCTAssertEqual(licenseInfo.name, name)
            XCTAssertEqual(licenseInfo.licenseCode, licenseCode)
        }
    }


    // MARK: - License creation

    func testObtainingLicense_WithEmptyDefaults_DoesNotCallFactory() {

        XCTAssertNil(factoryDouble.didCreateLicense)
    }

    func testObtainingLicense_WithDefaultsValues_ForwardsValuesToFactory() {

        let name = "a name"
        let licenseCode = "a license key"
        provideLicenseDefaults(name, licenseCode: licenseCode)

        _ = licenseProvider.license

        XCTAssertNotNil(factoryDouble.didCreateLicense)
        if let values = factoryDouble.didCreateLicense {
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }

    func testObtainingLicense_WithDefaultsValues_FactoryReturnsNil_ReturnsNil() {

        let name = "a name"
        let licenseCode = "a license key"
        provideLicenseDefaults(name, licenseCode: licenseCode)
        factoryDouble.testLicense = nil

        let result = licenseProvider.license

        XCTAssertNil(result)
    }

    func testObtainingLicense_WithDefaultsValues_FactoryReturnsLicense_ReturnsLicense() {

        provideLicenseDefaults("irrelevant", licenseCode: "irrelevant")
        let license = License(name: "relevant name", licenseCode: "and relevant code")
        factoryDouble.testLicense = license

        let result = licenseProvider.license

        XCTAssertEqual(result, license)
    }


    // MARK: - Stored license info validity test

    func testHasInvalidLicenseInformation_EmptyDefaults_FactoryReturnsNil_ReturnsFalse() {

        factoryDouble.testLicense = nil

        XCTAssertFalse(licenseProvider.hasInvalidLicenseInformation)
    }

    func testHasInvalidLicenseInformation_EmptyDefaults_FactoryReturnsLicense_ReturnsFalse() {

        factoryDouble.testLicense = License(name: "irrelevant", licenseCode: "irrelevant")

        XCTAssertFalse(licenseProvider.hasInvalidLicenseInformation)
    }

    func testHasInvalidLicenseInformation_WithDefaults_FactoryReturnsNil_ReturnsTrue() {

        provideLicenseDefaults("some name", licenseCode: "some code")
        factoryDouble.testLicense = nil

        XCTAssert(licenseProvider.hasInvalidLicenseInformation)
    }

    func testHasInvalidLicenseInformation_WithDefaults_FactoryReturnsLicense_ReturnsFalse() {

        provideLicenseDefaults("some name", licenseCode: "some code")
        factoryDouble.testLicense = License(name: "irrelevant", licenseCode: "irrelevant")

        XCTAssertFalse(licenseProvider.hasInvalidLicenseInformation)
    }


    
    // MARK: -
    
    class TestUserDefaults: NullUserDefaults {
        
        var testValues = [String : String]()
        var didCallStringForKeyWith: [String]?
        override func string(forKey defaultName: String) -> String? {
            
            if didCallStringForKeyWith == nil {
                didCallStringForKeyWith = [String]()
            }
            
            didCallStringForKeyWith?.append(defaultName)
            
            return testValues[defaultName]
        }
    }

    class TestFactory: ValidLicenseFactory {
        var testLicense: License?
        var didCreateLicense: (name: String, licenseCode: String)?
        override func license(name: String, licenseCode: String) -> License? {
            didCreateLicense = (name, licenseCode)
            return testLicense
        }
    }
}

