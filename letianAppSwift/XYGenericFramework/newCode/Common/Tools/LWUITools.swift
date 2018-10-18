//
//  LWUITools.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/4/3.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ==================================================================================================================
/// UI工具方法
class LWUITools: NSObject {

    /// 测量字符串Size
    class  func sizeWithStringFont(_ string : String?, font : UIFont, maxSize : CGSize) -> CGSize {
        let str = (string ?? "") as NSString
        let option =  NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue
        return str.boundingRect(with: maxSize, options: NSStringDrawingOptions(rawValue: option), attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    /// 测量字符串Size
    class  func sizeWithStringFont(_ string : String?, font : UIFont, lineSpacing : CGFloat , maxSize : CGSize) -> CGSize {
        let str = string ?? ""
        let option =  NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue
        let attributedString = NSMutableAttributedString.init(string: str)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange.init(location: 0, length: str.count))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: str.count))
        return attributedString.boundingRect(with: maxSize, options: NSStringDrawingOptions(rawValue: option), context: nil).size
    }
    
    /// 操作两个数 op 操作 @"+" ,@"-",@"*",@"/"
    class func decimalNumber(_ num1 : Double, num2 : Double, operation : String) -> String {
        let n1 = NSDecimalNumber.init(string: "\(num1)")
        let n2 = NSDecimalNumber.init(string: "\(num2)")
        if "+" == operation {
            let re = n1.adding(n2)
            return re.stringValue
        }
        else if "-" == operation {
            let re = n1.subtracting(n2)
            return re.stringValue
        }
        else if "*" == operation {
            let re = n1.multiplying(by: n2)
            return re.stringValue
        }
        else if "/" == operation {
            let re = n1.dividing(by: n2)
            return re.stringValue
        }
        else {
            return "0"
        }
    }
    
}
// ==================================================================================================================
