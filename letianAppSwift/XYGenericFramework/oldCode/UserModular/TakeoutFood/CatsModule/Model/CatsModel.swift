//
//  CatsModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/12.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

class CatsModel: NSObject {

    var cellModelArr:[CatsCellModel] = Array()
    var hasNextPage:Bool!

    
    class func praseCatsModelData(jsonData:JSON) -> CatsModel{
        
        let model = CatsModel()
        for cellJson in jsonData["data"]["MerchantList"].arrayValue {
            model.cellModelArr.append(CatsCellModel.praseTakeFoodCellData(jsonData: cellJson))
        }
        
        model.hasNextPage = jsonData["data"]["HasMore"].boolValue

        return model
    }
    
}


class CatsCellModel: NSObject {
    var sellerID:String!
    var sellerImageUrl:String!
    var sellerTitle:String!
    var sellerGrade:Double!
    var deliveryFee:String!
    var startPrice:String!
    var sellerPromotion:String!
    //是否校园专送
    var isForSchool:Bool!
    //是否支持预约
    var isSupportAppointment:Bool!
    //配送时长
    var deliveryTime:String!
    //配送距离
    var deliveryDistance:String!
    //是否新用户立减
    var newUserReduce:Bool!
    //是否有满减优惠
    var enoughReduce:Bool!
    //是否有积分兑换
    var JFExchange:Bool!
    //是否有满多少减免配送费
    var EnoughFreeDelivery:Bool!
    //配送费类型,1:梯形收费,2:配送费
    var deliveryFeeType:Int!
    //是否暂停营业
    var IsPause:Bool!
    //是否在营业时间内
    var IsOpenTime:Bool!
    
    public class func praseTakeFoodCellData(jsonData:JSON) -> CatsCellModel{
        
        let model = CatsCellModel()
        model.sellerID = jsonData["MerchantID"].stringValue
        model.sellerImageUrl = jsonData["Logo"].stringValue//PIC_DOMAIN_URL + "content/images/Logo/" + jsonData["Logo"].stringValue
        model.sellerTitle = jsonData["MerchantName"].stringValue
        model.sellerGrade = jsonData["TAvgScore"].doubleValue
        model.deliveryFeeType = jsonData["DeliveryFeeType"].intValue
        model.IsPause = jsonData["IsPause"].boolValue
        model.IsOpenTime = jsonData["IsOpenTime"].boolValue
        var deliveryFeeTypeStr:String = ""
        if model.deliveryFeeType == 1 {
            deliveryFeeTypeStr = "梯形收费"
        }else {
            deliveryFeeTypeStr = "配送费"
        }
        
        //是否满额免配送费
        model.EnoughFreeDelivery = jsonData["EnoughFreeDelivery"].boolValue
        if jsonData["EnoughFreeDelivery"].boolValue == true {
            model.deliveryFee = deliveryFeeTypeStr + ": " + "￥" + moneyExchangeToString(moneyAmount:jsonData["DeliveryFee"].intValue) +  "/满" + moneyExchangeToString(moneyAmount:jsonData["EFDeliveryAmount"].intValue) + "元免配送费"
        }else{
            model.deliveryFee = deliveryFeeTypeStr + ": " + "￥" + moneyExchangeToString(moneyAmount:jsonData["DeliveryFee"].intValue)
        }
        
        //起送费
        model.startPrice = "起送费: " + "￥" + moneyExchangeToString(moneyAmount:jsonData["DeliveryLimit"].intValue) 
        //1：校园众包，2：商家配送
        if jsonData["ExpressWayType"].intValue == 1{
            model.isForSchool = true
        }else{
            model.isForSchool = false
        }
        //1:预约，2：预约+尽快送达
        if jsonData["ExpressTimeType"].intValue == 1{
            model.isSupportAppointment = true
        }else{
            model.isSupportAppointment = false
        }
        
        model.deliveryTime = "\(jsonData["AvgDeliveryTime"].intValue)" + "分钟"
        
        model.deliveryDistance = "\(jsonData["Distance"].intValue)m"
        
        model.JFExchange = jsonData["JFExchange"].boolValue
        model.enoughReduce = jsonData["EnoughReduce"].boolValue
        model.newUserReduce = jsonData["NewUserReduce"].boolValue
        return model
}
}
