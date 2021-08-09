//
//  String+Ext.swift
//  ShelfApp
//
//  Created by Jordain Gijsbertha on 07/10/2020.
//

import Foundation
extension String {
    /// Returns `true` if this string contains the provided substring,
    /// or if the substring is empty. Otherwise, returns `false`.
    ///
    /// - Parameter substring: The substring to search for within
    ///   this string.
    func hasSubstring(_ substring: String) -> Bool {
        substring.isEmpty || contains(substring)
    }
}
