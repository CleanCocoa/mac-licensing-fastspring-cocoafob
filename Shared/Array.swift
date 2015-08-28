import Foundation

extension Array {
    
    /// Transforms each element in the array into a Key-Value tuple.
    ///
    /// :return: New Dictionary of transformed elements.
    func mapDictionary<K, V>(transform: T -> (K, V)) -> [K : V] {
        
        var result = [K : V]()
        
        for element in self {
            let (key, value) = transform(element)
            result[key] = value
        }
        
        return result
    }
    
    func mapDictionary<K, V>(transform: T -> (K, V)?) -> [K : V] {
        
        var result = [K : V]()
        
        for element in self {
            if let (key, value) = transform(element) {
                result[key] = value
            }
        }
        
        return result
    }

    subscript(safe index: Int) -> Element? {
        
        return 0..<count ~= index ? self[index] : nil
    }
}
