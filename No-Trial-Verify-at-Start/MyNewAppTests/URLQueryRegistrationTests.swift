// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class URLQueryRegistrationTests: XCTestCase {

    var service: URLQueryRegistration!
    
    let regHandlerDouble = TestRegistrationHandler()
    
    override func setUp() {
        
        super.setUp()
        
        service = URLQueryRegistration(registrationHandler: regHandlerDouble)
    }
    
    func testRegister_URLWithoutHost_DoesNotDelegateToHandler() {
        
        let url = NSURL(string: "xyz://")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_URLWithBogusHost_DoesNotDelegateToHandler() {
        
        let url = NSURL(string: "xyz://bogus")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_ActivationURLWithoutQuery_DoesNotDelegateToHandler() {
        
        let url = NSURL(string: "xyz://activate")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_ActivationURLWithCompleteQuery_DelegatesToHandler() {
        
        let url = NSURL(string: "xyz://activate?name=foo&licenseCode=the-license-code")!
        
        service.registerFromURL(url)
        
        XCTAssert(hasValue(regHandlerDouble.didRegisterWith))
        if let licenseInfo = regHandlerDouble.didRegisterWith {
            XCTAssertEqual(licenseInfo.name, "foo")
            XCTAssertEqual(licenseInfo.licenseCode, "the-license-code")
        }
    }
    
    
    // MARK: -
    
    class TestRegistrationHandler: HandlesRegistering {
        
        var didRegisterWith: (name: String, licenseCode: String)?
        func register(name: String, licenseCode: String) {
            
            didRegisterWith = (name, licenseCode)
        }
    }
}
