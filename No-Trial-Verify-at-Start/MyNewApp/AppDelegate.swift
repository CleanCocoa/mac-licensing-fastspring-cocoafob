// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    
    var licenseProvider = LicenseProvider()
    lazy var licenseInfoProvider: LicenseStateProvider = LicenseStateProvider(licenseProvider: self.licenseProvider)
    
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
            .registerFromURL(url)
    }

    func observeLicenseChanges() {
        
        notificationCenter.addObserver(self, selector: #selector(AppDelegate.licenseDidChange(_:)), name: NSNotification.Name(rawValue: Events.licenseChanged.rawValue), object: nil)
    }
    
    func prepareLicenseWindowController() {
        
        let storeInfo = StoreInfoReader.defaultStoreInfo()
        assert(hasValue(storeInfo), "Provide store details in FastSpringCredentials")
        
        let store = Store(storeInfo: storeInfo!)
        purchaseLicense = PurchaseLicense(store: store, registerApplication: registerApplication)

        store.storeDelegate = purchaseLicense
        licenseWindowController.purchasingEventHandler = purchaseLicense
    }
    
    var currentLicenseState: LicenseState {
        
        return licenseInfoProvider.currentLicenseState
    }
    
    func launchAppOrShowLicenseWindow() {
        
        switch currentLicenseState {
        case .unregistered:
            if licenseIsInvalid() {
                displayInvalidLicenseAlert()
            }
            
            showRegisterApp()
        case .registered(_):
            
            unlockApp()
        }
    }
    
    func licenseIsInvalid() -> Bool {
        
        return licenseInfoProvider.licenseIsInvalid
    }
    
    func displayInvalidLicenseAlert() {
        
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
        licenseWindowController.display(licenseState: currentLicenseState)
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
    }

    
    // MARK: License changes
    
    @objc func licenseDidChange(_ notification: Notification) {
        
        guard let userInfo = (notification as NSNotification).userInfo,
            let licenseState = LicenseState.fromUserInfo(userInfo)
            else { return }
        
        switch licenseState {
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
