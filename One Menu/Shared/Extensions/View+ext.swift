//
//  View+ext.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 28/08/2020.
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



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    /*  How to activate: SomeView().cardStyle() * */
     func cardStyle(color: Color, cornerRadius: CGFloat) -> some View {
         return self
             .background(color)
             .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
             .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
     }
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
     
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}
