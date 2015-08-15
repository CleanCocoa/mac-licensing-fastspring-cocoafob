import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var licenseProvider: LicenseProvider = LicenseProvider()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        switch licenseProvider.currentLicense {
        case .Unregistered:
            showRegisterApp()
        case let .Registered(license):
            unlockApp()
        }
    }
    
    var licenseWindowController: LicenseWindowController?
    
    func showRegisterApp() {
        
        let licenseWindowController = LicenseWindowController(windowNibName: "LicenseWindowController")
        licenseWindowController.showWindow(self)
        
        self.licenseWindowController = licenseWindowController
    }
    
    func unlockApp() {
        
        window.makeKeyAndOrderFront(self)
    }
}
