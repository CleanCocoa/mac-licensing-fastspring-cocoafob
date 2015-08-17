import Cocoa

public class ExistingLicenseViewController: NSViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet public weak var registerButton: NSButton!
    @IBOutlet public weak var licenseeTextField: NSTextField!
    @IBOutlet public weak var licenseCodeTextField: NSTextField!
    
    @IBAction public func register(sender: AnyObject) {
        
    }
}
