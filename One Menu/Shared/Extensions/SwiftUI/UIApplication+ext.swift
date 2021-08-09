//
//  UIApplication+ext.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 07/09/2020.
//

import Foundation
import SwiftUI
extension UIApplication {
    class func isFirstLaunch() -> Bool {
    if !UserDefaults.standard.bool(forKey: "HasLaunched") {
      UserDefaults.standard.set(true, forKey: "HasLaunched")
        UserDefaults.standard.set([""], forKey: "News")
      UserDefaults.standard.synchronize()
      return true
  }
  return false
}
    
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
    
}
struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

struct ResignKeyboardOnTapGesture: ViewModifier {
    var gesture = TapGesture().onEnded{
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    func resignKeyboardOnTapGesture() -> some View {
        return modifier(ResignKeyboardOnTapGesture())
    }
}
