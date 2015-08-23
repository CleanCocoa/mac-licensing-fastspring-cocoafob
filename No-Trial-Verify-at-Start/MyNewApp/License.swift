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

extension License: Equatable { }

public func ==(lhs: License, rhs: License) -> Bool {
    
    return lhs.name == rhs.name && lhs.key == rhs.key
}

public enum LicenseInformation {
    case Unregistered
    case Registered(License)
}
