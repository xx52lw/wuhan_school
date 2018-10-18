//
//  LWTabItemsConfigurationModel.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ================================================================================================================================
// MARK: - tabbar配置模型
class LWTabItemsConfigurationModel: LWBaseModel {

    /// 创建类的类名
    var classString : String = ""
    /// item的标题 - 没有标题仅显示图片
    var titleString : String = ""
    /// item的图片名称
    var imageName : String = ""
    /// 支持显示类型，支持多个类型时候用“|”隔离
    var showType : String = ""
    required init() {
        
    }
}
// ================================================================================================================================
