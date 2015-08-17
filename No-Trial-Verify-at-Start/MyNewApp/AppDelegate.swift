import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var licenseProvider: LicenseProvider = LicenseProvider()
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    var licenseEventHandler: HandlesRegistering = RegisterApplication()
    
    lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        notificationCenter.addObserver(self, selector: Selector("licenseDidChange:"), name: Events.LicenseChanged.rawValue, object: nil)
        
        switch licenseProvider.currentLicense {
        case .Unregistered:
            showRegisterApp()
        case let .Registered(license):
            unlockApp()
        }
    }
    
    func licenseDidChange(notification: NSNotification) {
        
        if let userInfo = notification.userInfo, licenseInformation = LicenseInformation.fromUserInfo(userInfo) {
            
            switch licenseInformation {
            case .Registered(_):
                displayThankYouAlert()
                unlockApp()
                
            default:
                // If you support un-registering, handle it here
                return
            }
        }
    }
    
    func displayThankYouAlert() {
        
        let alert = NSAlert()
        alert.alertStyle = .InformationalAlertStyle
        alert.messageText = "Thank You for Purchasing!"
        alert.addButtonWithTitle("Continue")
        
        alert.runModal()
    }
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = licenseEventHandler
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
    }
}
