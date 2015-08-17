import Cocoa

public class LicenseWindowController: NSWindowController {
    
    static let nibName = "LicenseWindowController"
    
    public convenience init() {
        
        self.init(windowNibName: LicenseWindowController.nibName)
    }
    
    @IBOutlet public var existingLicenseViewController: ExistingLicenseViewController!
    @IBOutlet public var buyButton: NSButton!
    
    @IBAction public func buy(sender: AnyObject) {
        
    }
    
    public func licenseChanged(licenseInformation: LicenseInformation) {
        
        switch licenseInformation {
        case .Unregistered: buyButton.enabled = true
        case .Registered(_): buyButton.enabled = false
        }
    }
}
