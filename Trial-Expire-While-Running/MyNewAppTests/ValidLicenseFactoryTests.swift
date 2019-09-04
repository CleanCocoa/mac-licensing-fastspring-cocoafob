// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import XCTest
@testable import MyNewApp

class ValidLicenseFactoryTests: XCTestCase {

    var service: ValidLicenseFactory!

    let verifierDouble = TestVerifier()

    override func setUp() {
        super.setUp()

        service = ValidLicenseFactory(licenseVerifier: verifierDouble)
    }

    let irrelevantName = "irrelevant"
    let irrelevantLicenseCode = "irrelevant"

    func testLicense_DelegatesToVerifier() {

        let name = "a name"
        let licenseCode = "123-456"

        _ = service.license(name: name, licenseCode: licenseCode)

        XCTAssertNotNil(verifierDouble.didCallIsValidWith)
        if let values = verifierDouble.didCallIsValidWith {
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }

    func testLicense_InvalidLicense_ReturnsNil() {

        verifierDouble.testValidity = false

        let result = service.license(name: irrelevantName, licenseCode: irrelevantLicenseCode)

        XCTAssertNil(result)
    }

    func testLicense_ValidLicense_ReturnsLicense() {

        let name = "It's Me"
        let licenseCode = "0900-ACME"
        verifierDouble.testValidity = true

        let result = service.license(name: name, licenseCode: licenseCode)

        XCTAssertEqual(result, License(name: name, licenseCode: licenseCode))
    }


    // MARK: -

    class TestVerifier: LicenseVerifier {
        init() {
            super.init(appName: "irrelevant app name")
        }

        var testValidity = false
        var didCallIsValidWith: (licenseCode: String, name: String)?
        override func isValid(licenseCode: String, forName name: String) -> Bool {
            didCallIsValidWith = (licenseCode, name)
            return testValidity
        }
    }

}
