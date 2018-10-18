//
//  EvaluateModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/19.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class EvaluateModel: NSObject {
    
    var cellModelArr:[EvaluateCellModel] = Array()
    var sellerScore:Double!
    var deliveryScore:Double!
    var goodsScore:Double!
    var comprehensiveScore:Double!
    var totalCount:Int!
    var dissatisfiedCount:Int!
    var satisfiedCount:Int!
   var  commonCount:Int!
    var hasNextPage:Bool!
    
    public class func praseEvaluateData(jsonData:JSON) -> EvaluateModel{
        
        let model = EvaluateModel()
        
        model.sellerScore = jsonData["data"]["Merchant"]["MAvgScore"].doubleValue
        model.deliveryScore = jsonData["data"]["Merchant"]["AvgDeliveryTime"].doubleValue
        model.goodsScore = jsonData["data"]["Merchant"]["GAvgScore"].doubleValue
        model.comprehensiveScore = jsonData["data"]["Merchant"]["TAvgScore"].doubleValue
        model.dissatisfiedCount = jsonData["data"]["Merchant"]["ContentUnsatsf"].intValue
        model.satisfiedCount = jsonData["data"]["Merchant"]["ContentSatisf"].intValue
        model.commonCount = jsonData["data"]["Merchant"]["Qualification"].intValue
        model.totalCount = model.dissatisfiedCount + model.satisfiedCount + model.commonCount!
        model.hasNextPage = jsonData["data"]["HasMore"].boolValue
        
        for cellJson in jsonData["data"]["CommentList"].arrayValue {
            model.cellModelArr.append(EvaluateCellModel.praseEvaluateCellData(jsonData:cellJson))
        }
        
        return model
    }
    
    
    //MARK: - 解析下拉评论数据
    public class func praseEvaluatePullData(jsonData:JSON) -> EvaluateModel{
        
        let model = EvaluateModel()
        

        model.hasNextPage = jsonData["data"]["HasMore"].boolValue
        
        for cellJson in jsonData["data"]["CommentList"].arrayValue {
            model.cellModelArr.append(EvaluateCellModel.praseEvaluateCellData(jsonData:cellJson))
        }
        
        return model
    }
    
}


class EvaluateCellModel: NSObject {
    var userName:String!
    var userAvatar:String!
    var evaluateTime:String!
    var score:Double!
    var evaluateContent:String!
    var answerContent:String!

    //是否默认好评
    var isDefaultComment:Bool!
    //是否已回复
    var hasAnswerComment:Bool!
    
    
    public class func praseEvaluateCellData(jsonData:JSON) -> EvaluateCellModel{
        
        let model = EvaluateCellModel()
        
        model.userName = jsonData["UserNickname"].stringValue
        model.userAvatar = jsonData["HeadImg"].stringValue//PIC_DOMAIN_URL + "Content/images/HeadImg/" +  jsonData["HeadImg"].stringValue
        model.evaluateTime =   timeStrFormate(timeStr: jsonData["CommentDT"].stringValue) 
        model.score = jsonData["StarNum"].doubleValue
        model.hasAnswerComment = jsonData["HasReplay"].boolValue
        model.isDefaultComment = jsonData["IsSysComment"].boolValue
        if  model.hasAnswerComment == true {
        model.answerContent = "商家回复: "+jsonData["ReplyContent"].stringValue
        }else{
            model.answerContent = ""
        }
        model.evaluateContent = jsonData["CommentContent"].stringValue

        return model
    }
    
}
