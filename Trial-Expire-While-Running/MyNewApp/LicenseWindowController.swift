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
    
    var trialLabelText: String!
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
    
        // So we don't have to worry about localized strings in here,
        // store the label text from the Nib.
        trialLabelText = trialDaysLeftTextField.stringValue
    }
    
    @IBOutlet public var existingLicenseViewController: ExistingLicenseViewController!
    @IBOutlet public var buyButton: NSButton!
    @IBOutlet public var trialDaysLeftTextField: NSTextField!
    @IBOutlet public var trialUpTextField: NSTextField!
    
    public var purchasingEventHandler: HandlesPurchases?
    
    @IBAction public func buy(sender: AnyObject) {
        
        purchasingEventHandler?.purchase()
    }
    
    public func licenseChanged(licenseInformation: LicenseInformation) {
        
        // TODO subscribe to events
        
        switch licenseInformation {
        case .Registered(_): buyButton.enabled = false
        default: buyButton.enabled = true
        }
    }
    
    public func displayTrialDaysLeft(daysLeft: Int) {
        
        trialDaysLeftTextField.hidden = false
        trialUpTextField.hidden = true
        
        trialDaysLeftTextField.stringValue = "\(daysLeft) \(trialLabelText)"
    }
    
    public func displayTrialUp() {
        
        trialDaysLeftTextField.hidden = true
        trialUpTextField.hidden = false
    }
    
    public func displayLicenseInformation(licenseInformation: LicenseInformation) {
        
        switch licenseInformation {
        case let .Registered(license): existingLicenseViewController.displayLicense(license)
        default: existingLicenseViewController.displayEmptyForm()
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
