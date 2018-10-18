//
//  PromotionListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class PromotionListModel: NSObject {
    var cellModelArr:[userPromotionCellModel] = Array()
    
    public class func praseUserPromotionListData(jsonData:JSON) -> PromotionListModel{
        
        let model = PromotionListModel()
        
        for cellJson in jsonData["data"].arrayValue {
            model.cellModelArr.append(userPromotionCellModel.praseuserPromotionCellData(jsonData: cellJson))
        }
        
        return model
    }
    
    
    public class func testData() -> PromotionListModel{
        
        let model = PromotionListModel()
        
        for _ in 0..<5 {
            model.cellModelArr.append(userPromotionCellModel.testData())
        }
        return model
    }
    
}


class userPromotionCellModel: NSObject {
    var promotionName:String!
    var discountPrice:String!
    var promotionTime:String!
    var promotionContent:String!
    var merchantName:String!
    var merchantId:String!

    
    public class func testData() -> userPromotionCellModel{
        let model = userPromotionCellModel()
        
        model.promotionName = "商家代金券"
        model.merchantName = "测试商家"
        model.merchantId = "1001213"
        model.discountPrice = moneyExchangeToString(moneyAmount: 600)
        model.promotionTime = "2018-01-01"
        model.promotionContent = "满" + moneyExchangeToString(moneyAmount: 2800) + "元可用，仅限本店使用"
        return model
    }
    
    
    public class func praseuserPromotionCellData(jsonData:JSON) -> userPromotionCellModel{
        
        let model = userPromotionCellModel()
        
        model.promotionName = "商家代金券"
        model.merchantName = jsonData["MerchantName"].stringValue
        model.merchantId = jsonData["MerchantID"].stringValue
        model.discountPrice = moneyExchangeToString(moneyAmount: jsonData["CCAmount"].intValue)
        model.promotionTime = jsonData["UseStartDT"].stringValue[0..<10] + "  至  " + jsonData["UseEndDT"].stringValue[0..<10]
        model.promotionContent = "满" + moneyExchangeToString(moneyAmount: jsonData["UseLimit"].intValue) + "元可用，仅限本店使用"
        return model
    }
    
}

