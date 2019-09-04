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
}

extension License {
    internal struct DefaultsKey: RawRepresentable {
        let rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        static let name = DefaultsKey(rawValue: "licensee")
        static let licenseCode = DefaultsKey(rawValue: "license_code")
    }
}

extension License: Equatable { }

public func ==(lhs: License, rhs: License) -> Bool {
    return lhs.name == rhs.name
        && lhs.licenseCode == rhs.licenseCode
}
