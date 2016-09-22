// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa

open class OrderConfirmationView: NSView {
    
    @IBOutlet open var licenseCodeTextField: NSTextField!
    
    open func displayLicenseCode(_ licenseCode: String) {
        
        licenseCodeTextField.stringValue = licenseCode
    }
}

open class StoreWindowController: NSWindowController {

    static let NibName = "StoreWindowController"
    
    public convenience init() {
        
        self.init(windowNibName: StoreWindowController.NibName)
    }
    
    @IBOutlet open var webView: WebView!
    @IBOutlet open var orderConfirmationView: OrderConfirmationView!
    
    @IBOutlet open var backButton: NSButton!
    @IBOutlet open var forwardButton: NSButton!
    @IBOutlet open var reloadButton: NSButton!
    
    open var storeController: StoreController!
    
    open var storeDelegate: StoreDelegate? {
        get {
            return storeController.storeDelegate
        }
        
        set {
            storeController.storeDelegate = newValue
        }
    }
    
    open override func awakeFromNib() {
        
        storeController.setWebView(webView)
        storeController.loadStore()
        storeController.orderConfirmationView = orderConfirmationView
    }
    
    @IBAction open func reloadStore(_ sender: AnyObject) {
        
        storeController.loadStore()
    }
}
