// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class PurchaseLicenseTests: XCTestCase {

    var service: PurchaseLicense!
    
    let storeDouble = TestStore()
    let registerAppDouble = TestRegisterApp()
    
    override func setUp() {
        
        super.setUp()
        
        service = PurchaseLicense(store: storeDouble, registerApplication: registerAppDouble)
    }
    
    func testPurchase_ShowsStore() {
        
        service.purchase()
        
        XCTAssert(storeDouble.didShowStore)
    }

    func testPurchaseCallback_DelegatesToRegisterApp() {
        
        let name = "The Name!"
        let licenseCode = "XXX-123-YYY"
        let license = License(name: name, licenseCode: licenseCode)
        
        service.didPurchaseLicense(license)
        
        let values = registerAppDouble.didRegisterWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }

    
    // MARK: -
    
    class TestStore: Store {
        
        convenience init() {
            
            self.init(storeInfo: StoreInfo(storeId: "", productName: "", productId: "", storeMode: ""), storeWindowController: StoreWindowController())
        }
        
        var didShowStore = false
        override func showStore() {
            
            didShowStore = true
        }
    }
    
    class TestRegisterApp: RegisterApplication {
        
        var didRegisterWith: (name: String, licenseCode: String)?
        override func register(_ name: String, licenseCode: String) {
            didRegisterWith = (name, licenseCode)
        }
    }
}
