// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

private func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
    
    if lhs.count != rhs.count { return false }
    
    return lhs["registered"] as? Bool == rhs["registered"] as? Bool
        && lhs["name"] as? String == rhs["name"] as? String
        && lhs["licenseCode"] as? String == rhs["licenseCode"] as? String
}

class LicenseChangeBroadcasterTests: XCTestCase {

    var broadcaster: LicenseChangeBroadcaster!
    let notificationCenterDouble = TestNotificationCenter()
    
    override func setUp() {
        
        super.setUp()
        
        broadcaster = LicenseChangeBroadcaster(notificationCenter: notificationCenterDouble)
    }
    
    func testBroadcast_TrialUp_PostsNotification() {
        
        let licenseInfo = LicenseInformation.TrialUp
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.LicenseChanged.rawValue)
            XCTAssert(values.object === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }
    
    func testBroadcast_OnTrial_PostsNotification() {
        
        let licenseInfo = LicenseInformation.OnTrial(TrialPeriod(startDate: NSDate(), endDate: NSDate()))
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.LicenseChanged.rawValue)
            XCTAssert(values.object === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }

    func testBroadcast_Registered_PostsNotification() {
        
        let licenseInfo = LicenseInformation.Registered(License(name: "the name", licenseCode: "a license"))
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.LicenseChanged.rawValue)
            XCTAssert(values.object === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }
    
    
    // MARK: -
    
    class TestNotificationCenter: NullNotificationCenter {
        
        var didPostNotificationNameWith: (name: String, object: AnyObject?, userInfo: UserInfo?)?
        override func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?) {
            
            didPostNotificationNameWith = (aName, anObject, aUserInfo)
        }
    }
}

class NullNotificationCenter: NSNotificationCenter {
    
    override static func defaultCenter() -> NSNotificationCenter {
        return NullNotificationCenter()
    }
    
    override func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol {
        
        return NSObject()
    }
    
    override func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?) {  }
    
    override func removeObserver(observer: AnyObject) { }
    override func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?) { }
    
    override func postNotification(notification: NSNotification) { }
    override func postNotificationName(aName: String, object anObject: AnyObject?) { }
    override func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?) { }
}
