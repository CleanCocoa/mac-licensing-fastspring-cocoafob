// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

public struct License {
    public let name: String
    public let licenseCode: String

    public init(name: String, licenseCode: String) {
        self.name = name
        self.licenseCode = licenseCode
    }

    enum UserDefaultsKeys: String, CustomStringConvertible {

        case name = "licensee"
        case licenseCode = "license_code"
        
        public var description: String { return rawValue }
    }
}

extension License: Equatable { }

public func ==(lhs: License, rhs: License) -> Bool {
    return lhs.name == rhs.name
        && lhs.licenseCode == rhs.licenseCode
}
