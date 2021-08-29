//
//  Overlays.swift
//  Overlays
//
//  Created by Jordain on 29/08/2021.
//

import Foundation
import SwiftUI

struct buttomPlusOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .renderingMode(.original)
                    .foregroundColor(Color(#colorLiteral(red: 0.4039215686, green: 0.9450980392, blue: 0.3529411765, alpha: 1)))
                    .font(.title)
                
                
            }
        }
        .padding(.trailing,-10)
        .padding(.bottom,-10)
    }
}

struct editPlusOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "pencil.circle.fill")
                    .renderingMode(.original)
                    .foregroundColor(Color(#colorLiteral(red: 0.4039215686, green: 0.9450980392, blue: 0.3529411765, alpha: 1)))
                    .font(.title)
                
                
            }
        }
        .padding(.trailing,-10)
        .padding(.bottom,-10)
    }
}


