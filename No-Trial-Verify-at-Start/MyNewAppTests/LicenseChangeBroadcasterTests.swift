// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

private func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
    
    if lhs.count != rhs.count { return false }
    
    return lhs["registered"] as? Bool == rhs["registered"] as? Bool
        && lhs["name"] as? String == rhs["name"] as? String
        && lhs["licenseCode"] as? String == rhs["licenseCode"] as? String
}

class LicenseChangeBroadcasterTests: XCTestCase {

    let broadcaster = LicenseChangeBroadcaster()
    let notificationCenterDouble = TestNotificationCenter()
    
    override func setUp() {
        
        super.setUp()
        
        broadcaster.notificationCenter = notificationCenterDouble
    }
    
    func testBroadcast_Unregistered_PostsNotification() {
        
        let licenseInfo = Licensing.unregistered
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssertNotNil(values)
        if let values = values {
            XCTAssertEqual(values.name, Licensing.licenseChangedNotification)
            XCTAssert(values.object as? LicenseChangeBroadcaster === broadcaster)
            XCTAssertEqual(values.userInfo, licenseInfo.userInfo())
        }
    }

    func testBroadcast_Registered_PostsNotification() {
        
        let licenseInfo = Licensing.registered(License(name: "the name", licenseCode: "a license"))
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssertNotNil(values)
        
        if let values = values {
            XCTAssertEqual(values.name, Licensing.licenseChangedNotification)
            XCTAssert(values.object as? LicenseChangeBroadcaster === broadcaster)
            XCTAssertEqual(values.userInfo, licenseInfo.userInfo())
        }
    }
    
    
    // MARK: -
    
    class TestNotificationCenter: NullNotificationCenter {
        
        var didPostNotificationNameWith: (name: NSNotification.Name, object: Any?, userInfo: UserInfo?)?
        override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
            
            didPostNotificationNameWith = (aName, anObject, aUserInfo)
        }
    }
}

class NullNotificationCenter: NotificationCenter {

    override class var `default`: NotificationCenter {
        return NullNotificationCenter()
    }
    
    override func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        
        return NSObject()
    }
    
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {  }
    
    override func removeObserver(_ observer: Any) { }
    override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) { }
    
    override func post(_ notification: Notification) { }
    override func post(name aName: NSNotification.Name, object anObject: Any?) { }
    override func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) { }
}
