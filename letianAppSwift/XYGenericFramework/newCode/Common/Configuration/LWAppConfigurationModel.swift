//
//  LWAppConfigurationModel.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ================================================================================================================================
// MARK: - app配置模型
class LWAppConfigurationModel: LWBaseModel {

    /// 共享单例
    static let instance = LWNetWorkingTool<LWAppConfigurationModel>.getModel(dict: getConfigurationDict())
    class func sharedInstance() -> LWAppConfigurationModel {
        return instance
    }
    required init() {
        
    }
    class func getConfigurationDict()-> Dictionary<String, Any> {
        guard let path = Bundle.main.path(forResource: "appConfiguration", ofType: ".plist") else {
            return NSDictionary() as! Dictionary<String, Any>
        }
        return NSDictionary.init(contentsOfFile: path) as! Dictionary<String, Any>
        
    }
    
    /// 默认控制器背景颜色
    var defaultControllerBgColor : String = ""
    /// 新特性图片数量
    var featureImageCount : String = ""
    /// tabbar颜色
    var tabbarColor : String = ""
    /// tabbar字体颜色
    var tabbarTextColor : String = ""
    /// tabbar选中字体颜色
    var tabbarSelectedTextColor : String = ""
    /// tabbar字体大小
    var tabbarTextFont : String = ""
    /// tabbar顶部线颜色
    var tabbarTopLineColor : String = ""
    /// 导航条背景颜色
    var navbgColor : String = ""
    /// 导航条底部线颜色
    var navBottomLineColor : String = ""
    /// 导航条文字颜色
    var navTitleColor : String = ""
    /// 导航条文字字体
    var navTitleFont : String = ""
    
}
// ================================================================================================================================
