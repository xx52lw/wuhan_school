//
//  OrderEvaluateModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/30.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderEvaluateModel: NSObject {

    var UserOrderID:String!
    var MerchantName:String!
    var merchantScore:Int = -1
    var merchantEvaluateContent:String = ""
    var waitEvaluateGoodsModelArr:[OrderWaitEvaluateCellModel] = Array()
    
        public class func praseOrderEvaluateModelData(jsonData:JSON) -> OrderEvaluateModel{
            let model = OrderEvaluateModel()
            model.UserOrderID = jsonData["data"]["UserOrderID"].stringValue
            model.MerchantName = jsonData["data"]["MerchantName"].stringValue
            for cellJson in jsonData["data"]["OrderDetailList"].arrayValue {
               model.waitEvaluateGoodsModelArr.append(OrderWaitEvaluateCellModel.praseOrderWaitEvaluateCellData(jsonData: cellJson))
            }
            return model
        }
    
    public class func test() -> OrderEvaluateModel{
        let model = OrderEvaluateModel()
        model.UserOrderID = "123456797977"
        model.MerchantName = "测试"
        for index in 0..<10 {
            let cellmodel = OrderWaitEvaluateCellModel()
            cellmodel.OrderDetailID = "13464"
            cellmodel.GoodsName = "炒饭\(index)"
            model.waitEvaluateGoodsModelArr.append(cellmodel)
        }
        return model
    }
    
}


class OrderWaitEvaluateCellModel: NSObject {
    
    var OrderDetailID:String!
    var GoodsName:String!
    var evaluateScore:Int = -1
    var evaluateContent:String = ""
    
    public class func praseOrderWaitEvaluateCellData(jsonData:JSON) -> OrderWaitEvaluateCellModel{
        let model = OrderWaitEvaluateCellModel()
        model.OrderDetailID = jsonData["OrderDetailID"].stringValue
        model.GoodsName = jsonData["GoodsName"].stringValue
        
        return model
    }
    
    
}
