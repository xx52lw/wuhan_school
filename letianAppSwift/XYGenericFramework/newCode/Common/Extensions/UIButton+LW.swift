//
//  UIButton+LW.swift
//  LoterSwift
//
//  Created by liwei on 2018/8/9.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ==================================================================================================================
/// 按钮拓展方法
extension UIButton {

    /// 创建文字按钮
    class func createTitleBtn(_ titleFont : UIFont ,titleColor : UIColor, title: String?,bgColor : UIColor?,target: Any?, action: Selector) -> LWButton{
        let btn = LWButton.init(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = titleFont
        btn.setTitleColor(titleColor, for: UIControl.State.normal)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.backgroundColor = bgColor
        btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        return btn
    }
    /// 创建图片按钮
    class func createImageBtn(_ image : UIImage ,bgImage : UIImage,bgColor : UIColor?,target: Any?, action: Selector) -> LWButton{
        let btn = LWButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(image, for: UIControl.State.normal)
        btn.setBackgroundImage(bgImage, for: UIControl.State.normal)
        btn.backgroundColor = bgColor
        btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        return btn
    }
    /// 创建图片在右侧按钮
    class func createImageAtRightBtn(_ titleFont : UIFont ,titleColor : UIColor, title: String?, image : UIImage,bgColor : UIColor?,target: Any?, action: Selector) -> LWButton{
        let btn = LWButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(image, for: UIControl.State.normal)
        btn.titleLabel?.font = titleFont
        btn.setTitleColor(titleColor, for: UIControl.State.normal)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.backgroundColor = bgColor
        btn.sizeToFit()
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -btn.imageView!.frame.size.width - 15, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn.titleLabel?.frame.size.width)! + 5, bottom: 0, right: 0)
        return btn
    }
}
// ==================================================================================================================
