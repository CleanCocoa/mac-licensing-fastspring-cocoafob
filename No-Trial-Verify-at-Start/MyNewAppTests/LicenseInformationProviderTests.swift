import Cocoa
import XCTest
import MyNewApp

class LicenseInformationProviderTests: XCTestCase {

    var licenseInfoProvider: LicenseInformationProvider!
    
    let licenseProviderDouble = TestLicenseProvider()
    
    override func setUp() {
        
        super.setUp()
        
        licenseInfoProvider = LicenseInformationProvider(licenseProvider: licenseProviderDouble)
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
    
    func testCurrentInfo_WithLicense_ReturnsRegistered() {
        
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
}
