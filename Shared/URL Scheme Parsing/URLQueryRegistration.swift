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
    
    public func register(fromURL url: URL) {
        guard let query = query(fromURL: url),
            let licenseInfo = queryParser.parse(query: query)
            else { return }
        
        registrationHandler.register(name: licenseInfo.name, licenseCode: licenseInfo.licenseCode)
    }

    private func query(fromURL url: URL) -> String? {
        guard let host = url.host,
            host == URLSchemeComponent.host.rawValue,
            let query = url.query
            else { return nil }

        return query
    }
}
