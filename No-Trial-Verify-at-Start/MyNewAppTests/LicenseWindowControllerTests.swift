import Cocoa
import XCTest
import MyNewApp

class LicenseWindowControllerTests: XCTestCase {
    
    var controller: LicenseWindowController!
    
    override func setUp() {
        
        super.setUp()
        
        controller = LicenseWindowController()
        loadWindow(controller)
    }
    
    
    // MARK: Nib Loading
    
    func testBuyButton_IsConnected() {

        XCTAssert(hasValue(controller.buyButton))
    }
    
    func testBuyButton_IsLabelledBuyNow() {
        
        // Not using XCTAssertEqual on the Implicitely Unwrapped Optional 
        // so that for a missing value the tests don't crash but 
        // fail. It's less expressive, though.
        XCTAssert(controller.buyButton?.title == "Buy Now")
    }
    
    func testBuyButton_IsWiredToAction() {
        
        XCTAssert(controller.buyButton?.action == Selector("buy:"))
    }
    
    func testBuyButton_Initially_IsEnabled() {
        
        XCTAssert(controller.buyButton?.enabled == true)
    }

    func testExistingLicenseVC_IsConnected() {
    
        XCTAssert(hasValue(controller.existingLicenseViewController))
    }
    
    
    // MARK: License change handler
    
    let existingLicenseVCDouble = TestExistingLicenseViewController()
    
    func testSetRegistrationHandler_DelegatesToVC() {
        
        let handler = TestHandler()
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.registrationEventHandler = handler
        
        XCTAssert(hasValue(existingLicenseVCDouble.didSetEventHandlerTo))
        if let newHandler = existingLicenseVCDouble.didSetEventHandlerTo {
            
            XCTAssert(newHandler === handler)
        }
    }
    
    func testGetRegistrationHandler_DelegatesToVC() {
        
        let handler = TestHandler()
        existingLicenseVCDouble.testEventHandler = handler
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        let result = controller.registrationEventHandler
        
        XCTAssert(hasValue(result))
        if let result = result {
            XCTAssert(result === handler)
        }
    }
    
    
    // MARK: License Changes
    
    func testLicenseChange_ToRegistered_DisabledBuyButton() {
        
        let irrelevantLicense = License(name: "", key: "")
        let licenseInfo = LicenseInformation.Registered(irrelevantLicense)
        
        controller.licenseChanged(licenseInfo)
        
        XCTAssert(controller.buyButton?.enabled == false)
    }
    
    func testLicenseChange_ToUnregistered_EnablesBuyButton() {
        
        let licenseInfo = LicenseInformation.Unregistered
        controller.buyButton?.enabled = false
        
        controller.licenseChanged(licenseInfo)
        
        XCTAssert(controller.buyButton?.enabled == true)
    }
    
    
    // MARK: Buying
    
    
    
    
    // MARK: -
    
    class TestLicenseProvider: LicenseProvider {
        
        var testCurrentLicense = LicenseInformation.Unregistered
        override var currentLicense: LicenseInformation {
            return testCurrentLicense
        }
    }
    
    class TestHandler: HandlesRegistering {
        
        func register(name: String, licenseCode: String) {
            // no-op
        }
    }
    
    class TestExistingLicenseViewController: ExistingLicenseViewController {
        
        var testEventHandler: HandlesRegistering?
        var didSetEventHandlerTo: HandlesRegistering?
        override var eventHandler: HandlesRegistering? {
            set {
                didSetEventHandlerTo = newValue
            }
            
            get {
                return testEventHandler
            }
        }
    }
}
