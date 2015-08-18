import Foundation

public protocol StoreDelegate {
    
    func store(store: Store, didPurchaseLicense license: License)
}

public class Store: NSObject {
    
    public var storeDelegate: StoreDelegate?
    
    public func showStore() {
        
    }
}

extension Store: FsprgEmbeddedStoreDelegate {
    
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
            
            storeDelegate?.store(self, didPurchaseLicense: license)
        }
    }
    
    private func orderItemIsForThisApp(orderItem: FsprgOrderItem) -> Bool {
        
        let appName = "New App"
        
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
