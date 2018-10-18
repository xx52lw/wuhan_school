//
//  LWTimerManageTool.swift
//  LoterSwift
//
//  Created by liwei on 2018/6/28.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit

// ================================================================================================================================
// MARK: - 定时器管理工具 (使用通知方式接受)
class LWTimerManageTool: NSObject {
    /// 共享单例
    static let instance = LWTimerManageTool()
    class func sharedInstance() -> LWTimerManageTool {
        return instance
    }
    /// 定时器
    lazy var timer: Timer = {
        let t = Timer.scheduledTimer(timeInterval: 1.0, target:self,selector:#selector(beginTimer),
                                     userInfo:nil,repeats:true)
        RunLoop.main.add(t, forMode: .commonModes)
        return t
    }()
    // MARK:  定时器运行
    public func runGlobalTimer() {
        timer.fire()
    }
    // MARK:  定时器运行
    public func stopGlobalTimer() {
        timer.invalidate()
    }
   // MARK:  定时器运行方法
    @objc private  func beginTimer() {
        LWPOSTNotification(NotificationName: LWTimerNotification) // 使用者通过接受通知，处理相应事件
    }
}
// ================================================================================================================================

