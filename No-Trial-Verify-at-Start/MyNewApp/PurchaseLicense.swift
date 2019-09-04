// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class PurchaseLicense {
    
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
    
    public func didPurchaseLicense(_ license: License) {
        
        registerApplication.register(license.name, licenseCode: license.licenseCode)
    }
}
