// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

let isRunningTests = NSClassFromString("XCTestCase") != nil
let initialTrialDuration = Days(5)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()
    lazy var licenseChangeBroadcaster: LicenseChangeBroadcaster = LicenseChangeBroadcaster(notificationCenter: self.notificationCenter)
    
    // Use a clock replacement to see how the app start-up changes.
//    let clock = StaticClock(clockDate: NSDate(timeIntervalSinceNow: 10 /* days */ * 24 * 60 * 60))
    let clock = Clock()
    var trialTimer: TrialTimer?
    
    var trialProvider = TrialProvider()
    var licenseProvider = LicenseProvider()
    lazy var licenseInfoProvider: LicenseInformationProvider = LicenseInformationProvider(trialProvider: self.trialProvider, licenseProvider: self.licenseProvider, clock: self.clock)
    
    // User Interface
    @IBOutlet weak var window: NSWindow!
    lazy var licenseWindowController: LicenseWindowController = LicenseWindowController()
    
    // Use Cases / Services
    lazy var registerApplication: RegisterApplication = RegisterApplication(licenseVerifier: LicenseVerifier(), licenseWriter: LicenseWriter(), changeBroadcaster: self.licenseChangeBroadcaster)
    var purchaseLicense: PurchaseLicense!
    
    
    // MARK: Startup
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        if isRunningTests {
            return
        }
        
        prepareTrialOnFirstLaunch()
        startTrialTimer()
        observeLicenseChanges()
        prepareLicenseWindowController()
        launchAppOrShowLicenseWindow()
    }
    
    func prepareTrialOnFirstLaunch() {
        
        // If someone deletes the values from user defaults,
        // they will be able to get a new trial period. So
        // better use a different reader/writer in your app.
        
        if hasValue(trialProvider.currentTrialPeriod) {
            return
        }
        
        let trialPeriod = TrialPeriod(numberOfDays: initialTrialDuration, clock: clock)
        TrialWriter().storeTrial(trialPeriod)
    }
    
    func startTrialTimer() {
        
        stopTrialTimer()
        
        if let trialPeriod = trialProvider.currentTrialPeriod {
            
            trialTimer = TrialTimer(trialEndDate: trialPeriod.endDate, licenseChangeBroadcaster: licenseChangeBroadcaster)
            trialTimer!.start()
        }
    }
    
    func stopTrialTimer() {
        
        if let trialTimer = trialTimer where trialTimer.isRunning {
            
            trialTimer.stop()
        }
        
        trialTimer = nil
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
    
    var currentLicenseInformation: LicenseInformation {
        
        return licenseInfoProvider.currentLicenseInformation
    }
    
    func launchAppOrShowLicenseWindow() {
        
        switch currentLicenseInformation {
        case .TrialUp:
            
            showRegisterApp()
            
        case let .OnTrial(trialPeriod):
            
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
                stopTrialTimer()
                unlockApp()
                
            case .TrialUp:
                displayTrialUpAlert()
                lockApp()
                showRegisterApp()
            }
        }
    }
    
    
    // MARK: Show windows
    
    func showRegisterApp() {
        
        licenseWindowController.showWindow(self)
        licenseWindowController.registrationEventHandler = registerApplication
        licenseWindowController.displayLicenseInformation(currentLicenseInformation)
        
        if let trial = trialProvider.currentTrialWithClock(clock) where !trial.ended {
            
            licenseWindowController.displayTrialDaysLeft(trial.daysLeft)
        } else {
            
            licenseWindowController.displayTrialUp()
        }
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
        Alerts.trialDaysLeftAlert(numberOfDaysLeft)?.runModal()
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
    
    @IBAction func reviewLicense(sender: AnyObject) {
    
        showRegisterApp()
    }
}
