// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public protocol StoreDelegate: class {
    
    func didPurchaseLicense(license: License)
}

public class Store {

    let storeInfo: StoreInfo
    
    public var storeDelegate: StoreDelegate?
    
    let storeWindowController: StoreWindowController
    public lazy var storeController: StoreController = StoreController(storeInfo: self.storeInfo)
    
    convenience init(storeInfo: StoreInfo) {
        
        self.init(storeInfo: storeInfo, storeWindowController: StoreWindowController())
    }
    
    public init(storeInfo: StoreInfo, storeWindowController: StoreWindowController) {
        
        self.storeWindowController = storeWindowController
        self.storeInfo = storeInfo
    }
    
    public func showStore() {
        
        storeWindowController.storeController = storeController
        storeWindowController.showWindow(self)
        storeWindowController.storeDelegate = storeDelegate
    }
    
    public func closeStore() {
        
        storeWindowController.close()
    }
}
