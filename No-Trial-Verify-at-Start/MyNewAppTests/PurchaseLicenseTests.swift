import Cocoa
import XCTest
import MyNewApp

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
        let license = License(name: name, key: licenseCode)
        
        service.store(storeDouble, didPurchaseLicense: license)
        
        let values = registerAppDouble.didRegisterWith
        XCTAssert(hasValue(values))
        
        if let values = values {
            
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }

    
    // MARK: -
    
    class TestStore: Store {
        
        var didShowStore = false
        override func showStore() {
            
            didShowStore = true
        }
    }
    
    class TestRegisterApp: RegisterApplication {
        
        var didRegisterWith: (name: String, licenseCode: String)?
        override func register(name: String, licenseCode: String) {
            didRegisterWith = (name, licenseCode)
        }
    }
}
