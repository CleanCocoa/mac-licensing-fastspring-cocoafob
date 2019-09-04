// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import XCTest
@testable import MyNewApp

class RegisterApplicationTests: XCTestCase {

    var service: RegisterApplication!

    let factoryDouble = TestFactory()
    let writerDouble = TestWriter()
    let broadcasterDouble = TestBroadcaster()

    override func setUp() {
        super.setUp()

        service = RegisterApplication(
            licenseFactory: factoryDouble,
            licenseWriter: writerDouble,
            changeBroadcaster: broadcasterDouble)
    }

    let irrelevantName = "irrelevant"
    let irrelevantLicenseCode = "irrelevant"

    func testRegister_RequestsLicenseFromFactory() {

        let name = "a name"
        let licenseCode = "123-456"

        service.register(name: name, licenseCode: licenseCode)

        XCTAssert(hasValue(factoryDouble.didRequestLicense))
        if let values = factoryDouble.didRequestLicense {
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }

    func testRegister_NoLicenseFromFactory_DoesntCallStore() {

        factoryDouble.testLicense = nil

        service.register(name: irrelevantName, licenseCode: irrelevantLicenseCode)

        XCTAssertFalse(hasValue(writerDouble.didStoreLicense))
    }

    func testRegister_NoLicenseFromFactory_DoesntBroadcastChange() {

        factoryDouble.testLicense = nil

        service.register(name: irrelevantName, licenseCode: irrelevantLicenseCode)

        XCTAssertFalse(hasValue(broadcasterDouble.didBroadcastWith))
    }

    func testRegister_LicenseFromFactory_DelegatesToStore() {

        let license = License(name: "It's Me", licenseCode: "0900-ACME")
        factoryDouble.testLicense = license

        service.register(name: irrelevantName, licenseCode: irrelevantLicenseCode)

        XCTAssert(hasValue(writerDouble.didStoreLicense))
        if let storedLicense = writerDouble.didStoreLicense {
            XCTAssertEqual(storedLicense, license)
        }
    }

    func testRegister_LicenseFromFactory_BroadcastsChange() {

        let license = License(name: "Hello again", licenseCode: "fr13nd-001")
        factoryDouble.testLicense = license

        service.register(name: irrelevantName, licenseCode: irrelevantLicenseCode)

        switch broadcasterDouble.didBroadcastWith {
        case .some(.trialUp),
             .some(.trial(_)),
             .none:
            XCTFail("should be registered")

        case let .some(.registered(registeredLicense)):
            XCTAssertEqual(registeredLicense, license)
        }
    }


    // MARK: -

    class TestWriter: LicenseWriter {
        var didStoreLicense: License?
        override func store(_ license: License) {
            didStoreLicense = license
        }
    }

    class TestFactory: ValidLicenseFactory {
        init() {
            class NullLicenseVerifier: LicenseVerifier {
                override func isValid(licenseCode: String, forName name: String) -> Bool {
                    return false
                }
            }

            super.init(licenseVerifier: NullLicenseVerifier())
        }

        var testLicense: License?
        var didRequestLicense: (name: String, licenseCode: String)?
        override func license(name: String, licenseCode: String) -> License? {
            didRequestLicense = (name, licenseCode)
            return testLicense
        }
    }

    class TestBroadcaster: LicenseChangeBroadcaster {

        var didBroadcastWith: Licensing?
        override func broadcast(_ licensing: Licensing) {

            didBroadcastWith = licensing
        }
    }
}
