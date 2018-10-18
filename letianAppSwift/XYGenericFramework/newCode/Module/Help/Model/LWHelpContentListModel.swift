//
//  LWHelpContentModel.swift
//  LoterSwift
//
//  Created by 张星星 on 2018/10/14.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
/// 请求Url api/StuMsg/msglist/{type}/{page}
let LWHelpContentListModelUrl = "api/StuMsg/msglist"
// =================================================================================================================================
// MARK: - 帮助视图内容模型
class LWHelpContentListModel: LWBaseModel {
    
    /// 是否有更多数据
    var hasMore = false
    /// 列表
    var list : [LWHelpContentModel]?
    
}
// =================================================================================================================================
// MARK: - 帮助视图内容模型
class LWHelpContentModel: LWBaseModel {
    
    /// 信息主键
    var UserMsgID = ""
    /// 用户昵称
    var NickName = ""
    /// 区域名称（学校名称）
    var AreaName = ""
    /// 头像
    var HeadImg = ""
    /// 是否议价
    var IfYJ = false
    /// 价格（分）
    var Money = ""
    /// 信息内容
    var MsgContent = ""
    /// 最后更新日期 2018-09-19T15:10:24.75
    var UpdateDT = ""
    /// 有效期（单位：小时）
    var EffectTime = ""
    /// 举报数量
    var ComplainCount = "0"
    /// 1：取送 2：悬赏 3：出售
    var MsgType = ""
    
}
// =================================================================================================================================
