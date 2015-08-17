import Foundation

public struct License {
    
    public let name: String
    public let key: String
    
    public init(name: String, key: String) {
        
        self.name = name
        self.key = key
    }
    
    public enum UserDefaultsKeys: String, Printable {
        
        case Name = "licensee"
        case Key = "license_code"
        
        public var description: String { return rawValue }
    }
}

public enum LicenseInformation {
    case Unregistered
    case Registered(License)
}

public class LicenseProvider {
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public var currentLicense: LicenseInformation {
        
        if let name = userDefaults.stringForKey("\(License.UserDefaultsKeys.Name)"),
            key = userDefaults.stringForKey("\(License.UserDefaultsKeys.Key)") {
                
                return .Registered(License(name: name, key: key))
        }
        
        return .Unregistered
    }
    
    public init() { }
}
