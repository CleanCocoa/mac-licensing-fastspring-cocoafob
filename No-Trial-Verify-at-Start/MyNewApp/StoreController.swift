import Foundation

public class StoreController: NSObject {
    
    var storeDelegate: StoreDelegate?
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
        
        var storeParameters = FsprgStoreParameters()
        
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
        
        if let items = order.orderItems() as? [FsprgOrderItem],
            license = items
                .filter(orderItemIsForThisApp)
                .map(licenseFromOrderItem) // -> [License?]
                .filter(hasValue)          // keep non-nil
                .map({ $0! })              // -> [License]
                .first {
            
            storeDelegate?.didPurchaseLicense(license)
        }
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
                
            return License(name: name, key: licenseCode)
        }
        
        return nil
    }
    
    // MARK: Thank-you view
    
    public func viewWithFrame(frame: NSRect, forOrder order: FsprgOrder!) -> NSView! {
        
        return nil
    }
}
