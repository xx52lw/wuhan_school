//
//  GoodsDetailShowModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/1.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class GoodsDetailShowModel: NSObject {
    
    var bannerUrlArr:[String] = Array()
    var goodsDetailEvaluateArr:[EvaluateCellModel] = Array()
    var goodsName:String!
    var goodsSaleCount:String!
    var goodsEvaluateScore:String!
    var goodsDiscountInfo:String!
    var goodsDiscountPrice:Int!
    var goodsPrice:Int!
    var goodsDetailInfo:String!
    var totalEvaluateCount:Int!
    var dissatisfiedCount:Int!
    var satisfiedCount:Int!
    var  commonCount:Int!
    var  selectedCount:Int = 0
    
    var hasNextPage:Bool!
    //限购单数,0表示无限制
    var buyLimitAmount:Int!
    //折扣率
    var discountRate:String!
    //是否有折扣
    var hasDiscount:Bool!
    //商品状态
    var SKUStatus:Int!
    
    public class func praseGoodsDetailShowData(jsonData:JSON) -> GoodsDetailShowModel{
        
        let model = GoodsDetailShowModel()
        
        model.goodsName = jsonData["data"]["SPU"]["GoodsName"].stringValue
        model.goodsSaleCount = jsonData["data"]["SPU"]["MostSell"].stringValue
        model.goodsEvaluateScore = jsonData["data"]["SPU"]["AvgScore"].stringValue
        model.SKUStatus = jsonData["data"]["SPU"]["SKUStatus"].intValue
        
        model.buyLimitAmount = jsonData["data"]["SPU"]["BuyLimitAmount"].intValue
        model.discountRate = jsonData["data"]["SPU"]["DRate"].stringValue
        model.hasDiscount = jsonData["data"]["SPU"]["HasDiscount"].boolValue
        if model.hasDiscount == true {
            
            if model.buyLimitAmount == 0 {
                model.goodsDiscountInfo = "\(model.discountRate!)折"
            }else{
                model.goodsDiscountInfo = "\(model.discountRate!)折" + " 限购\(model.buyLimitAmount!)单"
            }
        }else{
            model.goodsDiscountInfo = ""
        }
        
        
        model.goodsDiscountPrice = jsonData["data"]["SPU"]["DPrice"].intValue
        model.goodsPrice = jsonData["data"]["SPU"]["SellPrice"].intValue //"¥ "+"20.9"
        model.goodsDetailInfo = jsonData["data"]["SPU"]["GoodsDes"].stringValue
        model.dissatisfiedCount = jsonData["data"]["SPU"]["ContentUnsatisf"].intValue
        model.satisfiedCount = jsonData["data"]["SPU"]["ContentSatisf"].intValue
        model.commonCount = jsonData["data"]["SPU"]["ContentCommon"].intValue
        model.totalEvaluateCount = model.dissatisfiedCount + model.satisfiedCount + model.commonCount!

        model.bannerUrlArr = [jsonData["data"]["SPU"]["GoodsPic"].stringValue]//[PIC_DOMAIN_URL + "Content/images/GPic/" +  jsonData["data"]["SPU"]["GoodsPic"].stringValue]
        
        
        for cellJson in jsonData["data"]["CommentList"].arrayValue {
            model.goodsDetailEvaluateArr.append(EvaluateCellModel.praseEvaluateCellData(jsonData: cellJson))
        }
        
        return model
    }
    
}



