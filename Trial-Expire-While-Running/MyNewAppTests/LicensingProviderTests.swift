// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import XCTest
@testable import MyNewApp

class LicensingProviderTests: XCTestCase {

    var licensingProvider: LicensingProvider!

    let trialProviderDouble = TestTrialProvider()
    let licenseProviderDouble = TestLicenseProvider()
    let clockDouble = TestClock()

    override func setUp() {

        super.setUp()

        licensingProvider = LicensingProvider(trialProvider: trialProviderDouble, licenseProvider: licenseProviderDouble, clock: clockDouble)
    }

    let irrelevantLicense = License(name: "", licenseCode: "")

    func testLicensing_NoLicense_NoTrialPeriod_ReturnsTrialUp() {

        let licenseInfo = licensingProvider.licensing
        let trialIsUp: Bool = {
            switch licenseInfo {
            case .trialUp:
                return true
            default:
                return false
            }
        }()

        XCTAssert(trialIsUp)
    }

    func testLicensing_NoLicense_ActiveTrialPeriod_ReturnsOnTrial() {

        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: Date())
        clockDouble.testDate = endDate.addingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod

        let licenseInfo = licensingProvider.licensing

        switch licenseInfo {
        case let .trial(trialPeriod):
            XCTAssertEqual(trialPeriod, expectedPeriod)
        default:
            XCTFail("expected to be OnTrial")
        }
    }

    func testLicensing_NoLicense_PassedTrialPeriod_ReturnsTrialUp() {

        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: Date())
        clockDouble.testDate = endDate.addingTimeInterval(100)
        trialProviderDouble.testTrialPeriod = expectedPeriod

        let licenseInfo = licensingProvider.licensing
        let trialIsUp: Bool = {
            switch licenseInfo {
            case .trialUp:
                return true
            default:
                return false
            }
        }()

        XCTAssert(trialIsUp)
    }

    func testLicensing_WithValidLicense_NoTrial_ReturnsRegisteredWithInfo() {

        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license

        let licenseInfo = licensingProvider.licensing

        switch licenseInfo {
        case let .registered(foundLicense):
            XCTAssertEqual(foundLicense, license)
        default:
            XCTFail("expected .registered(_)")
        }
    }

    func testLicensing_WithValidLicense_OnTrial_ReturnsRegistered() {

        // Given
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: endDate)
        clockDouble.testDate = endDate.addingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod

        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license

        // When
        let licenseInfo = licensingProvider.licensing

        // Then
        switch licenseInfo {
        case let .registered(foundLicense):
            XCTAssertEqual(foundLicense, license)
        default:
            XCTFail("expected .registered(_)")
        }
    }

    func testLicensing_WithValidLicense_PassedTrial_ReturnsRegistered() {

        // Given
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: endDate)
        clockDouble.testDate = endDate.addingTimeInterval(+9999)
        trialProviderDouble.testTrialPeriod = expectedPeriod

        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license

        // When
        let licenseInfo = licensingProvider.licensing

        // Then
        switch licenseInfo {
        case let .registered(foundLicense):
            XCTAssertEqual(foundLicense, license)
        default:
            XCTFail("expected .registered(_)")
        }
    }


    // MARK: -

    class TestTrialProvider: TrialProvider {

        var testTrialPeriod: TrialPeriod?
        override var trialPeriod: TrialPeriod? {

            return testTrialPeriod
        }
    }

    class TestLicenseProvider: LicenseProvider {

        var testLicense: License?
        override var license: License? {

            return testLicense
        }
    }

    class TestClock: Clock {

        var testDate: Date!
        func now() -> Date {

            return testDate
        }
    }
}
