//
//  HotestRankModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestRankModel: NSObject {
    var cellModelArr:[HotestRankCellModel] = Array()
    //
    var hasNextPage:Bool!

    
    
    public class func praseRankJsonData(jsonData:JSON) -> HotestRankModel{
        
        let model = HotestRankModel()
        
        for cellJsonIndex in 0..<jsonData["data"].arrayValue.count {
            let cellJson = jsonData["data"].arrayValue[cellJsonIndex]
            let cellModel = HotestRankCellModel.praseRankCellData(jsonData: cellJson)
            cellModel.rankStr = String(cellJsonIndex+1)
            model.cellModelArr.append (cellModel)
        }
        
//        for index in 0..<10 {
//            let cellmodel = HotestRankCellModel.praseRankCellData()
//            if index%2 == 0 {
//                cellmodel.isSoldOut = false
//                cellmodel.discountDetailStr = ""
//            }
//            cellmodel.rankStr = String(index+1)
//            model.cellModelArr.append (cellmodel)
//        }
        //model.typesStrArr = ["¥10以下","美食 ¥10-¥15","食堂 ¥20-¥25","¥30-¥35","¥35-¥40","¥40以上"]
        return model
        
    }
    

}

class HotestRankTypeModel: NSObject {
    var bannerPicUrl:String!
    var typesModelArr:[HotestRankTypeCellModel] = Array()
    
    public class func praseRankTypeJsonData(jsonData:JSON) -> HotestRankTypeModel{
        
        let model = HotestRankTypeModel()
        model.bannerPicUrl = jsonData["data"]["DomainPic"].stringValue//PIC_DOMAIN_URL + "content/images/MarketDomain/" +  jsonData["data"]["DomainPic"].stringValue
        model.typesModelArr = HotestRankTypeCellModel.praseRankTypeCellData(jsonData: jsonData["data"])
        return model
    }
    
}

class HotestRankTypeCellModel: NSObject {
    var typeID:Int!
    var typeName:String!
    
    public class func praseRankTypeCellData(jsonData:JSON) -> [HotestRankTypeCellModel]{
        
        var typeCellModelArr:[HotestRankTypeCellModel] = Array()
    
        
        let modelType1 = HotestRankTypeCellModel()
        modelType1.typeID = 1
        modelType1.typeName = "食堂 " + "¥\(jsonData["Param11"].intValue/100)" + "-" + "¥\(jsonData["Param12"].intValue/100)"
        typeCellModelArr.append(modelType1)
        
        let modelType2 = HotestRankTypeCellModel()
        modelType2.typeID = 2
        modelType2.typeName = "食堂 " + "¥\(jsonData["Param21"].intValue/100)" + "-" + "¥\(jsonData["Param22"].intValue/100)"
        typeCellModelArr.append(modelType2)
        
        let modelType3 = HotestRankTypeCellModel()
        modelType3.typeID = 3
        modelType3.typeName = "食堂 " + "¥\(jsonData["Param31"].intValue/100)" + "-" + "¥\(jsonData["Param32"].intValue/100)"
        typeCellModelArr.append(modelType3)
        
        let modelType4 = HotestRankTypeCellModel()
        modelType4.typeID = 4
        modelType4.typeName = "美食 " + "¥\(jsonData["Param41"].intValue/100)" + "-" + "¥\(jsonData["Param42"].intValue/100)"
        typeCellModelArr.append(modelType4)
        
        let modelType5 = HotestRankTypeCellModel()
        modelType5.typeID = 5
        modelType5.typeName = "美食 " + "¥\(jsonData["Param51"].intValue/100)" + "-" + "¥\(jsonData["Param52"].intValue/100)"
        typeCellModelArr.append(modelType5)
        
        let modelType6 = HotestRankTypeCellModel()
        modelType6.typeID = 6
        modelType6.typeName = "美食 " + "¥\(jsonData["Param61"].intValue/100)" + "-" + "¥\(jsonData["Param62"].intValue/100)"
        typeCellModelArr.append(modelType6)
        
        let modelType7 = HotestRankTypeCellModel()
        modelType7.typeID = 7
        modelType7.typeName = "美食 " + "¥\(jsonData["Param62"].intValue/100)" + "以上"
        typeCellModelArr.append(modelType7)
        
        
        return typeCellModelArr
    }
    
}


class HotestRankCellModel: NSObject {
    var imageUrl:String!
    var goodsName:String!
    var goodsInfoStr:String!
    var discountDetailStr:String!
    var discountPriceStr:Int!
    var costPriceStr:Int!
    var isSoldOut:Bool!
    var sellerName:String!
    var goodsDetailStr:String!
    var rankStr:String!
    var merchantID:String!
    //月销量
    var monthSell:String!
    //好评率
    var avgScore:String!
    //限购单数,0表示无限制
    var buyLimitAmount:Int!
    //折扣率
    var discountRate:String!
    
    
    public class func praseRankCellData(jsonData:JSON) -> HotestRankCellModel{
        
        let model = HotestRankCellModel()
        model.merchantID = jsonData["MerchantID"].stringValue
        model.imageUrl = jsonData["GoodsPic"].stringValue//PIC_DOMAIN_URL + "content/images/GPic/" + jsonData["GoodsPic"].stringValue
        model.goodsName = jsonData["GoodsName"].stringValue
        model.monthSell = jsonData["MonthSell"].stringValue
        model.avgScore = jsonData["AvgScore"].stringValue
        model.goodsInfoStr = "已销售\(model.monthSell!)  好评\(model.avgScore!)%"
        model.buyLimitAmount = jsonData["BuyLimitAmount"].intValue
        model.discountRate = jsonData["DRate"].stringValue
        
        if jsonData["HasDiscount"].boolValue == true {
            
            if model.buyLimitAmount == 0 {
                model.discountDetailStr = "\(model.discountRate!)折"
            }else{
                model.discountDetailStr = "\(model.discountRate!)折" + " 限购\(model.buyLimitAmount!)单"
            }
        }else{
            model.discountDetailStr = ""
        }
        
        model.discountPriceStr = jsonData["DPrice"].intValue
        model.costPriceStr = jsonData["SellPrice"].intValue
        model.isSoldOut = false
        model.sellerName = jsonData["MerchantName"].stringValue
        model.goodsDetailStr = jsonData["GoodsDes"].stringValue
        return model
}
    
    
}
