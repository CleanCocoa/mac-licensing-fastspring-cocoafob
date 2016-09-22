// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

public protocol HandlesPurchases {
    
    func purchase()
}

open class LicenseWindowController: NSWindowController {
    
    static let NibName = "LicenseWindowController"
    
    public convenience init() {
        
        self.init(windowNibName: LicenseWindowController.NibName)
    }
    
    @IBOutlet open var existingLicenseViewController: ExistingLicenseViewController!
    @IBOutlet open var buyButton: NSButton!
    
    open var purchasingEventHandler: HandlesPurchases?
    
    @IBAction open func buy(_ sender: AnyObject) {
        
        purchasingEventHandler?.purchase()
    }
        
    open func displayLicenseInformation(_ licenseInformation: LicenseInformation) {
        
        switch licenseInformation {
        case .unregistered: existingLicenseViewController.displayEmptyForm()
        case let .registered(license): existingLicenseViewController.displayLicense(license)
        }
    }
    
    open var registrationEventHandler: HandlesRegistering? {
        
        set {
            existingLicenseViewController.eventHandler = newValue
        }
        
        get {
            return existingLicenseViewController.eventHandler
        }
    }
}
