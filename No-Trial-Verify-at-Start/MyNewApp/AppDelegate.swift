// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    
    lazy var licenseProvider = LicenseProvider()
    lazy var licensingProvider: LicensingProvider = LicensingProvider(licenseProvider: self.licenseProvider)
    
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    // Use Cases / Services
    var purchaseLicense: PurchaseLicense!
    var registerApplication = RegisterApplication()
    
    
    // MARK: Startup
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if isRunningTests {
            return
        }
        
        registerForURLScheme()
        observeLicenseChanges()
        prepareLicenseWindowController()
        launchAppOrShowLicenseWindow()
    }
    
    func registerForURLScheme() {
        
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(AppDelegate.handleGetUrlEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    @objc func handleGetUrlEvent(_ event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) else {
            return
        }
        
        // If you support multiple actions, here'd be the place to 
        // delegate to a router object instead.
        
        URLQueryRegistration(registrationHandler: registerApplication)
            .register(fromURL: url)
    }

    func observeLicenseChanges() {
        
        notificationCenter.addObserver(
            self,
            selector: #selector(AppDelegate.licenseDidChange(_:)),
            name: Licensing.licenseChangedNotification,
            object: nil)
    }
    
    func prepareLicenseWindowController() {
        
        let storeInfo = StoreInfoReader.defaultStoreInfo()
        assert(storeInfo != nil, "Provide store details in FastSpringCredentials.plist")
        
        let store = Store(storeInfo: storeInfo!)
        purchaseLicense = PurchaseLicense(store: store, registerApplication: registerApplication)

        store.storeDelegate = purchaseLicense
        licenseWindowController.purchasingEventHandler = purchaseLicense
    }
    
    var currentLicensing: Licensing {
        
        return licensingProvider.licensing
    }
    
    func launchAppOrShowLicenseWindow() {
        
        switch currentLicensing {
        case .unregistered:
            // Show an alert if there is license info stored, but it's not valid. Could happen if the user mangles with the UserDefaults.
            if hasInvalidLicenseInformation {
                displayInvalidLicenseAlert()
            }
            
            showRegisterApp()

        case .registered(_):
            unlockApp()
        }
    }
    
    fileprivate var hasInvalidLicenseInformation: Bool {
        return licenseProvider.hasInvalidLicenseInformation
    }
    
    func displayInvalidLicenseAlert() {
        
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
        licenseWindowController.display(licensing: currentLicensing)
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
    }

    
    // MARK: License changes
    
    @objc func licenseDidChange(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let licensing = Licensing.fromUserInfo(userInfo)
            else { return }
        
        switch licensing {
        case .registered(_):
            displayThankYouAlert()
            unlockApp()
            
        case .unregistered:
            // If you support un-registering, handle it here
            return
        }
    }
    
    func displayThankYouAlert() {
        
        Alerts.thankYouAlert()?.runModal()
    }
    
    
    // MARK: UI Interactions
    
    // NOTE: Don't cram too much into your AppDelegate. Extract the window
    // from the MainMenu Nib instead and provide a real `NSWindowController`.
    
    @IBAction func reviewLicense(_ sender: AnyObject) {
    
        showRegisterApp()
    }
}
