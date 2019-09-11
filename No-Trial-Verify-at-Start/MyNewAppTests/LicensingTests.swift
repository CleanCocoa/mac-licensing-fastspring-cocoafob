// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicensingTests: XCTestCase {

    // MARK: Unregistered user info
    
    func testToUserInfo_Unregistered_SetsRegisteredToFalse() {
        
        let licenseInfo = Licensing.unregistered
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssertNotNil(registered)
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_Unregistered_HasNoNameKey() {

        let licenseInfo = Licensing.unregistered
        
        XCTAssertNil(licenseInfo.userInfo()["name"])
    }
    
    func testToUserInfo_Unregistered_HasNoLicenseCodeKey() {
        
        let licenseInfo = Licensing.unregistered
        
        XCTAssertNil(licenseInfo.userInfo()["licenseCode"])
    }
    
    
    // MARK: Registered user info
    
    let license = License(name: "a name", licenseCode: "a license code")
    
    func testToUserInfo_Registered_SetsRegisteredToTrue() {
        
        let licenseInfo = Licensing.registered(license)
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssertNotNil(registered)
        if let registered = registered {
            XCTAssertTrue(registered)
        }
    }
    
    func testToUserInfo_Registered_SetsNameKeyToLicense() {
        
        let licenseInfo = Licensing.registered(license)
        
        let name = licenseInfo.userInfo()["name"] as? String
        XCTAssertEqual(name, license.name)
    }
    
    func testToUserInfo_Registered_SetsLicenseCodeKeyToLicense() {
        
        let licenseInfo = Licensing.registered(license)
        
        let licenseCode = licenseInfo.userInfo()["licenseCode"] as? String
        XCTAssertEqual(licenseCode, license.licenseCode)
    }
    
    
    // MARK: -
    // MARK: From user info to Unregistered
    
    func testFromUserInfo_EmptyUserInfo_ReturnsNil() {
        
        let userInfo = UserInfo()
        
        let result = Licensing(fromUserInfo: userInfo)
        
        XCTAssertNil(result)
    }
    
    func testFromUserInfo_UserInfoWithoutRegistered_ReturnsNil() {
        
        let userInfo: UserInfo = ["name" : "foo", "licenseCode" : "bar"]
        
        let result = Licensing(fromUserInfo: userInfo)
        
        XCTAssertNil(result)
    }
    
    func testFromUserInfo_UnregisteredUserInfo_ReturnsUnregistered() {
        
        let userInfo: UserInfo = ["registered" : false]
        
        switch Licensing(fromUserInfo: userInfo) {
        case .some(.unregistered):
            break // pass

        case .none,
             .some(.registered(_)):
            XCTFail("expected unregistered")
        }
    }
    
    func testFromUserInfo_UnregisteredUserInfo_WithAdditionalInfo_ReturnsUnregistered() {
        
        let userInfo: UserInfo = ["registered" : false, "bogus" : 123]

        switch Licensing(fromUserInfo: userInfo) {
        case .some(.unregistered):
            break // pass

        case .none,
             .some(.registered(_)):
            XCTFail("expected unregistered")
        }
    }
    
    
    // MARK: From user info to Registered
    
    func testFromUserInfo_RegisteredUserInfo_WithoutDetails_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true]
        
        let result = Licensing(fromUserInfo: userInfo)
        
        XCTAssertNil(result)
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "name" : "a name"]
        
        let result = Licensing(fromUserInfo: userInfo)
        
        XCTAssertNil(result)
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithLicenseCodeOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "licenseCode" : "a license code"]
        
        let result = Licensing(fromUserInfo: userInfo)
        
        XCTAssertNil(result)
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCode_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode]
        
        switch Licensing(fromUserInfo: userInfo) {
        case let .some(.registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)

        case .none,
             .some(.unregistered):
            XCTFail("expected Registered")
        }
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCodeAndAdditionalData_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode, "irrelevant" : 999]

        switch Licensing(fromUserInfo: userInfo) {
        case let .some(.registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)

        case .none,
             .some(.unregistered):
            XCTFail("expected Registered")
        }
    }
}
