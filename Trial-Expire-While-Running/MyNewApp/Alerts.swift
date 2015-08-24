import AppKit

class Alerts {
    
    static func thankYouAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .InformationalAlertStyle
        alert.messageText = "Thank You for Purchasing!"
        alert.addButtonWithTitle("Continue")
        
        return alert
    }
    
    static func invalidLicenseCodeAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .CriticalAlertStyle
        alert.messageText = "Invalid combination of name and license code."
        alert.addButtonWithTitle("Close")
        
        return alert
    }
}
