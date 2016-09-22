// Copyright (c) 2015-2016 Christian Tietze
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
    
    static func trialDaysLeftAlert(daysLeft: Int) -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "You have \(daysLeft) days left on trial!"
        alert.addButton(withTitle: "Continue")
        
        return alert
    }
    
    static func trialUpAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "Your trial has expired."
        alert.addButton(withTitle: "Register")
        
        return alert
    }
}
