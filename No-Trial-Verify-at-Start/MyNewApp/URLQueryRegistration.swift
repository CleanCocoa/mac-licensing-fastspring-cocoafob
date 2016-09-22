// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

open class URLQueryRegistration {
    
    let registrationHandler: HandlesRegistering
    
    public init(registrationHandler: HandlesRegistering) {
        
        self.registrationHandler = registrationHandler
    }
    
    open lazy var queryParser: URLQueryLicenseParser = URLQueryLicenseParser()
    
    open func registerFromURL(_ url: URL) {
        
        guard let query = queryFromURL(url), let license = queryParser.parseQuery(query) else {
            return
        }
        
        registrationHandler.register(license.name, licenseCode: license.licenseCode)
    }
    
    func queryFromURL(_ url: URL) -> String? {
        
        if let host = url.host, let query = url.query , host == URLComponents.host {
            
            return query
        }
        
        return .none
    }
}
