// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

public protocol HandlesPurchases {
    
    func purchase()
}

public class LicenseWindowController: NSWindowController {
    
    static let nibName = "LicenseWindowController"
    
    public convenience init() {
        
        self.init(windowNibName: LicenseWindowController.nibName)
    }
    
    @IBOutlet public var existingLicenseViewController: ExistingLicenseViewController!
    @IBOutlet public var buyButton: NSButton!
    
    public var purchasingEventHandler: HandlesPurchases?
    
    @IBAction public func buy(_ sender: AnyObject) {
        
        purchasingEventHandler?.purchase()
    }
        
    public func display(licensing: Licensing) {
        
        switch licensing {
        case .unregistered:
            existingLicenseViewController.displayEmptyForm()
        case .registered(let license):
            existingLicenseViewController.displayLicense(license)
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
