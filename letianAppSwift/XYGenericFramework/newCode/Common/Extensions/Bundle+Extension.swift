//
//  Bundle+Extension.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import Foundation
// ==================================================================================================================
/// bundle拓展方法
extension Bundle {
    // 计算性属性类似函数，没有参数，有返回值
    /// 获取当前的bundleName
    var nameSpace : String {
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    var version : String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""    
    }
}
// ==================================================================================================================
