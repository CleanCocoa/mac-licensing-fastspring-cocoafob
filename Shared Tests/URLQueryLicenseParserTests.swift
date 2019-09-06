// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class URLQueryLicenseParserTests: XCTestCase {

    let service = URLQueryLicenseParser()
    
    func testParse_WithEmptyQuery_ReturnsNil() {
        
        XCTAssertNil(service.parse(query: ""))
    }
    
    func testParse_WithoutNameAndLicenseCode_ReturnsNil() {
        
        XCTAssertNil(service.parse(query: "bogus=info"))
    }
    
    let licensee = "Sm9obiBBcHBsZXNlZWQ=" // John Appleseed
    
    func testParse_WithNameOnly_ReturnsNil() {
        
        XCTAssertNil(service.parse(query: "name=\(licensee)"))
    }
    
    func testParse_WithLicenseCodeOnly_ReturnsNil() {
        
        XCTAssertNil(service.parse(query: "licenseCode=foo"))
    }
    
    func testParse_WithUnencodedNameAndLicenseCode_ReturnsNil() {
        
        XCTAssertNil(service.parse(query: "name=unencoded&licenseCode=foo"))
    }
    
    func testParse_CompleteQuery_ReturnsLicense() {
        
        let query = "name=\(licensee)&licenseCode=the-license-code"
        
        let result = service.parse(query: query)
        
        XCTAssertNotNil(result)
        if let license = result {
            XCTAssertEqual(license.name, "John Appleseed")
            XCTAssertEqual(license.licenseCode, "the-license-code")
        }
    }
    
    func testParse_CompleteQueryReversedAndWithOtherInfo_ReturnsLicense() {
        
        let query = "licenseCode=the-license-code&bogus=info&name=\(licensee)"
        
        let result = service.parse(query: query)
        
        XCTAssertNotNil(result)
        if let license = result {
            XCTAssertEqual(license.name, "John Appleseed")
            XCTAssertEqual(license.licenseCode, "the-license-code")
        }
    }
}
