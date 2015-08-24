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
