// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct StoreInfo {
    
    public let storeId: String
    
    public let productName: String
    public let productId: String
    
    public let storeMode: String
    
    public init(storeId: String, productName: String, productId: String, storeMode: String) {
        
        self.storeId = storeId
        self.productName = productName
        self.productId = productId
        self.storeMode = storeMode
    }
}
