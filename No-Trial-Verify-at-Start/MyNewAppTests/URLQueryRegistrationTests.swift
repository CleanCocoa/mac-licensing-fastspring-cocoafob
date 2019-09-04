// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class URLQueryRegistrationTests: XCTestCase {

    var service: URLQueryRegistration!
    
    let regHandlerDouble = TestRegistrationHandler()
    let parserDouble = TestQueryParser()
    
    override func setUp() {
        
        super.setUp()
        
        service = URLQueryRegistration(registrationHandler: regHandlerDouble)
        service.queryParser = parserDouble
    }
    
    func testRegister_URLWithoutHost_DoesNotDelegate() {
        
        let url = URL(string: "xyz://")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(parserDouble.didParseWith))
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_URLWithBogusHost_DoesNotDelegate() {
        
        let url = URL(string: "xyz://bogus")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(parserDouble.didParseWith))
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_ActivationURLWithoutQuery_DoesNotDelegate() {
        
        let url = URL(string: "xyz://activate")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(parserDouble.didParseWith))
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_ActivationURLWithQuery_DelegatesToQueryParser() {
        
        let query = "query=is-here"
        let url = URL(string: "xyz://activate?\(query)")!
        
        service.registerFromURL(url)
        
        XCTAssert(parserDouble.didParseWith == query)
    }
    
    func testRegister_ActivationURLWithQuery_NilQueryParserResult_DoesNotDelegateToRegHandler() {
        
        parserDouble.testParsedLicense = nil
        let url = URL(string: "xyz://activate?irrelevant=query")!
        
        service.registerFromURL(url)
        
        XCTAssertFalse(hasValue(regHandlerDouble.didRegisterWith))
    }
    
    func testRegister_ActivationURLWithQuery_LicenseQueryParserResult_DelegatesToRegHandler() {
        
        let name = "a name"
        let licenseCode = "a license code"
        parserDouble.testParsedLicense = License(name: name, licenseCode: licenseCode)
        let url = URL(string: "xyz://activate?irrelevant=query")!
        
        service.registerFromURL(url)
        
        XCTAssert(hasValue(regHandlerDouble.didRegisterWith))
        if let licenseData = regHandlerDouble.didRegisterWith {
            XCTAssertEqual(licenseData.name, name)
            XCTAssertEqual(licenseData.licenseCode, licenseCode)
        }
    }


    // MARK: -

    class TestRegistrationHandler: HandlesRegistering {
        var didRegisterWith: (name: String, licenseCode: String)?
        func register(name: String, licenseCode: String) {
            didRegisterWith = (name, licenseCode)
        }
    }

    class TestQueryParser: URLQueryLicenseParser {
        
        var testParsedLicense: License?
        var didParseWith: String?
        override func parseQuery(_ query: String) -> License? {
            
            didParseWith = query
            
            return testParsedLicense
        }
    }
}
