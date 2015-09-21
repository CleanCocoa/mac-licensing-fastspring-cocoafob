// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [NSObject : AnyObject]

extension LicenseInformation {
    
    public func userInfo() -> UserInfo {
        
        switch self {
        case .Unregistered:
            return ["registered" : false]
        case let .Registered(license):
            return [
                "registered" : true,
                "name" : license.name,
                "licenseCode" : license.licenseCode
            ]
        }
    }
    
    public static func fromUserInfo(userInfo: UserInfo) -> LicenseInformation? {
        
        guard let registered = userInfo["registered"] as? Bool else {
            return nil
        }
        
        if !registered {
            return .Unregistered
        }
        
        guard let name = userInfo["name"] as? String, licenseCode = userInfo["licenseCode"] as? String else {
            return nil
        }
        
        return .Registered(License(name: name, licenseCode: licenseCode))
    }
}

public enum Events: String {
    
    case LicenseChanged = "License Changed"
}

public class LicenseChangeBroadcaster {
    
    public lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    public init() { }
    
    public func broadcast(licenseInformation: LicenseInformation) {
        
        notificationCenter.postNotificationName(Events.LicenseChanged.rawValue, object: self, userInfo: licenseInformation.userInfo())
    }
}
