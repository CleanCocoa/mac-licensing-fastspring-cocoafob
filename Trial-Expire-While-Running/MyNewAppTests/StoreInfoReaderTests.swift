// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class StoreInfoReaderTests: XCTestCase {

//    enum StoreInfoURLs: String {
//        case MissingStoreId = "TestCredentialsMissingStoreId"
//        case MissingProductId = "TestCredentialsMissingProductId"
//        case MissingProductName = "TestCredentialsMissingProductName"
//        case Complete = "TestCredentialsComplete"
//        
//        var URL: NSURL {
//            return NSBundle(forClass: StoreInfoReaderTests.self).URLForResource(rawValue, withExtension: "plist")!
//        }
//    }
    
    let validURL = Bundle(for: StoreInfoReaderTests.self).url(forResource: "TestCredentialsComplete", withExtension: "plist")!
    

    func testReadingValidData_ReturnsStoreInfoWithData() {
        
        let result = StoreInfoReader.storeInfo(fromURL: validURL)
        
        XCTAssertNotNil(result)
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
        
        let result = StoreInfoReader.storeInfo(fromDictionary: data)
        
        XCTAssertNotNil(result)
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
        
        let result = StoreInfoReader.storeInfo(fromDictionary: data)
        
        XCTAssertNotNil(result)
    }
    
    func testInfoFromDict_MissingStoreId_ReturnsNil() {
        
        let incompleteData = [
            "productId" : "coolproduct",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfo(fromDictionary: incompleteData)
        
        XCTAssertNil(result)
    }
    
    func testInfoFromDict_MissingProductId_ReturnsNil() {
        
        let incompleteData = [
            "storeId" : "The Store ID",
            "productName" : "My Cool Product"
        ]
        
        let result = StoreInfoReader.storeInfo(fromDictionary: incompleteData)
        
        XCTAssertNil(result)
    }
    
    func testInfoFromDict_MissingProductName_ReturnsNil() {
        
        let incompleteData = [
            "storeId" : "The Store ID",
            "productId" : "coolproduct",
        ]
        
        let result = StoreInfoReader.storeInfo(fromDictionary: incompleteData)
        
        XCTAssertNil(result)
    }
}
