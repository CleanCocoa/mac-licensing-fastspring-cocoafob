import Cocoa
import XCTest
import MyNewApp

func button(button: NSButton, isWiredTo target: AnyObject?) -> Bool {
    
    if !hasValue(target) { return false }
    if !hasValue(button.target) { return false }
    
    return button.target === target
}

class StoreWindowControllerTests: XCTestCase {

    var controller: StoreWindowController!
    
    let storeControllerDouble = TestStoreController()
    
    override func setUp() {
        
        super.setUp()
        
        controller = StoreWindowController()
        controller.storeController = storeControllerDouble
        loadWindow(controller)
    }

    func testWebView_IsConnected() {
        
        XCTAssert(hasValue(controller.webView))
    }

    func testBackButton_IsConnected() {
        
        XCTAssert(hasValue(controller.backButton))
    }
    
    func testBackButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.backButton.action, Selector("goBack:"))
        XCTAssert(button(controller.backButton, isWiredTo: controller.webView))
    }
    
    func testForwardButton_IsConnected() {
        
        XCTAssert(hasValue(controller.forwardButton))
    }
    
    func testForwardButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.forwardButton.action, Selector("goForward:"))
        XCTAssert(button(controller.forwardButton, isWiredTo: controller.webView))
    }
    
    func testReloadButton_IsConnected() {
        
        XCTAssert(hasValue(controller.reloadButton))
    }
    
    func testReloadButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.reloadButton.action, Selector("reloadStore:"))
    }
    
    func testAfterAwaking_ForwardsWebViewToStoreController() {
        
        XCTAssert(hasValue(storeControllerDouble.didSetWebViewTo))
        
        if let webView = storeControllerDouble.didSetWebViewTo {
            XCTAssert(webView === controller.webView)
        }
    }
    
    func testAfterAwaking_LoadsStore() {
        
        XCTAssert(storeControllerDouble.didLoadStore)
    }
    
    
    // MARK: Reloading
    
    func testReloading_LoadsStore() {
        
        storeControllerDouble.didLoadStore = false
        
        controller.reloadStore(self)
        
        XCTAssert(storeControllerDouble.didLoadStore)
    }
    
    
    // MARK: -
    
    class TestStoreController: StoreController {
        
        convenience init() {
            self.init(storeInfo: StoreInfo(storeId: "", productName: "", productId: "", storeMode: ""))
        }
        
        var didLoadStore = false
        override func loadStore() {
            
            didLoadStore = true
        }
        
        var didSetWebViewTo: WebView?
        override func setWebView(webView: WebView) {
            
            didSetWebViewTo = webView
        }
    }
}
