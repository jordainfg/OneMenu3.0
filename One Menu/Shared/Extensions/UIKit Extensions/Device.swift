//
//  Device.swift
//  One Menu
//
//  Created by Jordain Gijsbertha on 26/08/2020.
//

import Foundation
import UIKit
public extension UIDevice {
    var hasNotch: Bool {
            guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
            if UIDevice.current.orientation.isPortrait {
                return window.safeAreaInsets.top >= 44
            } else {
                return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
            }
        }
   class var isPhone: Bool {
       return UIDevice.current.userInterfaceIdiom == .phone
   }

   class var isPad: Bool {
       return UIDevice.current.userInterfaceIdiom == .pad
   }

   class var isTV: Bool {
       return UIDevice.current.userInterfaceIdiom == .tv
   }

   class var isCarPlay: Bool {
       return UIDevice.current.userInterfaceIdiom == .carPlay
   }
}
