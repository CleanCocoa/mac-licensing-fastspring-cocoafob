// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class StoreController: NSObject {
    
    var storeDelegate: StoreDelegate?
    var orderConfirmationView: OrderConfirmationView?

    // Expose to @objc for Key--Value-Coding
    @objc let storeController: FsprgEmbeddedStoreController
    let storeInfo: StoreInfo
    
    public init(storeInfo: StoreInfo) {
        
        self.storeController = FsprgEmbeddedStoreController()
        self.storeInfo = storeInfo
        
        super.init()
        
        storeController.setDelegate(self)
    }
    
    open func loadStore() {
        
        storeController.load(with: storeParameters)
    }
    
    var storeParameters: FsprgStoreParameters {
        
        let storeParameters = FsprgStoreParameters()
        
        // Set up store to display the correct product
        storeParameters?.setOrderProcessType(kFsprgOrderProcessDetail)
        storeParameters?.setStoreId(self.storeInfo.storeId,
            withProductId: self.storeInfo.productId)
        storeParameters?.setMode(self.storeInfo.storeMode)
        
        // Pre-populate form fields with personal contact details
        let me = Me()
        
        storeParameters?.setContactFname(me.firstName)
        storeParameters?.setContactLname(me.lastName)
        storeParameters?.setContactCompany(me.organization)
        
        storeParameters?.setContactEmail(me.primaryEmail)
        storeParameters?.setContactPhone(me.primaryPhone)
        
        return storeParameters!
    }
    
    
    // MARK: Forwarding to FsprgEmbeddedStoreController
    
    open func setWebView(_ webView: WebView) {
        
        storeController.setWebView(webView)
    }
}

extension StoreController: FsprgEmbeddedStoreDelegate {
    
    public func webView(_ sender: WebView!, didFailProvisionalLoadWithError error: Error!, for frame: WebFrame!) {
    }
    
    public func webView(_ sender: WebView!, didFailLoadWithError error: Error!, for frame: WebFrame!) {
    }
    
    public func didLoadStore(_ url: URL!) {
    }
    
    public func didLoadPage(_ url: URL!, of pageType: FsprgPageType) {
    }
    
    // MARK: Order receiced
    
    public func didReceive(_ order: FsprgOrder!) {
        
        // Thanks Obj-C bridging without nullability annotations:
        // implicit unwrapped optionals are not safe
        if !hasValue(order) {
            return
        }
        
        guard let license = licenseFromOrder(order) else {
            return
        }
        
        storeDelegate?.didPurchaseLicense(license)
    }
    
    fileprivate func licenseFromOrder(_ order: FsprgOrder) -> License? {
        
        guard  let items = order.orderItems() as? [FsprgOrderItem],
            let license = items
                .filter(orderItemIsForThisApp)
                .map(licenseFromOrderItem) // -> [License?]
                .filter(hasValue)          // keep non-nil
                .map({ $0! })              // -> [License]
                .first else {
            
            return nil
        }
        
        return license
    }
    
    fileprivate func orderItemIsForThisApp(_ orderItem: FsprgOrderItem) -> Bool {
        
        let appName = storeInfo.productName
        
        guard let productName = orderItem.productName() else {
            return false
        }
        
        return productName.hasPrefix(appName)
    }
    
    fileprivate func licenseFromOrderItem(_ orderItem: FsprgOrderItem) -> License? {
        
        guard let orderLicense = orderItem.license(),
            let name = orderLicense.licenseName(),
            let licenseCode = orderLicense.firstLicenseCode() else {
            
            return nil
        }
        
        return License(name: name, licenseCode: licenseCode)
    }
    
    
    // MARK: Thank-you view
    
    public func view(withFrame frame: NSRect, for order: FsprgOrder!) -> NSView! {
        
        guard  let orderConfirmationView = orderConfirmationView,
            let license = licenseFromOrder(order) else {
            
            return nil
        }
        
        orderConfirmationView.displayLicenseCode(license.licenseCode)
        
        return orderConfirmationView
    }
}
