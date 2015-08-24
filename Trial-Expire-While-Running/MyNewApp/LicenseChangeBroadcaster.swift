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
        
        if let registered = userInfo["registered"] as? Bool {
            
            if !registered {
                return .Unregistered
            }
            
            if let name = userInfo["name"] as? String, licenseCode = userInfo["licenseCode"] as? String {
                
                return .Registered(License(name: name, licenseCode: licenseCode))
            }
        }
        
        return nil
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
