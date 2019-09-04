// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

fileprivate func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
    
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
        
        let licenseInfo = LicenseState.trialUp
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.licenseChanged.notificationName)
            XCTAssert(values.object as? LicenseChangeBroadcaster === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }
    
    func testBroadcast_OnTrial_PostsNotification() {
        
        let licenseInfo = LicenseState.onTrial(TrialPeriod(startDate: Date(), endDate: Date()))
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.licenseChanged.notificationName)
            XCTAssert(values.object as? LicenseChangeBroadcaster === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }

    func testBroadcast_Registered_PostsNotification() {
        
        let licenseInfo = LicenseState.registered(License(name: "the name", licenseCode: "a license"))
        
        broadcaster.broadcast(licenseInfo)
        
        let values = notificationCenterDouble.didPostNotificationNameWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            XCTAssertEqual(values.name, Events.licenseChanged.notificationName)
            XCTAssert(values.object as? LicenseChangeBroadcaster === broadcaster)
            
            XCTAssert(hasValue(values.userInfo))
            if let userInfo = values.userInfo {
                XCTAssert(userInfo == licenseInfo.userInfo())
            }
        }
    }
    
    
    // MARK: -
    
    class TestNotificationCenter: NullNotificationCenter {
        
        var didPostNotificationNameWith: (name: Notification.Name, object: Any?, userInfo: UserInfo?)?
        override func post(name aName: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) {
            
            didPostNotificationNameWith = (aName, anObject, aUserInfo)
        }
    }
}

class NullNotificationCenter: NotificationCenter {
    
    override class var `default`: NotificationCenter {
        return NullNotificationCenter()
    }
    
    override func addObserver(forName name: Notification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        
        return NSObject()
    }
    
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: Notification.Name?, object anObject: Any?) {  }
    
    override func removeObserver(_ observer: Any) { }
    override func removeObserver(_ observer: Any, name aName: Notification.Name?, object anObject: Any?) { }
    
    override func post(_ notification: Notification) { }
    override func post(name aName: Notification.Name, object anObject: Any?) { }
    override func post(name aName: Notification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable: Any]?) { }
}
