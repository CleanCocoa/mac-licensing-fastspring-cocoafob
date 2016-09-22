// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public protocol StoreDelegate: class {
    
    func didPurchaseLicense(_ license: License)
}

open class Store {

    let storeInfo: StoreInfo
    
    open var storeDelegate: StoreDelegate?
    
    let storeWindowController: StoreWindowController
    open lazy var storeController: StoreController = StoreController(storeInfo: self.storeInfo)
    
    convenience init(storeInfo: StoreInfo) {
        
        self.init(storeInfo: storeInfo, storeWindowController: StoreWindowController())
    }
    
    public init(storeInfo: StoreInfo, storeWindowController: StoreWindowController) {
        
        self.storeWindowController = storeWindowController
        self.storeInfo = storeInfo
    }
    
    open func showStore() {
        
        storeWindowController.storeController = storeController
        storeWindowController.showWindow(self)
        storeWindowController.storeDelegate = storeDelegate
    }
    
    open func closeStore() {
        
        storeWindowController.close()
    }
}
