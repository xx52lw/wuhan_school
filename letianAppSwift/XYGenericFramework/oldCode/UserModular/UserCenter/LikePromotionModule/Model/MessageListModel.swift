//
//  MessageListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MessageListModel: NSObject {
    var cellModelArr:[MessageListCellModel] = Array()
    
    public class func praseMessageListData(jsonData:JSON) -> MessageListModel{
        let model = MessageListModel()
        for cellJson in jsonData["data"].arrayValue {
            model.cellModelArr.append(MessageListCellModel.praseMessageListCellData(jsonData: cellJson))
        }
        return model
    }
    
    public class func testdata() -> MessageListModel{
        let model = MessageListModel()
        for _ in 0..<5 {
            model.cellModelArr.append(MessageListCellModel.testData())
        }
        return model
    }
    
}


class MessageListCellModel: NSObject {
    var BroadcastReceiveID:String!
    var ContentInf:String!
    var CreateDT:String!
    var CreatorName:String!

    
    public class func praseMessageListCellData(jsonData:JSON) -> MessageListCellModel{
        
        let model = MessageListCellModel()
        model.BroadcastReceiveID = jsonData["BroadcastReceiveID"].stringValue
        model.ContentInf = jsonData["ContentInf"].stringValue
        model.CreateDT = timeStrFormate(timeStr: jsonData["CreateDT"].stringValue)
        model.CreatorName = jsonData["CreatorName"].stringValue
        return model
    }
    
    
    public class func testData() -> MessageListCellModel{
        
        let model = MessageListCellModel()
        model.BroadcastReceiveID = "123456"
        model.ContentInf = "这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试"
        model.CreateDT = "2017-18-7 15:23:26"
        model.CreatorName = "呵呵哒"
        return model
    }
}

