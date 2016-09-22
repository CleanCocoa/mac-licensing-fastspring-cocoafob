// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

public protocol HandlesRegistering: class {
    
    func register(_ name: String, licenseCode: String)
}

open class ExistingLicenseViewController: NSViewController {
   
    @IBOutlet open weak var licenseeTextField: NSTextField!
    @IBOutlet open weak var licenseCodeTextField: NSTextField!
    @IBOutlet open weak var registerButton: NSButton!
    
    open var eventHandler: HandlesRegistering?
    
    @IBAction open func register(_ sender: AnyObject) {
        
        guard let eventHandler = eventHandler else {
            return
        }
        
        let name = licenseeTextField.stringValue
        let licenseCode = licenseCodeTextField.stringValue
        
        eventHandler.register(name, licenseCode: licenseCode)
    }
    
    open func displayEmptyForm() {
        
        licenseeTextField.stringValue = ""
        licenseCodeTextField.stringValue = ""
    }
    
    open func displayLicense(_ license: License) {
        
        licenseeTextField.stringValue = license.name
        licenseCodeTextField.stringValue = license.licenseCode
    }
}
