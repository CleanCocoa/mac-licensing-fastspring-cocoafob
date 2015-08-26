// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public class StoreInfoReader {
    
    static func defaultStoreInfo() -> StoreInfo? {
        
        if let URL = NSBundle.mainBundle().URLForResource("FastSpringCredentials", withExtension: "plist") {
            
            return storeInfoFromURL(URL)
        }
        
        return .None
    }
    
    public static func storeInfoFromURL(URL: NSURL) -> StoreInfo? {
        
        if let info = NSDictionary(contentsOfURL: URL) as? [String : String] {
            
            return storeInfoFromDictionary(info)
        }
        
        return .None
    }
    
    public static func storeInfoFromDictionary(info: [String : String]) -> StoreInfo? {
        
        if let storeId = info["storeId"],
            productName = info["productName"] ,
            productId = info["productId"] {
                
            #if DEBUG
                NSLog("Test Store Mode")
                let storeMode = kFsprgModeTest
            #else
                NSLog("Active Store Mode")
                let storeMode = kFsprgModeActive
            #endif
            
            return StoreInfo(storeId: storeId, productName: productName, productId: productId, storeMode: storeMode)
        }
        
        return .None
    }
}
