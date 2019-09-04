// Copyright (c) 2015-2019 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryLicenseParser {

    public init() { }

    public func parse(query: String) -> (name: String, licenseCode: String)? {

        let queryDictionary = dictionaryFromQuery(query)

        guard let name = decode(queryDictionary["\(URLComponents.licensee)"]),
            let licenseCode = queryDictionary["\(URLComponents.licenseCode)"]
            else { return nil }

        return (name, licenseCode)
    }

    fileprivate func dictionaryFromQuery(_ query: String) -> [String : String] {

        let parameters = query.components(separatedBy: "&")

        return parameters.mapDictionary() { param -> (String, String)? in

            if let queryKey = self.queryKeyFromParameter(param),
                let queryValue = self.queryValueFromParameter(param)
            {

                return (queryKey, queryValue)
            }

            return nil
        }
    }

    fileprivate func queryKeyFromParameter(_ parameter: String) -> String? {

        return parameter.components(separatedBy: "=")[safe:0]
    }

    fileprivate func queryValueFromParameter(_ parameter: String) -> String? {

        return escapedQueryValueFromParameter(parameter)
            >>- unescapeQueryValue
    }

    fileprivate func unescapeQueryValue(_ queryValue: String) -> String? {

        return queryValue
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }

    fileprivate func escapedQueryValueFromParameter(_ parameter: String) -> String? {

        // Assume only one `=` is the separator and concatenate
        // the rest back into the value.
        // (base64-encoded Strings often end with `=`.)
        return parameter.components(separatedBy: "=")
            .dropFirst()
            .joined(separator: "=")
    }

    fileprivate func decode(_ string: String?) -> String? {

        guard let string = string,
            let decodedData = Data(base64Encoded: string, options: [])
            else { return nil }

        return String(data: decodedData, encoding: .utf8)
    }

}
