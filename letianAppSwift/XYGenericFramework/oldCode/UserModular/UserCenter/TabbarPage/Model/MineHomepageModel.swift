//
//  MineHomepageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class MineHomepageModel: NSObject {
    
    var userName:String!
    var userTel:String!
    var userAvatarUrl:String!
    var bannerImageUrl:String!
    var sectionCellModelArr:[[Dictionary<String,UIImage>]] = [[["订单管理":#imageLiteral(resourceName: "mineOrderManager")],["收货地址":#imageLiteral(resourceName: "mineAdress")]],[["联系客服":#imageLiteral(resourceName: "mineCustomerService")],["帮助":#imageLiteral(resourceName: "mineHelp")]],[["校园众包":#imageLiteral(resourceName: "mineSchool")]]]



    
public class func praseMineHomepageData() -> MineHomepageModel{
    
    let model = MineHomepageModel()
    model.userName = "立刻登录"
    model.userTel = "登录后享受更多功能"
    model.userAvatarUrl = ""
    model.bannerImageUrl = ""
    

    return model
    }
}


class MineHomepageCellModel: NSObject {
    var titleName:String!
    var cellImage:UIImage!

    
}


