// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import AppKit

func loadWindow(_ controller: NSWindowController) {
    forceInitialize(controller.window)
}

func loadView(_ controller: NSViewController) {
    forceInitialize(controller.view)
}

func forceInitialize(_ view: NSView) {
    // no op
}

func forceInitialize(_ view: NSWindow?) {
    // no op
}

class NullUserDefaults: UserDefaults {
    
    override func register(defaults registrationDictionary: [String : Any]) {  }
    override func value(forKey key: String) -> Any? { return nil }
    override func setValue(_ value: Any?, forKey key: String) {  }
}
