// Copyright (c) 2015-2016 Christian Tietze
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

        XCTAssert(hasValue(controller.buyButton))
    }
    
    func testBuyButton_IsLabelledBuyNow() {
        
        // Not using XCTAssertEqual on the Implicitely Unwrapped Optional 
        // so that for a missing value the tests don't crash but 
        // fail. It's less expressive, though.
        XCTAssert(controller.buyButton?.title == "Buy Now")
    }
    
    func testBuyButton_IsWiredToAction() {
        
        XCTAssert(controller.buyButton?.action == #selector(LicenseWindowController.buy(_:)))
    }
    
    func testBuyButton_Initially_IsEnabled() {
        
        XCTAssert(controller.buyButton?.isEnabled == true)
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
    
    func testDisplayLicenseInfo_Unregistered_DisplaysEmptyForm() {
        
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.displayLicenseInformation(.unregistered)
        
        XCTAssert(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssertFalse(hasValue(existingLicenseVCDouble.didDisplayLicenseWith))
    }
    
    func testDisplayLicenseInfo_Registered_DisplaysLicense() {
        
        let license = License(name: "the name", licenseCode: "the code")
        controller.existingLicenseViewController = existingLicenseVCDouble
        
        controller.displayLicenseInformation(.registered(license))
        
        XCTAssertFalse(existingLicenseVCDouble.didDisplayEmptyForm)
        XCTAssert(hasValue(existingLicenseVCDouble.didDisplayLicenseWith))
        
        if let displayedLicense = existingLicenseVCDouble.didDisplayLicenseWith {
            
            XCTAssertEqual(displayedLicense, license)
        }
    }
    
    
    // MARK: -
    
    class TestHandler: HandlesRegistering {
        
        func register(_ name: String, licenseCode: String) {
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
        override func displayLicense(_ license: License) {
            
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
