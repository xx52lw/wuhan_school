//
//  SellerHomePageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerHomePageModel: NSObject {
    //当前选中的分类下商品
    var goodsCellModelArr:[SellerHomePageGoodsCellModel] = Array()
    //所有的分类
    var goodsCatArr:[String] = Array()
    var typeAndGoodsModelDicArr:[Dictionary<String,[SellerHomePageGoodsCellModel]>] = Array()
    var shopcartModelArr:[ShopcartModel] = Array()
    
    var shopcartGoodsModelArr:[ShopcartModel] = Array()
    var  merchantName:String!
    var merchantAvatarUrl:String!
    //配送费
    var  deliveryFee:Int!
    //起送价
    var  deliveryLimit:Int!
    var  sellerNotice:String!
    //是否暂停营业
    var isOpenStatus:Bool!
    //营业时间段1
    var openOneEnd:Int!
    var openOneStart:Int!
    //是否有营业时间段2
    var hasOpenTwo:Bool!
    var openTwoEnd:Int!
    var openTwoStart:Int!
    //是否新用户立减
    var newUserReduce:Bool!
    //立减金额
    var NUReduceAmount:Int!
    //是否积分兑换
    var JFExchange:Bool!
    //多少积分兑换1元
    var JFExchangeAmount:Int!
    //是否满额免邮
    var EnoughFreeDelivery:Bool!
    //免邮额度
    var EFDeliveryAmount:Int!
    //是否开启满减策略一
    var EnoughReduceOne:Bool!
    //策略一满多少
    var OneEnough:Int!
    //策略一减多少
    var OneReduce:Int!
    
    //是否开启满减策略二
    var EnoughReduceTwo:Bool!
    //策略二满多少
    var TwoEnough:Int!
    //策略二减多少
    var TwoReduce:Int!
    
    // 是否开启满减策略三
    var EnoughReduceThree:Bool!
    // 策略三满多少
    var ThreeEnough:Int!
    // 策略三减多少
    var ThreeReduce:Int!
    var HasSC:Bool!
    
    
    public class func praseSellerHomepageData(jsonData:JSON) -> SellerHomePageModel{
        
        let model = SellerHomePageModel()
        model.HasSC = jsonData["data"]["HasSC"].boolValue
        
        let shortJsonData = jsonData["data"]["Merchant"]
        
        model.merchantName = shortJsonData["MerchantName"].stringValue
        model.merchantAvatarUrl = shortJsonData["Logo"].stringValue//PIC_DOMAIN_URL + "Content/images/Logo/" +  shortJsonData["Logo"].stringValue
        model.deliveryFee = shortJsonData["DeliveryFee"].intValue
        model.deliveryLimit = shortJsonData["DeliveryLimit"].intValue
        model.sellerNotice = shortJsonData["Notice"].stringValue
        model.isOpenStatus = shortJsonData["OpenStatus"].boolValue
        model.openOneStart = shortJsonData["OpenOneStart"].intValue
        model.openOneEnd = shortJsonData["OpenOneEnd"].intValue
        model.hasOpenTwo = shortJsonData["OpenTwo"].boolValue
        model.openTwoStart = shortJsonData["OpenTwoStart"].intValue
        model.openTwoEnd = shortJsonData["OpenTwoEnd"].intValue
        model.newUserReduce = shortJsonData["NewUserReduce"].boolValue
        model.NUReduceAmount = shortJsonData["NUReduceAmount"].intValue
        model.JFExchange = shortJsonData["JFExchange"].boolValue
        model.JFExchangeAmount = shortJsonData["JFExchangeAmount"].intValue
        model.EnoughFreeDelivery = shortJsonData["EnoughFreeDelivery"].boolValue
        model.EFDeliveryAmount = shortJsonData["EFDeliveryAmount"].intValue
        model.EnoughReduceOne = shortJsonData["EnoughReduceOne"].boolValue
        model.OneEnough = shortJsonData["OneEnough"].intValue
        model.OneReduce = shortJsonData["OneReduce"].intValue
        model.EnoughReduceTwo = shortJsonData["EnoughReduceTwo"].boolValue
        model.TwoEnough = shortJsonData["TwoEnough"].intValue
        model.TwoReduce = shortJsonData["TwoReduce"].intValue
        model.EnoughReduceThree = shortJsonData["EnoughReduceThree"].boolValue
        model.ThreeEnough = shortJsonData["ThreeEnough"].intValue
        model.ThreeReduce = shortJsonData["ThreeReduce"].intValue
        
        
        for catAndGoodsJson in jsonData["data"]["CatList"].arrayValue{
            var dicModel:Dictionary<String,[SellerHomePageGoodsCellModel]>  = Dictionary()
            var cellModelArr:[SellerHomePageGoodsCellModel]  = Array()
            for cellJson in catAndGoodsJson["SpuList"].arrayValue {
                cellModelArr.append(SellerHomePageGoodsCellModel.praseSellerHomepageGoodsData(jsonData:cellJson))
            }
            
            dicModel[catAndGoodsJson["CatName"].stringValue] = cellModelArr
            model.typeAndGoodsModelDicArr.append(dicModel)
        }
        
        for tempDic in model.typeAndGoodsModelDicArr {
            model.goodsCatArr.append(tempDic.keys.first!)
        }
        
        model.goodsCellModelArr = model.typeAndGoodsModelDicArr.first!.values.first!
        
        for shopcartGoodsJson in jsonData["data"]["ShopCartList"].arrayValue {
            let shopcartGoodsModel = ShopcartModel()
            shopcartGoodsModel.goodsNameStr = shopcartGoodsJson["GoodsName"].stringValue
            shopcartGoodsModel.goodsID = shopcartGoodsJson["GoodsSPUID"].stringValue
            shopcartGoodsModel.goodsSKUID = shopcartGoodsJson["GoodsSKUID"].stringValue
            shopcartGoodsModel.shopCartId = shopcartGoodsJson["ShopCartID"].stringValue
            shopcartGoodsModel.goodsPriceStr = shopcartGoodsJson["BuyPrice"].intValue
            shopcartGoodsModel.goodsSellerPrice = shopcartGoodsJson["SellPrice"].intValue
            shopcartGoodsModel.selectedCount = shopcartGoodsJson["BuyNum"].intValue
            model.shopcartModelArr.append(shopcartGoodsModel)
        }
        
        return model
        
    }
}

class SellerHomePageGoodsCellModel: NSObject {
    
    var imageUrl:String!
    var goodsName:String!
    var goodsInfoStr:String!
    var discountDetailStr:String!
    var discountPriceStr:Int!
    var costPriceStr:Int!
    var goodsDetailStr:String!
    var goodsID:String!
    //限购单数,0表示无限制
    var buyLimitAmount:Int!
    //折扣率
    var discountRate:String!
    //月销量
    var monthSell:String!
    //好评率
    var avgScore:String!
    //商品状态,1:待上架，2：销售中，3：暂停销售
    var goodsStatus:Int!
    
    //已选数量
    var selectedCount:Int = 0
    

    public class func praseSellerHomepageGoodsData(jsonData:JSON) -> SellerHomePageGoodsCellModel{
        
        let model = SellerHomePageGoodsCellModel()
        model.imageUrl = jsonData["GoodsPic"].stringValue//PIC_DOMAIN_URL + "content/images/GPic/" +  jsonData["GoodsPic"].stringValue
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
        model.goodsDetailStr = jsonData["GoodsDes"].stringValue
        model.goodsID = jsonData["GoodsSPUID"].stringValue
        model.goodsStatus = jsonData["SKUStatus"].intValue

        
        return model
        
        
        
    }
}

