import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    lazy var licenseProvider: LicenseProvider = LicenseProvider()
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    var purchaseLicense: HandlesPurchases!
    var registerApplication = RegisterApplication()
    
    lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    
    // MARK: Startup
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        observeLicenseChanges()
        prepareLicenseWindowController()
        launchAppOrShowLicenseWindow()
    }
    
    func observeLicenseChanges() {
        
        notificationCenter.addObserver(self, selector: Selector("licenseDidChange:"), name: Events.LicenseChanged.rawValue, object: nil)
    }
    
    func prepareLicenseWindowController() {
        
        let storeInfo = StoreInfoReader.storeInfo()
        let store = Store(storeInfo: storeInfo)
        purchaseLicense = PurchaseLicense(store: store, registerApplication: registerApplication)
        
        licenseWindowController.purchasingEventHandler = purchaseLicense
    }
    
    func launchAppOrShowLicenseWindow() {
        
        switch licenseProvider.currentLicense {
        case .Unregistered:
            showRegisterApp()
        case let .Registered(license):
            unlockApp()
        }
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
    }

    
    // MARK: License changes
    
    func licenseDidChange(notification: NSNotification) {
        
        if let userInfo = notification.userInfo, licenseInformation = LicenseInformation.fromUserInfo(userInfo) {
            
            switch licenseInformation {
            case .Registered(_):
                displayThankYouAlert()
                unlockApp()
                
            case .Unregistered:
                // If you support un-registering, handle it here
                return
            }
        }
    }
    
    func displayThankYouAlert() {
        
        Alerts.thankYouAlert()?.runModal()
    }
}

class StoreInfoReader {
    
    static func storeInfo() -> StoreInfo {
        
        let storeId = ""
        
        let productName = ""
        let productId = ""
        
        #if DEBUG
            NSLog("Test Store Mode")
            let storeMode = kFsprgModeTest
        #else
            NSLog("Active Store Mode")
            let storeMode = kFsprgModeActive
        #endif
        
        return StoreInfo(storeId: storeId, productName: productName, productId: productId, storeMode: storeMode)
    }
}
