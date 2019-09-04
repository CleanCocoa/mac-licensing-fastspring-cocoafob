// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import AppKit

class Alerts {
    
    static func thankYouAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Thank You for Purchasing!"
        alert.addButton(withTitle: "Continue")
        
        return alert
    }
    
    static func invalidLicenseCodeAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "Invalid combination of name and license code."
        alert.addButton(withTitle: "Close")
        
        return alert
    }
}
