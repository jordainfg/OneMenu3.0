//
//  CustomModifiers.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 02/11/2020.
//

import Foundation
import SwiftUI

struct HeaderForSection: View {
    let text: String
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.subheadline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .foregroundColor(.secondary)
            .padding(.top, 15)
            .padding(.bottom, 7)
    }
}
