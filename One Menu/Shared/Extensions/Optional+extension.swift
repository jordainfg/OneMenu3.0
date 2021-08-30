//
//  Optional+extension.swift
//  Optional+extension
//
//  Created by Jordain on 30/08/2021.
//

import Foundation
import SwiftUI
extension Optional where Wrapped == String {
    // * we added "where Wrapped == String" here because we only want to provide this functionality to string. If you want to provide this functionality to other types you can by adding an extension for that specific type. Because you need to return the correcct value.
    var orEmpty : String {
        switch self {
        case .some(let value):
            return value
        default:
            return ""
        }
    }
    // even more clean
    var emptyStr: String { return self ?? ""  }
}
