// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [AnyHashable: Any]

extension LicenseInformation {
    
    public func userInfo() -> UserInfo {
        
        switch self {
        case .unregistered:
            return ["registered" : false]
        case let .registered(license):
            return [
                "registered" : true,
                "name" : license.name,
                "licenseCode" : license.licenseCode
            ]
        }
    }
    
    public static func fromUserInfo(_ userInfo: UserInfo) -> LicenseInformation? {
        
        guard let registered = userInfo["registered"] as? Bool else {
            return nil
        }
        
        if !registered {
            return .unregistered
        }
        
        guard let name = userInfo["name"] as? String, let licenseCode = userInfo["licenseCode"] as? String else {
            return nil
        }
        
        return .registered(License(name: name, licenseCode: licenseCode))
    }
}

public enum Events: String {
    
    case licenseChanged = "License Changed"

    var notificationName: NSNotification.Name {
        return NSNotification.Name(self.rawValue)
    }
}

open class LicenseChangeBroadcaster {
    
    open lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    
    public init() { }
    
    open func broadcast(_ licenseInformation: LicenseInformation) {
        
        notificationCenter.post(name: Notification.Name(rawValue: Events.licenseChanged.rawValue), object: self, userInfo: licenseInformation.userInfo())
    }
}
