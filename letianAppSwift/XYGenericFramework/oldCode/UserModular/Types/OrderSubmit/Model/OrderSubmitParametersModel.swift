//
//  OrderSubmitParametersModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderSubmitParametersModel: NSObject {
    
    var merchantID:String!
    var selectedRecieverModel:OrderRecieverSetModel!
    var selectedAdressModel:OrderRecieverAdressModel!
    var selectedDeliveryTimeModel:DeliverChooseTypeModel!
    var selectedSchoolBuildingModel:OrderSchoolAdressModel!
    var selectedPromotionModel:SellerPromotionCellModel!
    var isUseJF:Bool = false
    var useJFAmount:Int!
    //待支付金额
    var needPayAmount:Int!
    //备注
    var remarksInfo:String!

}

class OrderSubmitResultModel: NSObject {
    var userOrderID:String!
    var totalPayMoney:Int!
    var merchantName:String!
    var effectTime:Int!
    
    //提交订单返回结果
    public class func praseOrderSubmitResultData(jsonData:JSON) -> OrderSubmitResultModel{
        let model = OrderSubmitResultModel()
        model.merchantName = jsonData["data"]["MerchantName"].stringValue
        model.userOrderID = jsonData["data"]["UserOrderID"].stringValue
        model.totalPayMoney = jsonData["data"]["TotalPayMoney"].intValue
        model.effectTime = jsonData["data"]["EffectTime"].intValue
        return model
    }
    
    //获取支付信息返回的结果
    public class func praseOrderInfoData(jsonData:JSON) -> OrderSubmitResultModel{
        let model = OrderSubmitResultModel()
        model.merchantName = jsonData["data"]["MerchantName"].stringValue
        model.userOrderID = jsonData["data"]["UserOrderID"].stringValue
        model.totalPayMoney = jsonData["data"]["PayAmount"].intValue
        model.effectTime = jsonData["data"]["LeftSeconds"].intValue
        return model
    }
    
}


