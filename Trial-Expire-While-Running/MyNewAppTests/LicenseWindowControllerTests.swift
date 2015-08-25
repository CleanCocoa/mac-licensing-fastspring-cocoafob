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
        
        let irrelevantLicense = License(name: "", licenseCode: "")
        let licenseInfo = LicenseInformation.Registered(irrelevantLicense)
        
        controller.licenseChanged(licenseInfo)
        
        XCTAssert(controller.buyButton?.enabled == false)
    }
    
    func testLicenseChange_ToTrialUp_EnablesBuyButton() {
        
        let licenseInfo = LicenseInformation.TrialUp
        controller.buyButton?.enabled = false
        
        controller.licenseChanged(licenseInfo)
        
        XCTAssert(controller.buyButton?.enabled == true)
    }
    
    func testLicenseChange_ToOnTrial_EnablesBuyButton() {
        
        let licenseInfo = LicenseInformation.OnTrial(TrialPeriod(startDate: NSDate(), endDate: NSDate()))
        controller.buyButton?.enabled = false
        
        controller.licenseChanged(licenseInfo)
        
        XCTAssert(controller.buyButton?.enabled == true)
    }
    
    
    // MARK: Buying
    
    func testBuying_DelegatesToPurchaseEventHandler() {
        
        let handlerDouble = TestPurchaseHandler()
        controller.purchasingEventHandler = handlerDouble
            
        controller.buy(self)
        
        XCTAssert(handlerDouble.didPurchase)
    }
    
    
    // MARK: Displaying License Info
    
    func testDisplayLicenseInfo_TrialUp_DisplaysEmptyForm() {
        
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.displayLicenseInformation(.TrialUp)
        
        XCTAssert(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertFalse(hasValue(existingLicenseVCDouble.didDisplayLicenseWith))
    }
    
    func testDisplayLicenseInfo_OnTrial_DisplaysEmptyForm() {
        
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.displayLicenseInformation(.OnTrial(TrialPeriod(startDate: NSDate(), endDate: NSDate())))
        
        XCTAssert(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertFalse(hasValue(existingLicenseVCDouble.didDisplayLicenseWith))
    }
    
    func testDisplayLicenseInfo_Registered_DisplaysLicense() {
        
        let license = License(name: "the name", licenseCode: "the code")
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.displayLicenseInformation(.Registered(license))
        
        XCTAssertFalse(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssert(hasValue(existingLicenseVCDouble.didDisplayLicenseWith))
        
        if let displayedLicense = existingLicenseVCDouble.didDisplayLicenseWith {
            
            XCTAssertEqual(displayedLicense, license)
        }
    }
    
    
    // MARK: -
    
    class TestLicenseProvider: LicenseProvider {
        
        var testCurrentLicense = LicenseInformation.TrialUp
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
        
        var didDisplayEmptyForm = false
        override func displayEmptyForm() {
            
            didDisplayEmptyForm = true
        }
        
        var didDisplayLicenseWith: License? = nil
        override func displayLicense(license: License) {
            
            didDisplayLicenseWith = license
        }
    }
    
    class TestPurchaseHandler: HandlesPurchases {
        
        var didPurchase = false
        func purchase() {
            
            didPurchase = true
        }
    }
}
