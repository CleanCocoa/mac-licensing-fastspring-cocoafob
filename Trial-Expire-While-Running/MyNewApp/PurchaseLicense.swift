import Foundation

public class PurchaseLicense {
    
    let store: Store
    let registerApplication: RegisterApplication
    
    public init(store: Store, registerApplication: RegisterApplication) {
        
        self.store = store
        self.registerApplication = registerApplication
    }
}

extension PurchaseLicense: HandlesPurchases {
    
    public func purchase() {
        
        store.showStore()
    }
}

extension PurchaseLicense: StoreDelegate {
    
    public func didPurchaseLicense(license: License) {
        
        registerApplication.register(license.name, licenseCode: license.licenseCode)
    }
}
