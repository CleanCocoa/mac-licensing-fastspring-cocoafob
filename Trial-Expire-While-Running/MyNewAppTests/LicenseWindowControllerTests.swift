// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseWindowControllerTests: XCTestCase {
    
    var controller: LicenseWindowController!
    
    override func setUp() {
        
        super.setUp()
        
        controller = LicenseWindowController()
        loadWindow(controller)
    }
    
    
    // MARK: Nib Loading
    
    func testBuyButton_IsConnected() {

        XCTAssertNotNil(controller.buyButton)
    }
    
    func testBuyButton_IsLabelledBuyNow() {

        XCTAssertEqual(controller.buyButton?.title, "Buy Now")
    }
    
    func testBuyButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.buyButton?.action,
                       #selector(LicenseWindowController.buy(_:)))
    }
    
    func testBuyButton_Initially_IsEnabled() {
        
        XCTAssert(controller.buyButton?.isEnabled == true)
    }
    
    func testTrialDurationLabel_IsConnected() {
        
        XCTAssertNotNil(controller.trialDaysLeftTextField)
    }
    
    func testTrialIsUpLabel_IsConnected() {
        
        XCTAssertNotNil(controller.trialUpTextField)
    }

    func testExistingLicenseVC_IsConnected() {
    
        XCTAssertNotNil(controller.existingLicenseViewController)
    }
    
    
    // MARK: License change handler
    
    let existingLicenseVCDouble = TestExistingLicenseViewController()
    
    func testSetRegistrationHandler_DelegatesToVC() {
        
        let handler = TestHandler()
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.registrationEventHandler = handler
        
        XCTAssert(existingLicenseVCDouble.didSetEventHandlerTo === handler)
    }
    
    func testGetRegistrationHandler_DelegatesToVC() {
        
        let handler = TestHandler()
        existingLicenseVCDouble.testEventHandler = handler
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        let result = controller.registrationEventHandler
        
        XCTAssert(result === handler)
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
        
        controller.display(licensing: .trialExpired)
        
        XCTAssert(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertNil(existingLicenseVCDouble.didDisplayLicenseWith)
    }
    
    func testDisplayLicenseInfo_OnTrial_DisplaysEmptyForm() {
        
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.display(licensing: .trial(TrialPeriod(startDate: Date(), endDate: Date())))
        
        XCTAssert(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertNil(existingLicenseVCDouble.didDisplayLicenseWith)
    }
    
    func testDisplayLicenseInfo_Registered_DisplaysLicense() {
        
        let license = License(name: "the name", licenseCode: "the code")
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.display(licensing: .registered(license))
        
        XCTAssertFalse(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertEqual(existingLicenseVCDouble.didDisplayLicenseWith, license)
    }
    
    
    // MARK: Displaying trial
    
    func testDisplayTrialUp_HidesDaysLeftLabel() {
        
        controller.displayTrialUp()
        
        XCTAssert(controller.trialDaysLeftTextField.isHidden)
    }
    
    func testDisplayTrialUp_ShowsTrialUpLabel() {
        
        controller.displayTrialUp()
        
        XCTAssertFalse(controller.trialUpTextField.isHidden)
    }
    
    func testDisplayTrialDays_To5_ChangesLabelText() {
        
        controller.display(trialDaysLeft: 5)

        XCTAssert(controller.trialDaysLeftTextField.stringValue.hasPrefix("5 "))
    }
    
    func testDisplayTrialDays_ShowsDaysLeftLabel() {
        
        controller.display(trialDaysLeft: 1)
        
        XCTAssertFalse(controller.trialDaysLeftTextField.isHidden)
    }
    
    func testDisplayTrialDays_HidesTrialUpLabel() {
        
        controller.display(trialDaysLeft: 9)
        
        XCTAssert(controller.trialUpTextField.isHidden)
    }
    
    func testDisplayBought_HidesDaysLeftLabel() {
        
        controller.displayBought()
        
        XCTAssert(controller.trialDaysLeftTextField.isHidden)
    }
    
    func testDisplayBought_HidesTrialUpLabel() {
        
        controller.displayBought()
        
        XCTAssert(controller.trialUpTextField.isHidden)
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
        override func display(license: License) {
            
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
