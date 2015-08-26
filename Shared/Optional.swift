// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

func hasValue<T>(value: T?) -> Bool {
    switch (value) {
    case .Some(_): return true
    case .None: return false
    }
}
