//
//  Color+extension.swift
//  One_Menu
//
//  Created by Jordain Gijsbertha on 10/08/2020.
//

import UIKit
import SwiftUI

// MARK: - Colors


extension Color {
    public static var primaryOne: Color {
        return Color(#colorLiteral(red: 0.9882352941, green: 0.4470588235, blue: 0.3843137255, alpha: 1))
    }
    public static var primaryTwo: Color {
        return Color(#colorLiteral(red: 0.768627451, green: 0.2509803922, blue: 0.2156862745, alpha: 1))
    }
    public static var secondaryOne: Color {
        return Color(#colorLiteral(red: 0.1333333333, green: 0.2196078431, blue: 0.262745098, alpha: 1))
    }
    public static var secondaryTwo: Color {
        return Color(#colorLiteral(red: 0.4549019608, green: 0.5490196078, blue: 0.6705882353, alpha: 1))
    }
    public static var NeutralDark: Color {
        return Color(#colorLiteral(red: 0.1019607843, green: 0.1294117647, blue: 0.3176470588, alpha: 1))
    }
    public static var NeutralLight: Color {
        return Color(#colorLiteral(red: 0.8901960784, green: 0.9098039216, blue: 1, alpha: 1))
    }
}



extension Color {
   
    init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){

            self.init(
                        .sRGB,
                        red:     Double(rgbaData!.r),
                        green:   Double(rgbaData!.g),
                        blue:    Double(rgbaData!.b),
                        opacity: Double(rgbaData!.a)
                    )
            return
        }
        return nil
    }
}

extension UIColor {

    public convenience init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){
            self.init(
                        red:   rgbaData!.r,
                        green: rgbaData!.g,
                        blue:  rgbaData!.b,
                        alpha: rgbaData!.a)
            return
        }
        return nil
    }
}

private func getrgbaData(hexString: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {

    var rgbaData : (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? = nil

    if hexString.hasPrefix("#") {

        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...]) // Swift 4

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {

            rgbaData = { // start of a closure expression that returns a Vehicle
                switch hexColor.count {
                case 8:

                    return ( r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                             g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                             b: CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255,
                             a: CGFloat( hexNumber & 0x000000ff)        / 255
                           )
                case 6:

                    return ( r: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                             g: CGFloat((hexNumber & 0x00ff00) >> 8)  / 255,
                             b: CGFloat((hexNumber & 0x0000ff))       / 255,
                             a: 1.0
                           )
                default:
                    return nil
                }
            }()

        }
    }

    return rgbaData
}
