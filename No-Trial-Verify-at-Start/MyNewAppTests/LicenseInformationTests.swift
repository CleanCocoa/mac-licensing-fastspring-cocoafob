import Cocoa
import XCTest
import MyNewApp

class LicenseInformationTests: XCTestCase {

    // MARK: Unregistered user info
    
    func testToUserInfo_Unregistered_SetsRegisteredToFalse() {
        
        let licenseInfo = LicenseInformation.Unregistered
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_Unregistered_HasNoNameKey() {

        let licenseInfo = LicenseInformation.Unregistered
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["name"]))
    }
    
    func testToUserInfo_Unregistered_HasNoLicenseCodeKey() {
        
        let licenseInfo = LicenseInformation.Unregistered
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["licenseCode"]))
    }
    
    
    // MARK: Registered user info
    
    let license = License(name: "a name", licenseCode: "a license code")
    
    func testToUserInfo_Registered_SetsRegisteredToTrue() {
        
        let licenseInfo = LicenseInformation.Registered(license)
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered)
        }
    }
    
    func testToUserInfo_Registered_SetsNameKeyToLicense() {
        
        let licenseInfo = LicenseInformation.Registered(license)
        
        let name = licenseInfo.userInfo()["name"] as? String
        XCTAssert(hasValue(name))
        if let name = name {
            XCTAssertEqual(name, license.name)
        }
    }
    
    func testToUserInfo_Registered_SetsLicenseCodeKeyToLicense() {
        
        let licenseInfo = LicenseInformation.Registered(license)
        
        let licenseCode = licenseInfo.userInfo()["licenseCode"] as? String
        XCTAssert(hasValue(licenseCode))
        if let licenseCode = licenseCode {
            XCTAssertEqual(licenseCode, license.licenseCode)
        }
    }
    
    
    // MARK: -
    // MARK: From user info to Unregistered
    
    func testFromUserInfo_EmptyUserInfo_ReturnsNil() {
        
        let userInfo = UserInfo()
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UserInfoWithoutRegistered_ReturnsNil() {
        
        let userInfo: UserInfo = ["name" : "foo", "licenseCode" : "bar"]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UnregisteredUserInfo_ReturnsUnregistered() {
        
        let userInfo: UserInfo = ["registered" : false]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssert(hasValue(result))
        if let result = result {
            
            let valid: Bool
            switch result {
            case .Unregistered: valid = true
            default: valid = false
            }
            
            XCTAssert(valid)
        }
    }
    
    func testFromUserInfo_UnregisteredUserInfo_WithAdditionalInfo_ReturnsUnregistered() {
        
        let userInfo: UserInfo = ["registered" : false, "bogus" : 123]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssert(hasValue(result))
        if let result = result {
            
            let valid: Bool
            switch result {
            case .Unregistered: valid = true
            default: valid = false
            }
            
            XCTAssert(valid)
        }
    }
    
    
    // MARK: From user info to Registered
    
    func testFromUserInfo_RegisteredUserInfo_WithoutDetails_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "name" : "a name"]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithLicenseCodeOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "licenseCode" : "a license code"]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCode_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        switch result {
        case let .Some(.Registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)
        default:
            XCTFail("expected Registered")
        }
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCodeAndAdditionalData_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode, "irrelevant" : 999]
        
        let result = LicenseInformation.fromUserInfo(userInfo)
        
        switch result {
        case let .Some(.Registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)
        default:
            XCTFail("expected Registered")
        }
    }
}
