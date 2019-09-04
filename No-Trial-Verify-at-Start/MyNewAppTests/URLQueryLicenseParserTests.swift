// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class URLQueryLicenseParserTests: XCTestCase {

    let service = URLQueryLicenseParser()
    
    func testParse_WithEmptyQuery_ReturnsNil() {
        
        XCTAssertFalse(hasValue(service.parseQuery("")))
    }
    
    func testParse_WithoutNameAndLicenseCode_ReturnsNil() {
        
        XCTAssertFalse(hasValue(service.parseQuery("bogus=info")))
    }
    
    let licensee = "Sm9obiBBcHBsZXNlZWQ=" // John Appleseed
    
    func testParse_WithNameOnly_ReturnsNil() {
        
        XCTAssertFalse(hasValue(service.parseQuery("name=\(licensee)")))
    }
    
    func testParse_WithLicenseCodeOnly_ReturnsNil() {
        
        XCTAssertFalse(hasValue(service.parseQuery("licenseCode=foo")))
    }
    
    func testParse_WithUnencodedNameAndLicenseCode_ReturnsNil() {
        
        XCTAssertFalse(hasValue(service.parseQuery("name=unencoded&licenseCode=foo")))
    }
    
    func testParse_CompleteQuery_ReturnsLicense() {
        
        let query = "name=\(licensee)&licenseCode=the-license-code"
        
        let result = service.parseQuery(query)
        
        XCTAssert(hasValue(result))
        if let license = result {
            XCTAssertEqual(license.name, "John Appleseed")
            XCTAssertEqual(license.licenseCode, "the-license-code")
        }
    }
    
    func testParse_CompleteQueryReversedAndWithOtherInfo_ReturnsLicense() {
        
        let query = "licenseCode=the-license-code&bogus=info&name=\(licensee)"
        
        let result = service.parseQuery(query)
        
        XCTAssert(hasValue(result))
        if let license = result {
            XCTAssertEqual(license.name, "John Appleseed")
            XCTAssertEqual(license.licenseCode, "the-license-code")
        }
    }
}
