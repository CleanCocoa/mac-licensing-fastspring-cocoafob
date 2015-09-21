// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

enum URLComponents: String, CustomStringConvertible {
    
    case Host = "activate"
    case Licensee = "name"
    case LicenseCode = "licenseCode"
    
    var description: String { return rawValue }
}

func ==(lhs: String, rhs: URLComponents) -> Bool {
    
    return lhs == rhs.rawValue
}
