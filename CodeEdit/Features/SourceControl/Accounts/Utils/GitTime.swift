//
//  GitTime.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

// TODO: DOCS (Nanashi Li)
enum GitTime {

    /**
     A date formatter for RFC 3339 style timestamps.
     Uses POSIX locale and GMT timezone so that date values are parsed as absolutes.
     - (https://tools.ietf.org/html/rfc3339)
     - (https://developer.apple.com/library/mac/qa/qa1480/_index.html)
     */
    static var rfc3339DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = String(localized: "date.format.iso8601", defaultValue: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'", comment: "ISO 8601 date format string - technical constant, should not be localized")
        formatter.locale = Locale(identifier: String(localized: "locale.posix", defaultValue: "en_US_POSIX", comment: "POSIX locale identifier - technical constant, should not be localized"))
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /**
     Parses RFC 3339 date strings into NSDate
     - parameter string: The string representation of the date
     - returns: An `NSDate` with a successful parse, otherwise `nil`
     */
    static func rfc3339Date(_ string: String?) -> Date? {
        guard let string else { return nil }
        return GitTime.rfc3339DateFormatter.date(from: string)
    }
}
