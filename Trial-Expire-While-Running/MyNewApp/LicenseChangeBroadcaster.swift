// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public typealias UserInfo = [NSObject : AnyObject]

extension LicenseInformation {
    
    public func userInfo() -> UserInfo {
        
        switch self {
        case let .OnTrial(trialPeriod):
            return [
                "registered" : false,
                "on_trial" : true,
                "trial_start_date" : trialPeriod.startDate,
                "trial_end_date" : trialPeriod.endDate,
            ]
        case let .Registered(license):
            return [
                "registered" : true,
                "on_trial" : false,
                "name" : license.name,
                "licenseCode" : license.licenseCode
            ]
        case .TrialUp:
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
        
        if let onTrial = userInfo["on_trial"] as? Bool where !registered {
            
            if !onTrial {
                return .TrialUp
            }
            
            if let startDate = userInfo["trial_start_date"] as? NSDate,
                endDate = userInfo["trial_end_date"] as? NSDate
                where onTrial == true {
                    
                return .OnTrial(TrialPeriod(startDate: startDate, endDate: endDate))
            }
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
    
    let notificationCenter: NSNotificationCenter
    
    public init(notificationCenter: NSNotificationCenter) {
        
        self.notificationCenter = notificationCenter
    }
    
    public func broadcast(licenseInformation: LicenseInformation) {
        
        notificationCenter.postNotificationName(Events.LicenseChanged.rawValue, object: self, userInfo: licenseInformation.userInfo())
    }
}