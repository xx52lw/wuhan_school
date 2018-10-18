//
//  OrderSubmitModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/17.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderSubmitModel: NSObject {

    
    //卖家名称
    var sellerName:String!
    //配送费
    var deliveryMoney:Int!
    //是否减免配送费
    var isDeliveryFree:Bool!
    var totalMoney:Int!
    var discountAmount:Int!
    var needPayAmount:Int!
    //1:商家设置了预约，2：商家设置了预约+尽快送达
    var ExpressTimeType:Int!
    //配送时间列表
    var DeliverChooseTypeArr:[DeliverChooseTypeModel] = Array()
    
    //是否支持积分兑换或积分足够
    var IfJFExchange:Bool!
    //多少积分兑换1元
    var JFExchangeAmount:Int!
    //用户可用积分
    var JFAmount:Int!
    //备注
    var otherInfo:String!
    //折扣数组
    var userDiscountArr:[OrderDetailDiscountModel] = Array()
    //商品数组
    var goodsCellArr:[OrderDetailCellModel] = Array()
    //代金券数组
    var promotionArr:[SellerPromotionCellModel] = Array()
    //收货人数组
    var recieverArr:[OrderRecieverSetModel] = Array()
    //收货人详细地址
    var recieverAdressArr:[OrderRecieverAdressModel] = Array()
    
    //默认收货人
    var defaultRecieverModel:OrderRecieverSetModel!
    
    
    public class func prasePrepareSubmitModeData(jsonData:JSON) -> OrderSubmitModel{
        let model = OrderSubmitModel()
        model.totalMoney = jsonData["data"]["TotalPayMoney"].intValue
        model.discountAmount = jsonData["data"]["SaveMoney"].intValue
        model.needPayAmount = jsonData["data"]["TotalPayMoney"].intValue
        model.isDeliveryFree = jsonData["data"]["IfFreeDelivery"].boolValue
        model.IfJFExchange = jsonData["data"]["IfJFExchange"].boolValue
        model.JFExchangeAmount = jsonData["data"]["JFExchangeAmount"].intValue
        model.JFAmount = jsonData["data"]["JFAmount"].intValue

        
        if jsonData["data"]["IfNewReduce"].boolValue == true {
            let discountModel = OrderDetailDiscountModel()
            discountModel.reduceMoney = jsonData["data"]["NewReduceAmount"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = OrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if jsonData["data"]["IfEnoughReduce"].boolValue == true {
            let discountModel = OrderDetailDiscountModel()
            discountModel.reduceMoney = jsonData["data"]["Reduce"].intValue
            discountModel.discountStatus = .enoughReduce
            discountModel.discountStr = "满¥" + String(jsonData["data"]["Enough"].intValue) + "减¥" + String(discountModel.reduceMoney)
            model.userDiscountArr.append(discountModel)
        }
        
        //配送时间列表
        
        //如果配送时间2，则在数组前添加尽快送达
        model.ExpressTimeType = jsonData["data"]["ExpressTimeType"].intValue
        if model.ExpressTimeType == 2 {
            let deliveryTimeTypeModel  = DeliverChooseTypeModel()
            deliveryTimeTypeModel.isDeliverySoon = true
            deliveryTimeTypeModel.ExpressTime = "尽快送达"
            model.DeliverChooseTypeArr.append(deliveryTimeTypeModel)

        }
        
        for deliveryTimeCellJson in jsonData["data"]["ExpressTimeList"].arrayValue {
            let cellmodel = DeliverChooseTypeModel.praseDeliverChooseTypeData(jsonData: deliveryTimeCellJson)
            model.DeliverChooseTypeArr.append(cellmodel)
        }
        
        //购物车数据
        for cellJson in jsonData["data"]["ShopcartList"].arrayValue {
            let cellmodel = OrderDetailCellModel.prasePrparSubmitOrderCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = OrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            cellmodel.goodsIsAttach = true
            model.goodsCellArr.append(cellmodel)
        }
        
        //代金券
        for promotionCellJson in  jsonData["data"]["UserCCList"].arrayValue {
            let cellmodel = SellerPromotionCellModel.prasePromotionCellData(jsonData: promotionCellJson)
            model.promotionArr.append(cellmodel)
        }
        
        //收货人
        for recieverJsonCell in jsonData["data"]["AddressList"].arrayValue {
            let cellmodel = OrderRecieverSetModel.praseRecieverSetCellData(jsonData: recieverJsonCell)
            if cellmodel.isselected == true {
                model.defaultRecieverModel = cellmodel
            }
            model.recieverArr.append(cellmodel)
        }
        
        //收货人区域下的配送地址
        for deliveryAreaJson in jsonData["data"]["FAreaList"].arrayValue {
            let cellmodel = OrderRecieverAdressModel.praseRecieverAdressData(jsonData: deliveryAreaJson)
            model.recieverAdressArr.append(cellmodel)
        }
        
        return model
    }
    
    
}


class OrderRecieverSetModel: NSObject {
    var IsDefault:Bool!
    var PhoneNumber:String!
    var  UserName:String!
    var  Sex:Int!
    var isselected:Bool!
    
    public class func praseRecieverSetCellData(jsonData:JSON) -> OrderRecieverSetModel{
        let model = OrderRecieverSetModel()
        model.IsDefault = jsonData["IsDefault"].boolValue
        model.PhoneNumber = jsonData["PhoneNumber"].stringValue
        model.UserName = jsonData["UserName"].stringValue
        model.Sex = jsonData["Sex"].intValue
        
        if model.IsDefault == true {
            model.isselected = true
        }else {
            model.isselected = false
        }
        return model
    }

}


class OrderRecieverAdressModel: NSObject {
    var  FAreaName:String!
    var  FAreaID:Int!
    //区域下的学校楼栋数组
    var  SAreaListModelArr:[OrderSchoolAdressModel] = Array()

    public class func praseRecieverAdressData(jsonData:JSON) -> OrderRecieverAdressModel{
        let model = OrderRecieverAdressModel()
        model.FAreaName = jsonData["FAreaName"].stringValue
        model.FAreaID = jsonData["FAreaID"].intValue
        for tempJson in jsonData["SAreaList"].arrayValue {
            model.SAreaListModelArr.append(OrderSchoolAdressModel.praseSchoolAdressData(jsonData: tempJson))
        }
        return model
    }
    

}

class OrderSchoolAdressModel: NSObject {
    var SAreaID:Int!
    var SAreaName:String!
    var isSelected:Bool = false

    public class func praseSchoolAdressData(jsonData:JSON) -> OrderSchoolAdressModel{
        let model = OrderSchoolAdressModel()
        model.SAreaName = jsonData["SAreaName"].stringValue
        model.SAreaID = jsonData["SAreaID"].intValue
        
        return model
    }

}


class OrderSelectJFModel: NSObject {
    var jfAmount:Int!
    var isSelected:Bool = false
}

class DeliverChooseTypeModel: NSObject {
    var ExpressTime:String!
    var MExpressTimeID:String!
    var isDeliverySoon:Bool = false
    var isSelected:Bool = false
    
    public class func praseDeliverChooseTypeData(jsonData:JSON) -> DeliverChooseTypeModel{
        let model = DeliverChooseTypeModel()
        model.ExpressTime = jsonData["ExpressTime"].stringValue
        model.MExpressTimeID = jsonData["MExpressTimeID"].stringValue
        return model
    }
    
}

