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

/// Super-useful as `>>=` operator to chain function 
/// calls which take optionals:
///     
///     foo() >>= bar >>= baz
///
/// `.None` will cascade, `.Some(_:T)` will be passed 
/// on to the next in chain.
func bind<T, U>(optional: T?, f: T -> U?) -> U? {
    
    if let x = optional {
        return f(x)
    } else {
        return .None
    }
}

infix operator >>= {  associativity left precedence 150 }

func >>=<T, U>(optional: T?, f: T -> U?) -> U? {
    
    return bind(optional, f: f)
}
