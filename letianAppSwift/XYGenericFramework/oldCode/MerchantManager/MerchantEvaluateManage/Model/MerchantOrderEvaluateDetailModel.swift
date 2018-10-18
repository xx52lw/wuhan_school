//
//  MerchantOrderEvaluateDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderEvaluateDetailModel: NSObject {
    
    var MerchantCommentID:String!
    var UserOrderID:String!
    var CommentContent:String!
    var HasReplay:Bool!
    var IfShow:Bool!
    var ReplyContent:String!
    var merchantScore:Int!
    
    var GoodsEvaluateCellModelArr:[MerchantGoodsEvaluateCellModel] = Array()
    
    public class func praseMerchantOrderEvaluateDetailData(jsonData:JSON) -> MerchantOrderEvaluateDetailModel{
        
        let model = MerchantOrderEvaluateDetailModel()
        
        model.MerchantCommentID = jsonData["data"]["Comment"]["MerchantCommentID"].stringValue
        model.UserOrderID = jsonData["data"]["Comment"]["UserOrderID"].stringValue
        model.CommentContent = jsonData["data"]["Comment"]["CommentContent"].stringValue
        model.HasReplay = jsonData["data"]["Comment"]["HasReplay"].boolValue
        model.IfShow = jsonData["data"]["Comment"]["IfShow"].boolValue
        model.ReplyContent = jsonData["data"]["Comment"]["ReplyContent"].stringValue
        model.merchantScore = jsonData["data"]["Comment"]["StarNum"].intValue
        
        
        for cellJson in jsonData["data"]["CommentList"].arrayValue {
            let cellModel = MerchantGoodsEvaluateCellModel.praseMerchantGoodsEvaluateCellData(jsonData: cellJson)
            model.GoodsEvaluateCellModelArr.append(cellModel)
        }
        return model
    }
}


class MerchantGoodsEvaluateCellModel: NSObject {
    
    var GoodsCommentID:String!
    var CommentContent:String!
    var HasReplay:Bool!
    var ReplyContent:String!
    var GoodsName:String!
    var StarNum:Int!
    
    
    public class func praseMerchantGoodsEvaluateCellData(jsonData:JSON) -> MerchantGoodsEvaluateCellModel{
        
        let model = MerchantGoodsEvaluateCellModel()
        
        model.GoodsCommentID = jsonData["GoodsCommentID"].stringValue
        model.CommentContent = jsonData["CommentContent"].stringValue
        model.ReplyContent = jsonData["ReplyContent"].stringValue
        model.HasReplay = jsonData["HasReplay"].boolValue
        model.StarNum = jsonData["StarNum"].intValue
        
        model.GoodsName = jsonData["GoodsName"].stringValue
        
        
        return model
    }
}
