//
//  UIColor+LW.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import Foundation
import UIKit
// ==================================================================================================================
/// 颜色拓展方法
extension UIColor {
    /// 根据数字颜色
    class func colorWithNum( _ r : CGFloat , g : CGFloat ,b : CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    /// 根据hex取颜色
    class func colorFromHex(hex string: String) -> UIColor {
        var hex = string.trimmingCharacters(in: .whitespaces)
        if hex.hasPrefix("#") {
//            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        } else if hex.hasPrefix("0x") {
//            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        }
        let length = hex.count
        if length != 3 && length != 6 {
            return UIColor()
        }
        if length == 3 {
//            let r = hex.substring(with: hex.startIndex..<hex.index(hex.startIndex, offsetBy: 1))
            //            let g = hex.substring(with: hex.index(hex.startIndex, offsetBy: 1)..<hex.index(hex.startIndex, offsetBy: 2))
            //            let b = hex.substring(with: hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 3))
            let r = String(hex[hex.startIndex..<hex.index(hex.startIndex, offsetBy: 1)])
            let g = String(hex[hex.startIndex..<hex.index(hex.startIndex, offsetBy: 2)])
            let b = String(hex[hex.startIndex..<hex.index(hex.startIndex, offsetBy: 3)])
                
            hex = r + r + g + g + b + b
        }
        func hexValue(_ string: String) -> Double {
            let value = Double(strtoul(string, nil, 16))
            return value
        }
//        let red = hexValue(hex.substring(with: hex.startIndex..<hex.index(hex.startIndex, offsetBy: 2)))
//        let green = hexValue(hex.substring(with: hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)))
//        let blue = hexValue(hex.substring(with: hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)))
        let red = hexValue(String(hex[hex.startIndex..<hex.index(hex.startIndex, offsetBy: 2)]))
        let green = hexValue(String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)]))
        let blue = hexValue(String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)]))
        return UIColor.init(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
    }
}
// ==================================================================================================================
