//
//  MerchantMessageListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantMessageListModel: NSObject {

    var cellModelArr:[MerchantMessageListCellModel] = Array()
    
    public class func praseMerchantMessageListData(jsonData:JSON) -> MerchantMessageListModel{
        let model = MerchantMessageListModel()
        for cellJson in jsonData["data"].arrayValue {
            model.cellModelArr.append(MerchantMessageListCellModel.praseMerchantMessageListCellData(jsonData: cellJson))
        }
        return model
    }
    
    public class func testdata() -> MerchantMessageListModel{
        let model = MerchantMessageListModel()
        for _ in 0..<5 {
            model.cellModelArr.append(MerchantMessageListCellModel.testData())
        }
        return model
    }
    
}


class MerchantMessageListCellModel: NSObject {
    var BroadcastReceiveID:String!
    var ContentInf:String!
    var CreateDT:String!
    var CreatorName:String!
    
    
    public class func praseMerchantMessageListCellData(jsonData:JSON) -> MerchantMessageListCellModel{
        
        let model = MerchantMessageListCellModel()
        model.BroadcastReceiveID = jsonData["BroadcastReceiveID"].stringValue
        model.ContentInf = jsonData["ContentInf"].stringValue
        model.CreateDT = timeStrFormate(timeStr: jsonData["CreateDT"].stringValue)
        model.CreatorName = jsonData["CreatorName"].stringValue
        return model
    }
    
    
    public class func testData() -> MerchantMessageListCellModel{
        
        let model = MerchantMessageListCellModel()
        model.BroadcastReceiveID = "123456"
        model.ContentInf = "这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试"
        model.CreateDT = "2017-18-7 15:23:26"
        model.CreatorName = "呵呵哒"
        return model
    }
}
