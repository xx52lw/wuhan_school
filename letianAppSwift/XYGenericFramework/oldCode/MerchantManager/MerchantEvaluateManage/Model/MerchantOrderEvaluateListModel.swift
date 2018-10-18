//
//  MerchantOrderEvaluateListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderEvaluateListModel: NSObject {
    
    var evaluateSectionModelArr:[MerchantOrderEvaluateSectionModel] = Array()
    
    public class func praseMerchantOrderEvaluateListData(jsonData:JSON) -> MerchantOrderEvaluateListModel{
        let model = MerchantOrderEvaluateListModel()
        for sectionJson in jsonData["data"].arrayValue {
            let sectionModel = MerchantOrderEvaluateSectionModel.parseMerchantOrderEvaluateSectionListData(jsonData: sectionJson)
            model.evaluateSectionModelArr.append(sectionModel)
        }
        return model
    }
    
}


class MerchantOrderEvaluateSectionModel: NSObject {
    var Day:String!
    var evaluateCellModelArr:[MerchantOrderEvaluateCellModel] = Array()
    
    public class func parseMerchantOrderEvaluateSectionListData(jsonData:JSON) -> MerchantOrderEvaluateSectionModel{
        
        let model = MerchantOrderEvaluateSectionModel()
        model.Day = jsonData["Day"].stringValue
            for cellJson in jsonData["OrderList"].arrayValue {
                let cellModel = MerchantOrderEvaluateCellModel.praseMerchantOrderEvaluateCellData(jsonData: cellJson)
                model.evaluateCellModelArr.append(cellModel)
            }
        return model
    }
}


class MerchantOrderEvaluateCellModel: NSObject {
    
    var MerchantCommentID:String!
    var CommentDT:String!
    var UserOrderID:String!
    var UserInfID:Int!
    var HasReplay:Bool!
    var IfShow:Bool!
    
    
    public class func praseMerchantOrderEvaluateCellData(jsonData:JSON) -> MerchantOrderEvaluateCellModel{
        
        let model = MerchantOrderEvaluateCellModel()
        
        model.MerchantCommentID = jsonData["MerchantCommentID"].stringValue
        model.CommentDT = jsonData["CommentDT"].stringValue
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.UserInfID = jsonData["UserInfID"].intValue
        model.HasReplay = jsonData["HasReplay"].boolValue
        model.IfShow = jsonData["IfShow"].boolValue

        
        return model
    }
    
}
