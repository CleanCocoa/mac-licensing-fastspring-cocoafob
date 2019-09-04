// Copyright (c) 2015-2019 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class StoreInfoReader {
    
    static func defaultStoreInfo() -> StoreInfo? {
        
        if let URL = Bundle.main.url(forResource: "FastSpringCredentials", withExtension: "plist") {
            
            return storeInfo(fromURL: URL)
        }
        
        return .none
    }
    
    public static func storeInfo(fromURL url: URL) -> StoreInfo? {
        
        if let info = NSDictionary(contentsOf: url) as? [String : String] {
            
            return storeInfo(fromDictionary: info)
        }
        
        return .none
    }
    
    public static func storeInfo(fromDictionary info: [String : String]) -> StoreInfo? {
        
        if let storeId = info["storeId"],
            let productName = info["productName"] ,
            let productId = info["productId"] {
                
            #if DEBUG
                NSLog("Test Store Mode")
                let storeMode = kFsprgModeTest
            #else
                NSLog("Active Store Mode")
                let storeMode = kFsprgModeActive
            #endif
            
            return StoreInfo(storeId: storeId, productName: productName, productId: productId, storeMode: storeMode)
        }
        
        return .none
    }
}
