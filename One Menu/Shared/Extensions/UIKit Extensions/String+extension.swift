//
//  String+extension.swift
//  VisitorsApp
//
//  Created by Jordain Gijsbertha on 5/14/19.
//  Copyright © 2019 Jordain  Gijsbertha. All rights reserved.
//

import Foundation

public extension String {
    enum DateFormatType: String {
        /// Time
        case time = "HH:mm"

        /// Date with hours
        case ISO8601Date = "yyyy-MM-dd'T'HH:mm:ss.SSZ"

        /// Date with hours
        case dateWithTime = "dd-MMM-yyyy  H:mm"

        /// Date
        case date = "dd-MMM-yyyy"
    }

    // MARK: - Localization

    var localized: String {
        var currentLanguage = "en"
        currentLanguage = UserDefaults.standard.string(forKey: "language") ?? "nl"

        var languageCode = "en"
        if currentLanguage.contains("nl") {
            languageCode = "nl"
        }

        let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }

    func localizedPlural(_ number: Int) -> String {
        if number == 1 {
            let currentLanguage = "nl"

            var languageCode = "en"
            if currentLanguage.contains("nl") {
                languageCode = "nl"
            }

            let path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
            let bundle = Bundle(path: path!)

            return NSLocalizedString(appending("_one"), tableName: nil, bundle: bundle!, value: "", comment: "")
        } else {
            return localized
        }
    }

    func toTime(withFormat format: String = "hh:mm") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }

    func toDate(dateformat formatType: DateFormatType) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }

    func toISO8601Date() -> Date? {
        let date = replacingOccurrences(of: "Z", with: "+0000")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"

        return dateFormatter.date(from: date) ?? ISO8601DateFormatter().date(from: self)
    }
}
