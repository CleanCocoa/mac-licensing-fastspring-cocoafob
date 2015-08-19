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
    
    public var registrationEventHandler: HandlesRegistering? {
        
        set {
            existingLicenseViewController.eventHandler = newValue
        }
        
        get {
            return existingLicenseViewController.eventHandler
        }
    }
}
