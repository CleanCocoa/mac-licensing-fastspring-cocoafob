import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var licenseProvider: LicenseProvider = LicenseProvider()
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    lazy var licenseEventHandler: HandlesRegistering? = RegisterApplication()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        licenseWindowController.registrationEventHandler = licenseEventHandler
        
        switch licenseProvider.currentLicense {
        case .Unregistered:
            showRegisterApp()
        case let .Registered(license):
            unlockApp()
        }
    }
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
    }
    
    func unlockApp() {
        
        window.makeKeyAndOrderFront(self)
    }
}
