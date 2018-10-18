//
//  LWHelpIssueContentModel.swift
//  LoterSwift
//
//  Created by liwei on 2018/10/15.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
//
/// 请求Url api/StuMsg/addmsg
let LWHelpIssueContentModelUrl = "api/StuMsg/addmsg"
let LWHelpIssueContentModelUploadImageUrl = "FileUpload/UploadUserMsgTemp"
// =================================================================================================================================
// MARK: - 帮助视图发布内容模型
class LWHelpIssueContentModel: LWBaseModel {

    
    /// 1：取送 2：悬赏 3：出售
    var MsgType = ""
    /// 最多15个字符
    var MsgTitle = ""
    /// 100~99900，单位：分
    var Money :String?
    /// 是否议价
    var IfYJ = "true"
    /// 6~300个字符
    var MsgContent = ""
    /// 3~192，单位：小时
    var EffectTime = ""
    /// 展示手机号
    var ShowPhone = "false"
    /// 展示昵称
    var ShowNick = "false"
    /// 1103接口中返回的文件名，用短横杠-连接，最多5个图片
    var Pics = ""
    
}
// =================================================================================================================================
