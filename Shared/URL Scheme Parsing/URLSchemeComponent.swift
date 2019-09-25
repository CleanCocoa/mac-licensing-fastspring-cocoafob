// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

struct URLSchemeComponent: RawRepresentable, Hashable {

    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let host = URLSchemeComponent(rawValue: "activate")
    static let licensee = URLSchemeComponent(rawValue: "name")
    static let licenseCode = URLSchemeComponent(rawValue: "licenseCode")

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
