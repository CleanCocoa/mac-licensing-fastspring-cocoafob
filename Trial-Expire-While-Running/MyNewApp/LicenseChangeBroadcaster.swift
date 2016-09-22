// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [AnyHashable : Any]

extension LicenseInformation {
    
    public func userInfo() -> UserInfo {
        
        switch self {
        case let .onTrial(trialPeriod):
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
    
    public static func fromUserInfo(userInfo: UserInfo) -> LicenseInformation? {
        
        guard let registered = userInfo["registered"] as? Bool else {
            return nil
        }
        
        if let onTrial = userInfo["on_trial"] as? Bool,
            !registered {
            
            guard onTrial else { return .trialUp }
            
            if let startDate = userInfo["trial_start_date"] as? Date,
                let endDate = userInfo["trial_end_date"] as? Date {
                    
                return .onTrial(TrialPeriod(startDate: startDate, endDate: endDate))
            }
        }
        
        guard let name = userInfo["name"] as? String,
            let licenseCode = userInfo["licenseCode"] as? String
            else { return nil }
        
        return .registered(License(name: name, licenseCode: licenseCode))
    }
}

public enum Events: String {
    
    case licenseChanged = "License Changed"

    var notificationName: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

public class LicenseChangeBroadcaster {
    
    let notificationCenter: NotificationCenter
    
    public init(notificationCenter: NotificationCenter) {
        
        self.notificationCenter = notificationCenter
    }
    
    public func broadcast(_ licenseInformation: LicenseInformation) {
        
        notificationCenter.post(name: Events.licenseChanged.notificationName, object: self, userInfo: licenseInformation.userInfo())
    }
}
