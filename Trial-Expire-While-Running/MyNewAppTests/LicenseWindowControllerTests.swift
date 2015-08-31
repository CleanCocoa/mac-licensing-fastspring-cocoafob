// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

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
    
    func testTrialDurationLabel_IsConnected() {
        
        XCTAssert(hasValue(controller.trialDaysLeftTextField))
    }
    
    func testTrialIsUpLabel_IsConnected() {
        
        XCTAssert(hasValue(controller.trialUpTextField))
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
    
    
    // MARK: Displaying trial
    
    func testDisplayTrialUp_HidesDaysLeftLabel() {
        
        controller.displayTrialUp()
        
        XCTAssert(controller.trialDaysLeftTextField.hidden)
    }
    
    func testDisplayTrialUp_ShowsTrialUpLabel() {
        
        controller.displayTrialUp()
        
        XCTAssertFalse(controller.trialUpTextField.hidden)
    }
    
    func testDisplayTrialDays_To5_ChangesLabelText() {
        
        controller.displayTrialDaysLeft(5)
        
        XCTAssert(controller.trialDaysLeftTextField.stringValue.hasPrefix("5 "))
    }
    
    func testDisplayTrialDays_ShowsDaysLeftLabel() {
        
        controller.displayTrialDaysLeft(1)
        
        XCTAssertFalse(controller.trialDaysLeftTextField.hidden)
    }
    
    func testDisplayTrialDays_HidesTrialUpLabel() {
        
        controller.displayTrialDaysLeft(9)
        
        XCTAssert(controller.trialUpTextField.hidden)
    }
    
    func testDisplayBought_HidesDaysLeftLabel() {
        
        controller.displayBought()
        
        XCTAssert(controller.trialDaysLeftTextField.hidden)
    }
    
    func testDisplayBought_HidesTrialUpLabel() {
        
        controller.displayBought()
        
        XCTAssert(controller.trialUpTextField.hidden)
    }
    
    
    // MARK: -
    
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
