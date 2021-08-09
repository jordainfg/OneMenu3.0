//
//  HidekeyBoard.swift
//  Paradise Scrap
//
//  Created by Jordain Gijsbertha on 26/11/2020.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
