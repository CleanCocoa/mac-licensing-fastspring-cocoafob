// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

public protocol HandlesRegistering: AnyObject {
    
    func register(name: String, licenseCode: String)
}

public class ExistingLicenseViewController: NSViewController {
   
    @IBOutlet public weak var licenseeTextField: NSTextField!
    @IBOutlet public weak var licenseCodeTextField: NSTextField!
    @IBOutlet public weak var registerButton: NSButton!
    
    public var eventHandler: HandlesRegistering?
    
    @IBAction public func register(_ sender: AnyObject) {
        
        guard let eventHandler = eventHandler else {
            return
        }
        
        let name = licenseeTextField.stringValue
        let licenseCode = licenseCodeTextField.stringValue
        
        eventHandler.register(name: name, licenseCode: licenseCode)
    }
    
    public func displayEmptyForm() {
        
        licenseeTextField.stringValue = ""
        licenseCodeTextField.stringValue = ""
    }
    
    public func display(license: License) {
        
        licenseeTextField.stringValue = license.name
        licenseCodeTextField.stringValue = license.licenseCode
    }
}
