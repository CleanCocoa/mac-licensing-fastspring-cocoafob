import Cocoa

public protocol HandlesRegistering: class {
    
    func register(name: String, licenseCode: String)
}

public class ExistingLicenseViewController: NSViewController {
   
    @IBOutlet public weak var licenseeTextField: NSTextField!
    @IBOutlet public weak var licenseCodeTextField: NSTextField!
    @IBOutlet public weak var registerButton: NSButton!
    
    public var eventHandler: HandlesRegistering?
    
    @IBAction public func register(sender: AnyObject) {
        
        if let eventHandler = eventHandler {
            let name = licenseeTextField.stringValue
            let licenseCode = licenseCodeTextField.stringValue
            
            eventHandler.register(name, licenseCode: licenseCode)
        }
    }
    
    public func displayEmptyForm() {
        
        licenseeTextField.stringValue = ""
        licenseCodeTextField.stringValue = ""
    }
    
    public func displayLicense(license: License) {
        
        licenseeTextField.stringValue = license.name
        licenseCodeTextField.stringValue = license.key
    }
}
