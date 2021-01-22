//
//  UIColor+Appearance.swift
//  WeatherActivity
//
//  Created by Infinum on 30.12.2020..
//

import UIKit
import SwiftUI

enum CustomColors {
    case OrangeColor
    case GreenColor
    case BlueColor
    case RedColor
    case PurpleColor
    case YellowColor
    case PinkColor
    case CyanColor
    case LightBlueColor
    case DarkBlueColor
    case DarkBlueLowAlphaColor
    
    func toUIColor() -> UIColor {
        switch self {
        case .OrangeColor:
            return UIColor.hexColor(hex: "#F59145")
        case .GreenColor:
            return UIColor.hexColor(hex: "#68F2B2")
        case .BlueColor:
            return UIColor.hexColor(hex: "#96D2FA")
        case .RedColor:
            return UIColor.hexColor(hex: "#FA7673")
        case .PurpleColor:
            return UIColor.hexColor(hex: "#C27EDE")
        case .YellowColor:
            return UIColor.hexColor(hex: "#F5DE50")
        case .PinkColor:
            return UIColor.hexColor(hex: "#F78BC2")
        case .CyanColor:
            return UIColor.hexColor(hex: "#5DF0EB")
        case .LightBlueColor:
            return UIColor.hexColorFullAlpha(hex: "#5BBFFF")
        case .DarkBlueColor:
            return UIColor.hexColorFullAlpha(hex: "#1C3643")
        case .DarkBlueLowAlphaColor:
            return UIColor.hexColor(hex: "#1C3643")
        }
    }
}

extension Color {
    static let widgetBody = Color("WidgetBody")
    static let widgetTitle = Color("WidgetTitle")
    static let widgetBlue = Color("WidgetBlue")
}

extension UIColor {
    static var Food = CustomColors.OrangeColor.toUIColor()
    static var Sport = CustomColors.GreenColor.toUIColor()
    static var Family = CustomColors.BlueColor.toUIColor()
    static var Romance = CustomColors.RedColor.toUIColor()
    static var Business = CustomColors.PurpleColor.toUIColor()
    static var Studying = CustomColors.YellowColor.toUIColor()
    static var Shopping = CustomColors.PinkColor.toUIColor()
    static var Entertainment = CustomColors.CyanColor.toUIColor()
    static var LightBlueColor = CustomColors.LightBlueColor.toUIColor()
    static var DarkBlueColor = CustomColors.DarkBlueColor.toUIColor()
    static var DarkBlueLowAlphaColor = CustomColors.DarkBlueLowAlphaColor.toUIColor()
    
    static let CalendarBlueColor = UIColor(named: "CalendarDarkLightBlue")
    
    class func hexColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(0.2)
        )
    }
    
    class func hexColorFullAlpha(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
