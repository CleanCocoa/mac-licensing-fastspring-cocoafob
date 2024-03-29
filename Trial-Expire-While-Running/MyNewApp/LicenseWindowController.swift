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
    
    var trialLabelText: String = ""
    
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
    
    @IBAction public func buy(_ sender: AnyObject) {
        
        purchasingEventHandler?.purchase()
    }
    
    public func display(licensing: Licensing, clock: Clock = SystemClock()) {
        
        switch licensing {
        case let .trial(trialPeriod):
            let trial = Trial(trialPeriod: trialPeriod, clock: clock)
            display(trialDaysLeft: trial.daysLeft)
            existingLicenseViewController.displayEmptyForm()
            
        case .trialExpired:
            displayTrialUp()
            existingLicenseViewController.displayEmptyForm()
            
        case let .registered(license):
            displayBought()
            existingLicenseViewController.display(license: license)
        }
    }
    
    public func display(trialDaysLeft daysLeft: Int) {
        
        trialDaysLeftTextField.isHidden = false
        trialUpTextField.isHidden = true
        
        trialDaysLeftTextField.stringValue = "\(daysLeft) \(trialLabelText)"
    }
    
    public func displayTrialUp() {
        
        trialDaysLeftTextField.isHidden = true
        trialUpTextField.isHidden = false
    }
    
    public func displayBought() {
        
        trialDaysLeftTextField.isHidden = true
        trialUpTextField.isHidden = true
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
