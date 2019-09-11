// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [AnyHashable: Any]

extension Licensing {
    
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
    
    public init?(fromUserInfo userInfo: UserInfo) {
        
        guard let registered = userInfo["registered"] as? Bool else {
            return nil
        }
        
        if !registered {
            self = .unregistered
            return
        }
        
        guard let name = userInfo["name"] as? String,
            let licenseCode = userInfo["licenseCode"] as? String
            else { return nil }
        
        self = .registered(License(name: name, licenseCode: licenseCode))
    }
}

extension Licensing {
    public static let licenseChangedNotification: Notification.Name = Notification.Name(rawValue: "License Changed")
}

public class LicenseChangeBroadcaster {
    
    public lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    
    public init() { }
    
    public func broadcast(_ licensing: Licensing) {
        notificationCenter.post(
            name: Licensing.licenseChangedNotification,
            object: self,
            userInfo: licensing.userInfo())
    }
}
