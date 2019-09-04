// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryRegistration {
    
    let registrationHandler: HandlesRegistering
    
    public init(registrationHandler: HandlesRegistering) {
        
        self.registrationHandler = registrationHandler
    }
    
    public lazy var queryParser: URLQueryLicenseParser = URLQueryLicenseParser()
    
    public func registerFromURL(_ url: URL) {
        
        guard let query = queryFromURL(url), let license = queryParser.parseQuery(query) else {
            return
        }
        
        registrationHandler.register(name: license.name, licenseCode: license.licenseCode)
    }
    
    func queryFromURL(_ url: URL) -> String? {
        
        if let host = url.host, let query = url.query , host == URLComponents.host {
            
            return query
        }
        
        return .none
    }
}
