//
//  GoodsPromotionModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class GoodsPromotionModel: NSObject {
    var cellModelArr:[GoodsPromotionCellModel] = Array()
    var promotionArr:[Dictionary<Int,String>] = Array()
    
    public class func praseGoodsPromotionData(jsonData:JSON) -> GoodsPromotionModel{
        
        let model = GoodsPromotionModel()
        
        let merchantJson = jsonData["data"]["Merchant"]
        

        
        //积分兑换
        if merchantJson["JFExchange"].boolValue == true {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[1] =  String(merchantJson["JFExchangeAmount"].intValue) + "积分兑换1元"
            model.promotionArr.append(tempDic)
        }
        //新减
        if merchantJson["NewUserReduce"].boolValue == true {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[2] =  "新用户立减\(moneyExchangeToStringTwo(moneyAmount: merchantJson["NUReduceAmount"].intValue))元"
            model.promotionArr.append(tempDic)
        }
        //满免配送
        if merchantJson["EnoughFreeDelivery"].boolValue == true {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[3] =  "满\(moneyExchangeToStringTwo(moneyAmount: merchantJson["EFDeliveryAmount"].intValue))元免配送费"
            model.promotionArr.append(tempDic)
        }
        
        //满减
        var discountInfo = ""
        if merchantJson["EnoughReduceOne"].boolValue == true {
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: merchantJson["OneEnough"].intValue))元减\(moneyExchangeToStringTwo(moneyAmount: merchantJson["OneReduce"].intValue))元"
        }
        
        
        if merchantJson["EnoughReduceTwo"].boolValue == true {
            if !discountInfo.isEmpty {
                discountInfo += "、"
            }
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: merchantJson["TwoEnough"].intValue))元减\(moneyExchangeToStringTwo(moneyAmount: merchantJson["TwoReduce"].intValue))元"
        }
        
        
        if merchantJson["EnoughReduceThree"].boolValue == true {
            if !discountInfo.isEmpty {
                discountInfo += "、"
            }
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: merchantJson["ThreeEnough"].intValue))元减\(moneyExchangeToStringTwo(moneyAmount: merchantJson["ThreeReduce"].intValue))元"
        }
        
        if !discountInfo.isEmpty {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[4] =  discountInfo
            model.promotionArr.append(tempDic)
        }
        
        //商家是否设置了购物券
        if jsonData["data"]["CashCouponList"].arrayValue.count > 0 {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[5] =  "代金券发放中"
            model.promotionArr.append(tempDic)
        }
        
        //商家是否打折
        if merchantJson["HasDiscount"].boolValue == true {
            var tempDic:Dictionary<Int,String> = Dictionary()
            tempDic[6] =  "多款商品打折"
            model.promotionArr.append(tempDic)
        }
        
        for cellJson in jsonData["data"]["CashCouponList"].arrayValue {
            model.cellModelArr.append(GoodsPromotionCellModel.praseGoodsPromotionCellData(jsonData: cellJson))
        }
        
        return model
    }
    
}


class GoodsPromotionCellModel: NSObject {
    var promotionName:String!
    var discountPrice:String!
    var promotionTime:String!
    var promotionContent:String!
    var hasGetDiscount:Bool!
    var promotionID:String!
    //剩余多少代金券未领取
    var leftNum:Int!
    
    
    public class func praseGoodsPromotionCellData(jsonData:JSON) -> GoodsPromotionCellModel{
        
        let model = GoodsPromotionCellModel()
        
        model.promotionName = "商家代金券"
        model.promotionID = jsonData["CashCouponID"].stringValue
        model.discountPrice = moneyExchangeToString(moneyAmount: jsonData["CCAmount"].intValue)
        model.promotionTime = jsonData["UseStartDT"].stringValue[0..<10] + "  至  " + jsonData["UseEndDT"].stringValue[0..<10]
        model.promotionContent = "满" + moneyExchangeToString(moneyAmount: jsonData["UseLimit"].intValue) + "元可用，仅限本店使用"
        model.hasGetDiscount =   jsonData["HasGet"].boolValue
        model.leftNum = jsonData["leftNum"].intValue
        return model
    }
    
}
