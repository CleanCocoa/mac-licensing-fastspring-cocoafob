// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryLicenseParser {

    public init() { }

    public func parse(query: String) -> (name: String, licenseCode: String)? {

        let queryDictionary = dictionary(fromQuery: query)

        guard let encodedName = queryDictionary[.licensee],
            let name = String(base64EncodedString: encodedName),
            let licenseCode = queryDictionary[.licenseCode]
            else { return nil }

        return (name, licenseCode)
    }

    fileprivate func dictionary(fromQuery query: String) -> [URLSchemeComponent : String] {

        let parameters = query.components(separatedBy: "&")

        return parameters.mapDictionary() { param -> (URLSchemeComponent, String)? in

            guard let queryKey = self.queryKey(fromParameter: param),
                let queryValue = self.queryValue(fromParameter: param)
                else { return nil }

            return (queryKey, queryValue)
        }
    }

    fileprivate func queryKey(fromParameter parameter: String) -> URLSchemeComponent? {

        // Of the `key=value` parameter string, take the `key` only
        return parameter
            .components(separatedBy: "=")
            .first
            .map(URLSchemeComponent.init(rawValue:))
    }

    fileprivate func queryValue(fromParameter parameter: String) -> String? {

        return unescape(queryValue: escapedQueryValue(fromParameter: parameter))
    }

    fileprivate func unescape(queryValue: String) -> String? {

        return queryValue
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }

    fileprivate func escapedQueryValue(fromParameter parameter: String) -> String {

        // Queries are of the form `key=value`, and we want to drop the `key=` part.
        // But base64-encoded Strings often end with `=`, so we also want to
        // keep all the other equals signs by joining things back.
        return parameter.components(separatedBy: "=")
            .dropFirst()
            .joined(separator: "=")
    }
}

extension String {
    fileprivate init?(base64EncodedString string: String) {
        guard let decodedData = Data(base64Encoded: string, options: [])
            else { return nil }

        self.init(data: decodedData, encoding: .utf8)
    }
}
