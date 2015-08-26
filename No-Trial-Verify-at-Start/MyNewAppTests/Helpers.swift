import AppKit

func loadWindow(controller: NSWindowController) {
    forceInitialize(controller.window)
}

func loadView(controller: NSViewController) {
    forceInitialize(controller.view)
}

func forceInitialize(view: NSView) {
    // no op
}

func forceInitialize(view: NSWindow?) {
    // no op
}

class NullUserDefaults: NSUserDefaults {
    
    override func registerDefaults(registrationDictionary: [NSObject : AnyObject]) {  }
    override func valueForKey(key: String) -> AnyObject? { return nil }
    override func setValue(value: AnyObject?, forKey key: String) {  }
}
