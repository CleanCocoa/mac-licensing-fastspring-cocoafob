// Copyright (c) 2015 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryRegistration {
    
    let registrationHandler: HandlesRegistering
    
    public init(registrationHandler: HandlesRegistering) {
        
        self.registrationHandler = registrationHandler
    }
    
    public lazy var queryParser: URLQueryLicenseParser = URLQueryLicenseParser()
    
    public func registerFromURL(url: NSURL) {
        
        if let query = queryFromURL(url), license = queryParser.parseQuery(query) {
                
            registrationHandler.register(license.name, licenseCode: license.licenseCode)
        }
    }
    
    func queryFromURL(url: NSURL) -> String? {
        
        if let host = url.host, query = url.query where host == URLComponents.Host {
            
            return query
        }
        
        return .None
    }
}
