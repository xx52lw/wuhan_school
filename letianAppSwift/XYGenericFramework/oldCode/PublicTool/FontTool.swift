//
//  FontTool.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit


func cmSystemFontWithSize(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

func cmBoldSystemFontWithSize(_ size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

//MARK: - 单行文字高度
func cmSingleLineHeight(fontSize:UIFont) -> CGFloat{
    let testStr = "单行高度测试文字"
    return testStr.stringHeight(.greatestFiniteMagnitude, font: fontSize)
}


extension UIFont {
    
    class var naviagation: UIFont {
        return cmBoldSystemFontWithSize(15)
    }
}

class FontTool: NSObject {

}
