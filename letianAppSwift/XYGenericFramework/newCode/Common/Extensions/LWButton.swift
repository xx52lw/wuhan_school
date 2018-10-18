//
//  LWButton.swift
//  LoterSwift
//
//  Created by liwei on 2018/9/27.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ==================================================================================================================
/// 自定义按钮
class LWButton: UIButton {

    /// 延迟时间（默认0.5秒）
    var delayTimeInterval = 0.5
    
    /// 允许点击
    private var allowClick = true
    
    @objc func changeBtnAllowClick() {
        allowClick = true
    }
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if delayTimeInterval <= 0.1 {
            
        }
        else {
            if allowClick == false {
                return
            }
            allowClick = false
            perform(#selector(changeBtnAllowClick), with: self, afterDelay: delayTimeInterval)
        }
        super.sendAction(action, to: target, for: event)
    }
    
    
}
// ==================================================================================================================
