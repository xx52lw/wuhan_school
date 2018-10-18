//
//  HotestDiscountModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestDiscountModel: NSObject {
    var cellModelArr:[HotestDiscountCellModel] = Array()
    var hasNextPage:Bool!
    var bannerPicUrl:String!
    
    
    
    public class func praseHotestDiscountData(jsonData:JSON) -> HotestDiscountModel{
        
        let model = HotestDiscountModel()
        model.hasNextPage = jsonData["data"]["HasMore"].boolValue
        model.bannerPicUrl = jsonData["data"]["DomainPic"].stringValue//PIC_DOMAIN_URL + "content/images/MarketDomain/" + jsonData["data"]["DomainPic"].stringValue
        
        for cellJson in jsonData["data"]["GoodsList"].arrayValue {
            model.cellModelArr.append(HotestDiscountCellModel.praseDiscountCellData(discountCellJson:cellJson))
        }
        
        /*
        for index in 0..<10 {
            let cellmodel = HotestDiscountCellModel.praseDiscountCellData()
            if index%2 == 0 {
               cellmodel.isSoldOut = false
                cellmodel.discountDetailStr = ""
            }
            cellmodel.rankStr = String(index+1)
          model.cellModelArr.append (cellmodel)
        }
         */
        return model
    
    }
    
}


class HotestDiscountCellModel: NSObject {
    var merchantID:String!
    var imageUrl:String!
    var goodsName:String!
    //已售加好评信息
    var goodsInfoStr:String!
    var discountDetailStr:String!
    var discountPriceStr:Int!
    var costPriceStr:Int!
    var isSoldOut:Bool!
    var sellerName:String!
    var goodsDetailStr:String!
    var rankStr:String!
    //限购单数,0表示无限制
    var buyLimitAmount:Int!
    //折扣率
    var discountRate:String!
    //月销量
    var monthSell:String!
    //好评率
    var avgScore:String!
    
    
    public class func praseDiscountCellData(discountCellJson:JSON) -> HotestDiscountCellModel{
        
        let model = HotestDiscountCellModel()
        model.merchantID = discountCellJson["MerchantID"].stringValue
        model.imageUrl = discountCellJson["GoodsPic"].stringValue//PIC_DOMAIN_URL + "content/images/GPic/" + discountCellJson["GoodsPic"].stringValue
        model.goodsName = discountCellJson["GoodsName"].stringValue
        model.buyLimitAmount = discountCellJson["BuyLimitAmount"].intValue
        model.discountRate = discountCellJson["DRate"].stringValue
        model.monthSell = discountCellJson["MonthSell"].stringValue
        model.avgScore = discountCellJson["AvgScore"].stringValue
        model.goodsInfoStr = "已销售\(model.monthSell!)  好评\(model.avgScore!)%"
        
        if discountCellJson["HasDiscount"].boolValue == true {
            
            if model.buyLimitAmount == 0 {
                model.discountDetailStr = "\(model.discountRate!)折"
            }else{
                model.discountDetailStr = "\(model.discountRate!)折" + " 限购\(model.buyLimitAmount!)单"
            }
        }else{
            model.discountDetailStr = ""
        }
        model.discountPriceStr = discountCellJson["DPrice"].intValue
        model.costPriceStr = discountCellJson["SellPrice"].intValue 
        model.isSoldOut = false
        model.sellerName = discountCellJson["MerchantName"].stringValue
        model.goodsDetailStr = discountCellJson["GoodsDes"].stringValue
        return model
    }
    
}

