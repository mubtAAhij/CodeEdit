//
//  String+QueryParameters.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

extension String {
    var bitbucketQueryParameters: [String: String] {
        let parametersArray = components(separatedBy: String(localized: "url.query.separator", defaultValue: "&", comment: "URL query parameter separator - technical constant, should not be localized"))
        var parameters = [String: String]()
        parametersArray.forEach { parameter in
            let keyValueArray = parameter.components(separatedBy: String(localized: "url.query.equals", defaultValue: "=", comment: "URL query parameter equals sign - technical constant, should not be localized"))
            let (key, value) = (keyValueArray.first, keyValueArray.last)
            if let key = key?.removingPercentEncoding, let value = value?.removingPercentEncoding {
                parameters[key] = value
            }
        }
        return parameters
    }
}
