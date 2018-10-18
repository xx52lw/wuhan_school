//
//  LWHelpIssueContentDetailModel.swift
//  LoterSwift
//
//  Created by liwei on 2018/10/16.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
/// 请求Url api/StuMsg/getmsg/{id}
let LWHelpIssueContentDetailModelUrl = "api/StuMsg/getmsg/"
// =================================================================================================================================
// MARK: - 帮助视图发布内容模型
class LWHelpIssueContentDetailModel: LWBaseModel {

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
    /// 当前是否有效
    var IfEffect = true
    /// 1：取送 2：悬赏 3：出售
    var MsgType = ""
    /// 手机号
    var Phone = ""
    /// 展示手机号
    var ShowPhone = false
    /// 展示昵称
    var ShowNick = false
    /// 图片列表
    var PicList : [LWHelpIssueContentDetailUrlModel]?
    
}
// =================================================================================================================================
// MARK: - 帮助视图发布内容模型
class LWHelpIssueContentDetailUrlModel: LWBaseModel {
    
    /// 图片绝对地址，用来显示
    var PicURL = ""
    /// 图片名称，用来删除图片
    var PicName = "0"
}
// =================================================================================================================================
