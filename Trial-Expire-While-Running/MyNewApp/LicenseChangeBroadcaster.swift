// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [AnyHashable : Any]

extension Licensing {
    
    public func userInfo() -> UserInfo {
        
        switch self {
        case let .trial(trialPeriod):
            return [
                "registered" : false,
                "on_trial" : true,
                "trial_start_date"  : trialPeriod.startDate,
                "trial_end_date" : trialPeriod.endDate,
            ]
        case let .registered(license):
            return [
                "registered" : true,
                "on_trial" : false,
                "name" : license.name,
                "licenseCode"  : license.licenseCode
            ]
        case .trialUp:
            return [
                "registered" : false,
                "on_trial" : false
            ]
        }
    }
    
    public static func fromUserInfo(userInfo: UserInfo) -> Licensing? {
        
        guard let registered = userInfo["registered"] as? Bool else {
            return nil
        }
        
        if let onTrial = userInfo["on_trial"] as? Bool,
            !registered {
            
            guard onTrial else { return .trialUp }
            
            if let startDate = userInfo["trial_start_date"] as? Date,
                let endDate = userInfo["trial_end_date"] as? Date {
                    
                return .trial(TrialPeriod(startDate: startDate, endDate: endDate))
            }
        }
        
        guard let name = userInfo["name"] as? String,
            let licenseCode = userInfo["licenseCode"] as? String
            else { return nil }
        
        return .registered(License(name: name, licenseCode: licenseCode))
    }
}


extension Licensing {
    public static let licenseChangedNotification: Notification.Name = Notification.Name(rawValue: "License Changed")
}

public class LicenseChangeBroadcaster {
    let notificationCenter: NotificationCenter

    public init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    public func broadcast(_ licensing: Licensing) {
        notificationCenter.post(
            name: Licensing.licenseChangedNotification,
            object: self,
            userInfo: licensing.userInfo())
    }
}
