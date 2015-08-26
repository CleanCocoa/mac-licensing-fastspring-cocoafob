import Cocoa
import XCTest
import MyNewApp

class LicenseInformationProviderTests: XCTestCase {

    var licenseInfoProvider: LicenseInformationProvider!
    
    let trialProviderDouble = TestTrialProvider()
    let licenseProviderDouble = TestLicenseProvider()
    let clockDouble = TestClock()
    
    override func setUp() {
        
        super.setUp()
        
        licenseInfoProvider = LicenseInformationProvider(trialProvider: trialProviderDouble, licenseProvider: licenseProviderDouble, clock: clockDouble)
    }

    func testCurrentInfo_NoLicense_NoTrialPeriod_ReturnsTrialUp() {
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let trialIsUp: Bool
        
        switch licenseInfo {
        case .TrialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }
    
    func testCurrentInfo_NoLicense_ActiveTrialPeriod_ReturnsOnTrial() {
        
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        switch licenseInfo {
        case let .OnTrial(trialPeriod): XCTAssertEqual(trialPeriod, expectedPeriod)
        default: XCTFail("expected to be OnTrial")
        }
    }
    
    func testCurrentInfo_NoLicense_PassedTrialPeriod_ReturnsTrialUp() {
        
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(100)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let trialIsUp: Bool
        switch licenseInfo {
        case .TrialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }

    func testCurrentInfo_WithLicense_NoTrial_ReturnsRegisteredWithInfo() {
        
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
    
    func testCurrentInfo_WithLicense_OnTrial_ReturnsRegistered() {
        
        // Given
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        // When
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        // Then
        switch licenseInfo {
        case let .Registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .Registered(_)")
        }
    }
    
    func testCurrentInfo_WithLicense_PassedTrial_ReturnsRegistered() {
        
        // Given
        let endDate = NSDate()
        let expectedPeriod = TrialPeriod(startDate: NSDate(), endDate: NSDate())
        clockDouble.testDate = endDate.dateByAddingTimeInterval(+9999)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        // When
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        // Then
        switch licenseInfo {
        case let .Registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .Registered(_)")
        }
    }
    
    
    // MARK: -
    
    class TestTrialProvider: TrialProvider {
        
        var testTrialPeriod: TrialPeriod?
        override var currentTrialPeriod: TrialPeriod? {
            
            return testTrialPeriod
        }
    }
    
    class TestLicenseProvider: LicenseProvider {
    
        var testLicense: License?
        override var currentLicense: License? {
            
            return testLicense
        }
    }
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: NSDate!
        func now() -> NSDate {
            
            return testDate
        }
    }
}
