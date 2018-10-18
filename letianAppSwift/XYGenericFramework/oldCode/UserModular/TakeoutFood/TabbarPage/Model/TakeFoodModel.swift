//
//  TakeFoodModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/3.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class TakeFoodModel: NSObject {

    var bannerModelArr:[TakeFoodBannerModel] = Array()
    var takeFoodTypeModelArr:[TakeFoodTypeModel] = Array()
    var takeFoodHotestModelArr:[TakeFoodHotestModel] = Array()
    var cellModelArr:[TakeFoodCellModel] = Array()
    //当前地址
    var currentAdress:String!
    var geoHash:String!
    
    
    public class func praseTakeFoodData(jsonData:JSON) -> TakeFoodModel{
        
        let model = TakeFoodModel()
        
        //如果全局的商品分类不为空，则先清空
        if foodTypeModel.FoodTypeModelArr.count > 0{
            foodTypeModel.FoodTypeModelArr.removeAll()
        }
        
        for typeJosn in jsonData["data"]["CatList"].arrayValue{
            model.takeFoodTypeModelArr.append(TakeFoodTypeModel.praseTakeFoodType(jsonData: typeJosn))
        }
        
        for  hotestJson in jsonData["data"]["MarketModuleList"].arrayValue {
            model.takeFoodHotestModelArr.append(TakeFoodHotestModel.praseTakeFoodHotest(jsonData: hotestJson))
        }
        
        for sellerModel in jsonData["data"]["MerchantList"].arrayValue {
            let cellModel = TakeFoodCellModel.praseTakeFoodCellData(jsonData: sellerModel)
            model.cellModelArr.append(cellModel)
        }
        
        for bannerJson in jsonData["data"]["CarouselList"].arrayValue {
            let bannerModel = TakeFoodBannerModel.praseTakeFoodBanner(jsonData: bannerJson)
            model.bannerModelArr.append(bannerModel)
        }
        if jsonData["data"]["Address"].stringValue.count <= 8{
        model.currentAdress = jsonData["data"]["Address"].stringValue
        }else{
        model.currentAdress = (jsonData["data"]["Address"].stringValue)[0..<8] + "..."
        }
        model.geoHash = jsonData["data"]["Geohash"].stringValue
        return model
    }

    
    
    
    public class func TestData() -> TakeFoodModel{
        
        let model = TakeFoodModel()
        
        
        for _ in 0..<4 {
           model.takeFoodTypeModelArr.append(TakeFoodTypeModel.testData())
           model.takeFoodHotestModelArr.append(TakeFoodHotestModel.testData())
        }
        
        for index in 0..<10 {
            let cellModel = TakeFoodCellModel.testData()
            if index == 1{
                cellModel.isForSchool = false
                cellModel.isSupportAppointment = true
                cellModel.sellerGrade = 3.6
                cellModel.deliveryTime = "1小时25分钟"
                cellModel.deliveryDistance = ""
                cellModel.JFExchange = true
                cellModel.enoughReduce = false
                cellModel.newUserReduce = false
            }else if index == 2 {
                cellModel.isForSchool = true
                cellModel.isSupportAppointment = false
                cellModel.sellerGrade = 2.5
                cellModel.deliveryTime = ""
                cellModel.deliveryDistance = "655m"
                cellModel.JFExchange = false
                cellModel.enoughReduce = false
                cellModel.newUserReduce = false
            }else if index == 5{
                cellModel.isForSchool = false
                cellModel.isSupportAppointment = false
                cellModel.deliveryTime = ""
                cellModel.deliveryDistance = ""
                cellModel.sellerGrade = 1.5
                cellModel.JFExchange = false
                cellModel.enoughReduce = true
                cellModel.newUserReduce = false
            }else if index == 6 {
                cellModel.isForSchool = false
                cellModel.isSupportAppointment = true
                cellModel.sellerGrade = 1.9
                cellModel.deliveryTime = "1小时25分钟"
                cellModel.deliveryDistance = "566m"
                cellModel.JFExchange = false
                cellModel.enoughReduce = true
                cellModel.newUserReduce = true
            }else if index == 8 {
                cellModel.isForSchool = false
                cellModel.isSupportAppointment = true
                cellModel.sellerGrade = 5
                cellModel.deliveryTime = "1小时25分钟"
                cellModel.deliveryDistance = ""
                cellModel.JFExchange = true
                cellModel.enoughReduce = true
                cellModel.newUserReduce = true
            }
            model.cellModelArr.append(cellModel)
        }
        

        return model
    }
    
}



class TakeFoodCellModel: NSObject {
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
    
    public class func praseTakeFoodCellData(jsonData:JSON) -> TakeFoodCellModel{
        
        let model = TakeFoodCellModel()
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
        
        model.EnoughFreeDelivery = jsonData["EnoughFreeDelivery"].boolValue
        //是否满额免配送费
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
    
    public class func testData() -> TakeFoodCellModel{
        
        let model = TakeFoodCellModel()
        model.sellerImageUrl = "12356"
        model.sellerTitle = "肯德基网上餐厅(光谷店)"
        model.sellerGrade = 4.7
        model.deliveryFee = "配送费: " + "￥1/满24元免配送"
        model.startPrice = "起送费: " + "￥12"
        model.isForSchool = true
        model.isSupportAppointment = true
        model.deliveryTime = "1小时25分钟"
        model.deliveryDistance = "678m"
        model.JFExchange = true
        model.enoughReduce = false
        model.newUserReduce = true
        return model
    }
    
    
}




class TakeFoodTypeModel: NSObject {
    var typeName:String!
    var typeImageUrl:String!
    var typeId:Int!
    
    public class func praseTakeFoodType(jsonData:JSON) -> TakeFoodTypeModel{
        let model = TakeFoodTypeModel()
        model.typeName = jsonData["CatName"].stringValue
        model.typeImageUrl = jsonData["Pic"].stringValue//PIC_DOMAIN_URL + "content/images/Catalog/" +
            //jsonData["Pic"].stringValue
        model.typeId = jsonData["GoodsFCatID"].intValue
        
        //保存所有一级分类及二级分类到全局变量
        var secondTypeModelArr:[FoodSecondTypeModel] = Array()
        for secondJson in jsonData["SCatList"].arrayValue {
            secondTypeModelArr.append(FoodSecondTypeModel.praseFoodSecondTypeData(jsonData: secondJson))
        }
        var allFoodTypeDic:Dictionary<String,[FoodSecondTypeModel]> = Dictionary()
        allFoodTypeDic[model.typeName] = secondTypeModelArr
        foodTypeModel.FoodTypeModelArr.append(allFoodTypeDic)
        
        
        return model
    }
    
    
    public class func testData() -> TakeFoodTypeModel{
        let model = TakeFoodTypeModel()
        model.typeName = "超市"
        model.typeImageUrl = "1234"
        model.typeId = 123
        return model
    }
    
    
}


class TakeFoodHotestModel: NSObject {
    
    var hotestName:String!
    var hotestImageUrl:String!
    var hotestDescription:String!
    var hotestID:Int!
    var hotestPosition:Int!
    
    
    public class func praseTakeFoodHotest(jsonData:JSON) -> TakeFoodHotestModel{
        
        let model = TakeFoodHotestModel()
        model.hotestName = jsonData["MainName"].stringValue
        model.hotestImageUrl = jsonData["HomePic"].stringValue//PIC_DOMAIN_URL + "content/images/MarketHome/"  +  jsonData["HomePic"].stringValue
        model.hotestDescription = jsonData["MinorName"].stringValue
        model.hotestID = jsonData["MMID"].intValue
        model.hotestPosition = jsonData["Position"].intValue
        return model
    }
    
    public class func testData() -> TakeFoodHotestModel{
        
        let model = TakeFoodHotestModel()
        model.hotestName = "天天打折"
        model.hotestImageUrl = "123"
        model.hotestDescription = "1-9折"
        model.hotestID = 1
        model.hotestPosition = 2
        return model
    }
    
}

class TakeFoodBannerModel: NSObject {
    var imageUrl:String!
    var isLinkMerchant:Bool!
    var linkUrl:String!
    var position:Int!
    
    public class func praseTakeFoodBanner(jsonData:JSON) -> TakeFoodBannerModel{
    
        let model = TakeFoodBannerModel()
        model.imageUrl = jsonData["Pic"].stringValue//PIC_DOMAIN_URL +  "content/images/Carousel/" + jsonData["Pic"].stringValue
        model.isLinkMerchant = jsonData["IsLinkMerchant"].boolValue
        model.linkUrl =   jsonData["Link"].stringValue
        model.position = jsonData["Position"].intValue
        return model
        
    }
}

