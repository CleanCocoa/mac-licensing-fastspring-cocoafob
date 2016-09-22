// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryRegistration {
    
    let registrationHandler: HandlesRegistering
    
    public init(registrationHandler: HandlesRegistering) {
        
        self.registrationHandler = registrationHandler
    }
    
    public lazy var queryParser: URLQueryLicenseParser = URLQueryLicenseParser()
    
    public func register(fromUrl url: URL) {
        
        guard let query = query(url: url),
            let license = queryParser.parse(query: query) else {
            return
        }
        
        registrationHandler.register(name: license.name, licenseCode: license.licenseCode)
    }
    
    fileprivate func query(url: URL) -> String? {
        
        if let host = url.host, let query = url.query , host == URLComponents.host {
            
            return query
        }
        
        return .none
    }
}
