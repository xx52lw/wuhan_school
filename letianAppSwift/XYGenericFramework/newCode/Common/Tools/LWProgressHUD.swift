//
//  LWProgressHUD.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/4/2.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit

class LWProgressHUD: NSObject {
    /// 展示信息ing
    class func show(infoStr : String?) {
        if infoStr == nil {
            SVProgressHUD.show()
        }
        return SVProgressHUD.show(withStatus: infoStr)
    }
   /// 展示信息
    class func showInfo(infoStr : String) {
        return SVProgressHUD.showInfo(withStatus: infoStr)
    }
    /// 展示错误信息
    class func showError(infoStr : String) {
        return SVProgressHUD.showError(withStatus: infoStr)
    }
    /// 展示正确信息
    class func showSuccess(infoStr : String) {
        return SVProgressHUD.showSuccess(withStatus: infoStr)
    }
    /// 展示进度信息
    class func showProgress(infoStr : String , progress : Float) {
        return SVProgressHUD.showProgress(progress, status: infoStr)
    }
    /// 消失
    class func dismiss() {
        return SVProgressHUD.dismiss()
    }
}
