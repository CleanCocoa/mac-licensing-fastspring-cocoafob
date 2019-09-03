// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class StoreInfoReader {
    
    static func defaultStoreInfo() -> StoreInfo? {
        
        if let URL = Bundle.main.url(forResource: "FastSpringCredentials", withExtension: "plist") {
            
            return storeInfoFromURL(URL)
        }
        
        return .none
    }
    
    public static func storeInfoFromURL(_ URL: Foundation.URL) -> StoreInfo? {
        
        if let info = NSDictionary(contentsOf: URL) as? [String : String] {
            
            return storeInfoFromDictionary(info)
        }
        
        return .none
    }
    
    public static func storeInfoFromDictionary(_ info: [String : String]) -> StoreInfo? {
        
        guard let storeId = info["storeId"],
            let productName = info["productName"] ,
            let productId = info["productId"] else {
                
            return .none
        }
        
        #if DEBUG
            NSLog("Test Store Mode")
            let storeMode = kFsprgModeTest
            #else
            NSLog("Active Store Mode")
            let storeMode = kFsprgModeActive
        #endif
        
        return StoreInfo(storeId: storeId, productName: productName, productId: productId, storeMode: storeMode)
    }
}
