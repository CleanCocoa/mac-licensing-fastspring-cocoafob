import Cocoa
import XCTest
import MyNewApp

class LicenseVerifierTests: XCTestCase {

    let verifier = LicenseVerifier()
    
    let validLicense = License(name: "John Appleseed", key: "GAWQE-FABU3-HNQXA-B7EGM-34X2E-DGMT4-4F44R-9PUQC-CUANX-FXMCZ-4536Y-QKX9D-PU2C3-QG2ZA-U88NJ-Q")

    func testVerify_EmptyStrings_ReturnsFalse() {
        
        let result = verifier.licenseCodeIsValid("", forName: "")
        
        XCTAssertFalse(result)
    }
    
    func testVerify_ValidCodeWrongName_ReturnsFalse() {
        
        let result = verifier.licenseCodeIsValid(validLicense.key, forName: "Jon Snow")
        
        XCTAssertFalse(result)
    }
    
    func testVerify_ValidLicense_ReturnsTrue() {
        
        let result = verifier.licenseCodeIsValid(validLicense.key, forName: validLicense.name)
        
        XCTAssert(result)
    }
    
    func testVerify_ValidLicenseWrongApp_ReturnsFalse() {
        
        let verifier = LicenseVerifier(appName: "AnotherApp")
        
        let result = verifier.licenseCodeIsValid(validLicense.key, forName: validLicense.name)
        
        XCTAssertFalse(result)
    }
}
