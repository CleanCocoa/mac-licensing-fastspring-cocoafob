import Foundation

public struct StoreInfo {
    
    let storeId: String
    
    let productName: String
    let productId: String
    
    let storeMode: String
    
    public init(storeId: String, productName: String, productId: String, storeMode: String) {
        
        self.storeId = storeId
        self.productName = productName
        self.productId = productId
        self.storeMode = storeMode
    }
}
