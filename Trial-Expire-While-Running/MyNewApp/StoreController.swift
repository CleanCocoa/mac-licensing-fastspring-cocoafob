// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class StoreController: NSObject {
    
    var storeDelegate: StoreDelegate?
    var orderConfirmationView: OrderConfirmationView?
    
    let storeController: FsprgEmbeddedStoreController
    let storeInfo: StoreInfo
    
    public init(storeInfo: StoreInfo) {
        
        self.storeController = FsprgEmbeddedStoreController()
        self.storeInfo = storeInfo
        
        super.init()
        
        storeController.setDelegate(self)
    }
    
    public func loadStore() {
        
        storeController.loadWithParameters(storeParameters)
    }
    
    var storeParameters: FsprgStoreParameters {
        
        let storeParameters = FsprgStoreParameters()
        
        // Set up store to display the correct product
        storeParameters.setOrderProcessType(kFsprgOrderProcessDetail)
        storeParameters.setStoreId(self.storeInfo.storeId,
            withProductId: self.storeInfo.productId)
        storeParameters.setMode(self.storeInfo.storeMode)
        
        // Pre-populate form fields with personal contact details
        let me = Me()
        
        storeParameters.setContactFname(me.firstName)
        storeParameters.setContactLname(me.lastName)
        storeParameters.setContactCompany(me.organization)
        
        storeParameters.setContactEmail(me.primaryEmail)
        storeParameters.setContactPhone(me.primaryPhone)
        
        return storeParameters
    }
    
    
    // MARK: Forwarding to FsprgEmbeddedStoreController
    
    public func setWebView(webView: WebView) {
        
        storeController.setWebView(webView)
    }
}

extension StoreController: FsprgEmbeddedStoreDelegate {
    
    public func webView(sender: WebView!, didFailProvisionalLoadWithError error: NSError!, forFrame frame: WebFrame!) {
    }
    
    public func webView(sender: WebView!, didFailLoadWithError error: NSError!, forFrame frame: WebFrame!) {
    }
    
    public func didLoadStore(url: NSURL!) {
    }
    
    public func didLoadPage(url: NSURL!, ofType pageType: FsprgPageType) {
    }
    
    // MARK: Order receiced
    
    public func didReceiveOrder(order: FsprgOrder!) {
        
        // Thanks Obj-C bridging without nullability annotations:
        // implicit unwrapped optionals are not safe
        if !hasValue(order) {
            return
        }
        
        if let license = licenseFromOrder(order) {
            storeDelegate?.didPurchaseLicense(license)
        }
    }
    
    private func licenseFromOrder(order: FsprgOrder) -> License? {
        
        if let items = order.orderItems() as? [FsprgOrderItem],
            license = items
                .filter(orderItemIsForThisApp)
                .map(licenseFromOrderItem) // -> [License?]
                .filter(hasValue)          // keep non-nil
                .map({ $0! })              // -> [License]
                .first {
            
            return license
        }
        
        return nil
    }
    
    private func orderItemIsForThisApp(orderItem: FsprgOrderItem) -> Bool {
        
        let appName = storeInfo.productName
        
        if let productName = orderItem.productName() {
            return productName.hasPrefix(appName)
        }
        
        return false
    }
    
    private func licenseFromOrderItem(orderItem: FsprgOrderItem) -> License? {
        
        if let orderLicense = orderItem.license(),
            name = orderLicense.licenseName(),
            licenseCode = orderLicense.firstLicenseCode() {
                
            return License(name: name, licenseCode: licenseCode)
        }
        
        return nil
    }
    
    
    // MARK: Thank-you view
    
    public func viewWithFrame(frame: NSRect, forOrder order: FsprgOrder!) -> NSView! {
        
        if let orderConfirmationView = orderConfirmationView,
            license = licenseFromOrder(order) {
            
            orderConfirmationView.displayLicenseCode(license.licenseCode)
            
            return orderConfirmationView
        }
        
        return nil
    }
}
