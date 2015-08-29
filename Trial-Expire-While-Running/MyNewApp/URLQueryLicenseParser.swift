// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryLicenseParser {
    
    public init() { }
    
    public func parseQuery(query: String) -> License? {
        
        let queryDictionary = dictionaryFromQuery(query)
        
        if let name = decode(queryDictionary["\(URLComponents.Licensee)"]),
            licenseCode = queryDictionary["\(URLComponents.LicenseCode)"] {
                
            return License(name: name, licenseCode: licenseCode)
        }
        
        return .None
    }
    
    func dictionaryFromQuery(query: String) -> [String : String] {
        
        let parameters = query.componentsSeparatedByString("&")
        
        return parameters.mapDictionary() { param -> (String, String)? in
            
            if let queryKey = self.queryKeyFromParameter(param),
                queryValue = self.queryValueFromParameter(param)
            {
                
                return (queryKey, queryValue)
            }
            
            return .None
        }
    }
    
    func queryKeyFromParameter(parameter: String) -> String? {
        
        return parameter.componentsSeparatedByString("=")[safe:0]
    }
    
    func queryValueFromParameter(parameter: String) -> String? {
        
        return escapedQueryValueFromParameter(parameter)
            >>= unescapeQueryValue
    }
    
    func unescapeQueryValue(queryValue: String) -> String? {
        
        return queryValue
            .stringByReplacingOccurrencesOfString("+", withString: " ")
            .stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }
    
    func escapedQueryValueFromParameter(parameter: String) -> String? {
        
        // Assume only one `=` is the separator and concatenate 
        // the rest back into the value.
        // (base64-encoded Strings often end with `=`.)
        return join("=", dropFirst(parameter.componentsSeparatedByString("=")))
    }
    
    func decode(string: String?) -> String? {
        
        if let string = string, decodedData = NSData(base64EncodedString: string, options: nil) {
            
            return NSString(data: decodedData, encoding: NSUTF8StringEncoding) as? String
        }
        
        return .None
    }
    
}
