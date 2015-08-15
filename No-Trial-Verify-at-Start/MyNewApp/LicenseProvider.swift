import Foundation

public struct License {
    public let name: String
    public let key: String
}

public enum LicenseInformation {
    case Unregistered
    case Registered(License)
}

public class LicenseProvider {
    
    enum UserDefaultsKeys: String, Printable {
        case Name = "licensee"
        case Key = "license_code"
        
        var description: String { return rawValue }
    }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    var currentLicense: LicenseInformation {
        
        if let name = userDefaults.stringForKey("\(UserDefaultsKeys.Name)"),
            key = userDefaults.stringForKey("\(UserDefaultsKeys.Key)") {
                
                return .Registered(License(name: name, key: key))
        }
        
        return .Unregistered
    }
    
    public init() { }
}
