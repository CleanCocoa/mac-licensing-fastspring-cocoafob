// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil
let initialTrialDuration = Days(5)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var notificationCenter: NotificationCenter = NotificationCenter.default
    lazy var licenseChangeBroadcaster: LicenseChangeBroadcaster = LicenseChangeBroadcaster(notificationCenter: self.notificationCenter)
    
    // Use a clock replacement to see how the app start-up changes.
//    let clock = StaticClock(clockDate: NSDate(timeIntervalSinceNow: 10 /* days */ * 24 * 60 * 60))
    let clock = Clock()
    var trialTimer: TrialTimer?
    
    var trialProvider = TrialProvider()
    var licenseProvider = LicenseProvider()
    lazy var licensingProvider: LicensingProvider = LicensingProvider(
        trialProvider: self.trialProvider,
        licenseProvider: self.licenseProvider,
        clock: self.clock)
    
    // User Interface
    @IBOutlet weak var window: NSWindow!
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    // Use Cases / Services
    lazy var registerApplication: RegisterApplication = RegisterApplication(licenseVerifier: LicenseVerifier(), licenseWriter: LicenseWriter(), changeBroadcaster: self.licenseChangeBroadcaster)
    var purchaseLicense: PurchaseLicense!
    
    
    // MARK: Startup
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if isRunningTests {
            return
        }
        
        prepareTrialOnFirstLaunch()
        startTrialTimer()
        
        registerForURLScheme()
        observeLicenseChanges()
        prepareLicenseWindowController()
        launchAppOrShowLicenseWindow()
    }
    
    func prepareTrialOnFirstLaunch() {
        
        // If someone deletes the values from user defaults,
        // they will be able to get a new trial period. So
        // better use a different reader/writer in your app.
        
        if hasValue(trialProvider.trialPeriod) {
            return
        }
        
        let trialPeriod = TrialPeriod(numberOfDays: initialTrialDuration, clock: clock)
        TrialWriter().store(trialPeriod: trialPeriod)
    }
    
    func startTrialTimer() {
        
        stopTrialTimer()
        
        guard let trialPeriod = trialProvider.trialPeriod else {
            return
        }
        
        trialTimer = TrialTimer(trialEndDate: trialPeriod.endDate, licenseChangeBroadcaster: licenseChangeBroadcaster)
        trialTimer!.start()
    }
    
    func stopTrialTimer() {
        
        if let trialTimer = trialTimer , trialTimer.isRunning {
            
            trialTimer.stop()
        }
        
        trialTimer = nil
    }
    
    func registerForURLScheme() {
        
        NSAppleEventManager.shared()
            .setEventHandler(
                self,
                andSelector: #selector(AppDelegate.handle(getUrlEvent:withReplyEvent:)),
                forEventClass: AEEventClass(kInternetEventClass),
                andEventID: AEEventID(kAEGetURL))
    }

    @objc func handle(getUrlEvent event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
        
        if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue,
            let url = URL(string: urlString) {
            
            // If you support multiple actions, here'd be the place to
            // delegate to a router object instead.
            
            URLQueryRegistration(registrationHandler: registerApplication)
                .register(fromUrl: url)
        }
    }
    
    func observeLicenseChanges() {
        
        notificationCenter.addObserver(
            self,
            selector: #selector(AppDelegate.licenseDidChange(notification:)),
            name: Licensing.licenseChangedNotification,
            object: nil)
    }
    
    func prepareLicenseWindowController() {
        
        let storeInfo = StoreInfoReader.defaultStoreInfo()
        assert(hasValue(storeInfo), "Provide store details in FastSpringCredentials")
        
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
        case .trialUp:
            if licenseIsInvalid() {
                displayInvalidLicenseAlert()
            }
            
            showRegisterApp()
            
        case let .trial(trialPeriod):
            if licenseIsInvalid() {
                displayInvalidLicenseAlert()
            }
            
            let trialDaysLeft = trialPeriod.daysLeft(clock: clock)
            displayTrialDaysLeftAlert(daysLeft: trialDaysLeft)
            
            unlockApp()
            
        case .registered(_):
            
            stopTrialTimer()
            unlockApp()
        }
    }
    
    func licenseIsInvalid() -> Bool {
        
        return licensingProvider.licenseIsInvalid
    }
    
    
    // MARK: License changes
    
    @objc func licenseDidChange(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
            let licensing = Licensing.fromUserInfo(userInfo: userInfo)
            else { return }
        
        switch licensing {
        case .trial(_):
            // Change to this state is possible if unregistering while
            // trial isn't up, yet.
            return
            
        case .registered(_):
            displayThankYouAlert()
            stopTrialTimer()
            unlockApp()
            
        case .trialUp:
            displayTrialUpAlert()
            lockApp()
            showRegisterApp()
        }
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
        licenseWindowController.display(licensing: currentLicensing, clock: clock)
    }
    
    func unlockApp() {
        
        licenseWindowController.close()
        window.makeKeyAndOrderFront(self)
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
        
        let numberOfDaysLeft = daysLeft.userFacingAmount
        Alerts.trialDaysLeftAlert(daysLeft: numberOfDaysLeft)?.runModal()
    }
    
    func displayTrialUpAlert() {
        
        Alerts.trialUpAlert()?.runModal()
    }
    
    func displayInvalidLicenseAlert() {
        
        Alerts.invalidLicenseCodeAlert()?.runModal()
    }
    
    
    // MARK: UI Interactions
    
    // NOTE: Don't cram too much into your AppDelegate. Extract the window
    // from the MainMenu Nib instead and provide a real `NSWindowController`.
    
    @IBAction func reviewLicense(_ sender: AnyObject) {
    
        showRegisterApp()
    }
}
