// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

struct URLSchemeComponents: RawRepresentable, Hashable {

    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let host = URLSchemeComponents(rawValue: "activate")
    static let licensee = URLSchemeComponents(rawValue: "name")
    static let licenseCode = URLSchemeComponents(rawValue: "licenseCode")

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
