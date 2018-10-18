//
//  CorlorTool.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

// MARK: - 通过色值获取颜色
func cmColorWithString(colorName:String) -> UIColor {
    var cString:String = colorName.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    if (colorName.characters.count != 6) {
        return UIColor.gray
    }
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func cmColorWithString(colorName:String,alpha:CGFloat) -> UIColor{
    var cString:String = colorName.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    if (colorName.characters.count != 6) {
        return UIColor.gray
    }
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}


extension UIColor {
    
    class var navigationBG: UIColor {
        return cmColorWithString(colorName:"0x201f27")
    }
    
    class var line: UIColor {
        return cmColorWithString(colorName:"0xf4f4f4")
    }
    
    class var background: UIColor {
        return cmColorWithString(colorName:"ffffff")
    }
    
    //设置渐变的背景颜色
    class func createGradientLayer(needSetView:UIView,fromColor:UIColor,toColor:UIColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = needSetView.bounds
        gradientLayer.colors = [fromColor.cgColor,toColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0,1]
        
        return gradientLayer
    }
    
}


