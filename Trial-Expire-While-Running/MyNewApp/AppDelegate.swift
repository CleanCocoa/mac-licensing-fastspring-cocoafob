import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil
let initialTrialDuration = Days(5)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
    lazy var trialProvider: TrialProvider = TrialProvider()
    lazy var licenseProvider: LicenseProvider = LicenseProvider(trialProvider: self.trialProvider)
    
    // User Interface
    @IBOutlet weak var window: NSWindow!
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    // Use Cases / Services
    var purchaseLicense: PurchaseLicense!
    var registerApplication = RegisterApplication()
    
    
    // MARK: Startup
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        prepareTrialOnFirstLaunch()
        observeLicenseChanges()
        prepareLicenseWindowController()
        launchAppOrShowLicenseWindow()
    }
    
    func prepareTrialOnFirstLaunch() {
        
        if hasValue(trialProvider.currentTrialPeriod) {
            return
        }
        
        let trialPeriod = TrialPeriod(numberOfDays: initialTrialDuration, clock: Clock())
        TrialWriter().storeTrial(trialPeriod)
    }
    
    func observeLicenseChanges() {
        
        notificationCenter.addObserver(self, selector: Selector("licenseDidChange:"), name: Events.LicenseChanged.rawValue, object: nil)
    }
    
    func prepareLicenseWindowController() {
        
        let storeInfo = StoreInfoReader.defaultStoreInfo()
        assert(hasValue(storeInfo), "Provide store details in FastSpringCredentials")
        
        let store = Store(storeInfo: storeInfo!)
        purchaseLicense = PurchaseLicense(store: store, registerApplication: registerApplication)

        store.storeDelegate = purchaseLicense
        licenseWindowController.purchasingEventHandler = purchaseLicense
    }
    
    func launchAppOrShowLicenseWindow() {
        
        switch licenseProvider.currentLicense {
        case .TrialUp:
            showRegisterApp()
            
        case let .OnTrial(trialPeriod):
            let clock = Clock()
            let trialDaysLeft = trialPeriod.daysLeft(clock)
            displayTrialDaysLeftAlert(trialDaysLeft)
            
            unlockApp()
            
        case let .Registered(license):
            
            if licenseIsInvalid(license) {
                
                displayInvalidLicenseAlert()
                showRegisterApp()
                return
            }
            
            unlockApp()
        }
    }
    
    func licenseIsInvalid(license: License) -> Bool {
        
        return !LicenseVerifier().licenseCodeIsValid(license.licenseCode, forName: license.name)
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
        licenseWindowController.displayLicenseInformation(licenseProvider.currentLicense)
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
    }

    
    // MARK: License changes
    
    func licenseDidChange(notification: NSNotification) {
        
        if let userInfo = notification.userInfo, licenseInformation = LicenseInformation.fromUserInfo(userInfo) {
            
            switch licenseInformation {
            case .OnTrial(_):
                // Change to this state is possible if unregistering while
                // trial isn't up, yet.
                return

            case .Registered(_):
                displayThankYouAlert()
                unlockApp()
                
            case .TrialUp:
                lockApp()
                showRegisterApp()
                
                return
            }
        }
    }
    
    func lockApp() {
        
        // Disable the main application somehow.
        window.close()
    }
    
    
    // MARK: Alerts
    
    func displayThankYouAlert() {
        
        Alerts.thankYouAlert()?.runModal()
    }
    
    
    func displayTrialDaysLeftAlert(daysLeft: Days) {
        
        let numberOfDaysLeft = Int(daysLeft.amount)
        Alerts.trialDaysLeftAlert(numberOfDaysLeft)?.runModal()
    }
    
    func displayInvalidLicenseAlert() {
        
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
    
    
    
    // MARK: UI Interactions
    
    // NOTE: Don't cram too much into your AppDelegate. Extract the window
    // from the MainMenu Nib instead and provide a real `NSWindowController`.
    
    @IBAction func reviewLicense(sender: AnyObject) {
    
        showRegisterApp()
    }
}
