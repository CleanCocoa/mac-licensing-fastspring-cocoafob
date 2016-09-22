// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

enum URLComponents: String, CustomStringConvertible {
    
    case host = "activate"
    case licensee = "name"
    case licenseCode = "licenseCode"
    
    var description: String { return rawValue }
}

func ==(lhs: String, rhs: URLComponents) -> Bool {
    
    return lhs == rhs.rawValue
}
