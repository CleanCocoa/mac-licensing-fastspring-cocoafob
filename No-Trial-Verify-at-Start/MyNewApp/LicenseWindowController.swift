// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

public protocol HandlesPurchases {
    
    func purchase()
}

public class LicenseWindowController: NSWindowController {
    
    static let NibName = "LicenseWindowController"
    
    public convenience init() {
        
        self.init(windowNibName: LicenseWindowController.NibName)
    }
    
    @IBOutlet public var existingLicenseViewController: ExistingLicenseViewController!
    @IBOutlet public var buyButton: NSButton!
    
    public var purchasingEventHandler: HandlesPurchases?
    
    @IBAction public func buy(sender: AnyObject) {
        
        purchasingEventHandler?.purchase()
    }
    
    public func licenseChanged(licenseInformation: LicenseInformation) {
        
        switch licenseInformation {
        case .Unregistered: buyButton.enabled = true
        case .Registered(_): buyButton.enabled = false
        }
    }
    
    public func displayLicenseInformation(licenseInformation: LicenseInformation) {
        
        switch licenseInformation {
        case .Unregistered: existingLicenseViewController.displayEmptyForm()
        case let .Registered(license): existingLicenseViewController.displayLicense(license)
        }
    }
    
    public var registrationEventHandler: HandlesRegistering? {
        
        set {
            existingLicenseViewController.eventHandler = newValue
        }
        
        get {
            return existingLicenseViewController.eventHandler
        }
    }
}
