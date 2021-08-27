//
//  TintOverlay.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 09/09/2020.
//

import SwiftUI

struct TintOverlay: View {
  var body: some View {
    ZStack {
      Text(" ")
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .background(LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .topLeading, endPoint: .bottomTrailing)/// blur the image
                  //  .background(VisualEffectBlur(blurStyle: .extraLight))
                    )
  }
}
