//
//  ShopcartModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class ShopcartModel: NSObject {

    var goodsNameStr:String!
    //实际购买价格
    var goodsPriceStr:Int!
    //出售价格
    var goodsSellerPrice:Int!
    var otherInfoStr:String = ""
    //SPU
    var goodsID:String!
    //SKU
    var goodsSKUID:String!
    //已选数量
    var selectedCount:Int = 0
    //购物车Id
    var shopCartId:String!
    
    //MARK: - 增加购物车的数据模型

    public class func praseAddShopcartData(jsonData:JSON) -> [ShopcartModel]{
        
        var modelArr:[ShopcartModel] = Array()
        for cellJosn in jsonData["data"].arrayValue {
            let model = ShopcartModel()
            model.shopCartId = cellJosn["ShopCartID"].stringValue
            model.goodsNameStr = cellJosn["GoodsName"].stringValue
            model.goodsPriceStr = cellJosn["BuyPrice"].intValue
            model.goodsSellerPrice = cellJosn["SellPrice"].intValue
            model.goodsID = cellJosn["GoodsSPUID"].stringValue
            model.goodsSKUID =  cellJosn["GoodsSKUID"].stringValue
            model.selectedCount =   cellJosn["BuyNum"].intValue
            modelArr.append(model)
        }

        return modelArr
    }
    
}




