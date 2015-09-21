// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class StoreInfoReaderTests: XCTestCase {
    
    let validURL = NSBundle(forClass: StoreInfoReaderTests.self).URLForResource("TestCredentialsComplete", withExtension: "plist")!

    func testReadingValidData_ReturnsStoreInfoWithData() {
        
        let result = StoreInfoReader.storeInfoFromURL(validURL)
        
        XCTAssert(hasValue(result))
        
        if let result = result {
            
            XCTAssertEqual(result.storeId, "A Store ID")
            XCTAssertEqual(result.productName, "A Product Name")
            XCTAssertEqual(result.productId, "A Product ID")
        }
    }
    
    func testInfoFromDict_CompleteData_ReturnsStoreInfo() {
        
        let data = [
            "storeId" : "The Store ID",
            "productId" : "coolproduct",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfoFromDictionary(data)
        
        XCTAssert(hasValue(result))
        
        if let result = result {
            
            XCTAssertEqual(result.storeId, data["storeId"]!)
            XCTAssertEqual(result.productName, data["productName"]!)
            XCTAssertEqual(result.productId, data["productId"]!)
        }
    }

    func testInfoFromDict_MoreContentThanCompleteData_ReturnsStoreInfo() {
        
        let data = [
            "superfluous" : "this is not read",
            "storeId" : "The Store ID",
            "productId" : "coolproduct",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfoFromDictionary(data)
        
        XCTAssert(hasValue(result))
    }
    
    func testInfoFromDict_MissingStoreId_ReturnsNil() {
        
        let incompleteData = [
            "productId" : "coolproduct",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfoFromDictionary(incompleteData)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testInfoFromDict_MissingProductId_ReturnsNil() {
        
        let incompleteData = [
            "storeId" : "The Store ID",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfoFromDictionary(incompleteData)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testInfoFromDict_MissingProductName_ReturnsNil() {
        
        let incompleteData = [
            "storeId" : "The Store ID",
            "productId" : "coolproduct",
        ]
        
        let result = StoreInfoReader.storeInfoFromDictionary(incompleteData)
        
        XCTAssertFalse(hasValue(result))
    }
}
