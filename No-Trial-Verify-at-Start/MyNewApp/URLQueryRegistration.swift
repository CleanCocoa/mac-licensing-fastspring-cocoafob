// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryRegistration {
    
    public enum URLComponents: String, Printable {
        
        case Host = "activate"
        case Licensee = "name"
        case LicenseCode = "licenseCode"
        
        public var description: String { return rawValue }
    }
    
    let registrationHandler: HandlesRegistering
    
    public init(registrationHandler: HandlesRegistering) {
        
        self.registrationHandler = registrationHandler
    }
    
    public func registerFromURL(url: NSURL) {
        
        if let host = url.host, query = url.query where host == URLComponents.Host {
            
            let licenseInfo = licenseInfoFromQuery(query)
            
            if let name = licenseInfo["\(URLComponents.Licensee)"],
                licenseCode = licenseInfo["\(URLComponents.LicenseCode)"] {
                
                registrationHandler.register(name, licenseCode: licenseCode)
            }
        }
    }
    
    func licenseInfoFromQuery(query: String) -> [String : String] {
        
        let parameters = query.componentsSeparatedByString("&")
        
        return parameters.mapDictionary() { param -> (String, String)? in
            
            let parameterComponents = param.componentsSeparatedByString("=")
            
            if let queryKey = parameterComponents[safe: 0],
                queryValue = parameterComponents[safe: 1]?
                    .stringByReplacingOccurrencesOfString("+", withString: " ")
                    .stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                        
                return (queryKey, queryValue)
            }
            
            return .None
        }
    }
}

func ==(lhs: String, rhs: URLQueryRegistration.URLComponents) -> Bool {
    
    return lhs == rhs.rawValue
}
