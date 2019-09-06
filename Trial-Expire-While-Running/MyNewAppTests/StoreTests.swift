// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class StoreTests: XCTestCase {

    var store: Store!
    
    let storeWCDouble = TestStoreWindowController()
    let storeInfo = StoreInfo(storeId: "an id", productName: "a product name",productId: "a product id", storeMode: "a mode")
    let delegateDouble = TestDelegate()
    
    override func setUp() {
        
        super.setUp()
        
        store = Store(storeInfo: storeInfo, storeWindowController: storeWCDouble)
        store.storeDelegate = delegateDouble
    }
    
    func testShowingStore_ShowsWindow() {
        
        store.showStore()
        
        XCTAssert(storeWCDouble.didShowWindow)
    }
    
    func testShowingStore_TransfersDelegate() {
        
        store.showStore()
        
        XCTAssert(storeWCDouble.didSetStoreDelegateTo === delegateDouble)
    }

    func testShowingStore_TransfersController() {
        
        store.showStore()
        
        XCTAssert(storeWCDouble.didSetStoreControllerTo === store.storeController)
    }
    
    func testClosingStore_ClosesWindow() {
        
        store.closeStore()
        
        XCTAssert(storeWCDouble.didCloseWindow)
    }
    
    
    // MARK: - 
    
    class TestStoreWindowController: StoreWindowController {
        
        convenience init() {
            
            self.init(window: nil)
        }
        
        var didShowWindow = false
        override func showWindow(_ sender: Any?) {
            
            didShowWindow = true
        }
        
        var didCloseWindow = false
        override func close() {
            
            didCloseWindow = true
        }
        
        var didSetStoreDelegateTo: StoreDelegate?
        override var storeDelegate: StoreDelegate? {
            get { return nil }
            set { didSetStoreDelegateTo = newValue }
        }
        
        var didSetStoreControllerTo: StoreController?
        override var storeController: StoreController! {
            get { return nil }
            set { didSetStoreControllerTo = newValue }
        }
    }
    
    class TestDelegate: StoreDelegate {
        
        func didPurchaseLicense(license: License) {
            // no-op
        }
    }
    
}
