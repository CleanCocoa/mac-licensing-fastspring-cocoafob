// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

func button(_ button: NSButton, isWiredTo target: AnyObject?) -> Bool {
    
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

    func testOrderView_IsConnected() {
        
        XCTAssert(hasValue(controller.orderConfirmationView))
    }
    
    func testOrderViewsLicenseCodeTextField_IsConnected() {
        
        XCTAssert(hasValue(controller.orderConfirmationView?.licenseCodeTextField))
    }
    
    func testBackButton_IsConnected() {
        
        XCTAssert(hasValue(controller.backButton))
    }
    
    func testBackButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.backButton.action, #selector(WKWebView.goBack(_:)))
        XCTAssert(button(controller.backButton, isWiredTo: controller.webView))
    }
    
    func testForwardButton_IsConnected() {
        
        XCTAssert(hasValue(controller.forwardButton))
    }
    
    func testForwardButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.forwardButton.action, #selector(WKWebView.goForward(_:)))
        XCTAssert(button(controller.forwardButton, isWiredTo: controller.webView))
    }
    
    func testReloadButton_IsConnected() {
        
        XCTAssert(hasValue(controller.reloadButton))
    }
    
    func testReloadButton_IsWiredToAction() {
        
        XCTAssertEqual(controller.reloadButton.action, #selector(StoreWindowController.reloadStore(_:)))
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
        override func set(webView: WebView) {
            
            didSetWebViewTo = webView
        }
    }
}
