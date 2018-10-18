//
//  StaffOrderDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class StaffOrderDetailModel: NSObject {
    //剩余时长
    var leftLimitTime:Int!
    //展示时长方式
    var TimeShowType:Int!
    //订单号
    var orderNumber:String!
    //下单时间
    var orderGenerationTime:String!
    //配送时间要求
    var DeliveryType:String!
    //订单收货人信息
    var recieverUserInfo:String!
    var recieverName:String!
    var recieverGender:Int!
    var recieverTel:String!
    var recieverAdress:String!
    //下单人信息
    var orderGenerationUserInfo:String!
    var generationUserName:String!
    var generationUserGender:Int!
    var generationUserTel:String!
    //卖家名称
    var sellerName:String!

    
    //是否使用了积分
    var IfJFExchange:Bool!
    //积分兑换金额
    var JFReduce:Int!
    //是否使用代金券
    var IfUseCC:Bool!
    var CCAmount:Int!
    var totalMoney:Int!
    var discountAmount:Int!
    var needPayAmount:Int!
    //配送费
    var deliveryMoney:String!
    //是否减免配送费
    var isDeliveryFree:Bool!
    
    //备注
    var otherInfo:String!
    
    //订单信息数组
    var statusListModelArr:[StaffStatusListModel] = Array()
    //商品数组
    var goodsCellArr:[StaffOrderDetailCellModel] = Array()
    //折扣数组
    var userDiscountArr:[StaffOrderDetailDiscountModel] = Array()
    
    

    
    /*已送达当中，含有配送时长及送达状态字段*/
    var DeliveryUseTime:Int!
    var ArriveStatus:String!
    var HasArrive:Bool!
    

    
    //MARK: - 解析当前订单详情数据
    public class func praseOrderDetailData(jsonData:JSON) -> StaffOrderDetailModel{
        let model = StaffOrderDetailModel()
        
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(StaffStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }
        
        
        let orderJson = jsonData["data"]["Order"]
        model.leftLimitTime = orderJson["LeftSeconds"].intValue
        model.TimeShowType = orderJson["TimeShowType"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.DeliveryType = orderJson["DeliveryType"].stringValue
        model.orderGenerationTime = "下单时间: " +  timeStrFormate(timeStr: orderJson["OrderCreateDT"].stringValue)
        //model.MerchantID = orderJson["MerchantID"].stringValue
        
        //收件人信息
        model.recieverName = orderJson["ReceiverName"].stringValue
        model.recieverGender = orderJson["ReceiverSex"].intValue
        model.recieverTel = orderJson["RecieverPhone"].stringValue
        model.recieverAdress = orderJson["ReceiveAddress"].stringValue
        let tempStr = model.recieverName + spaceStr + cmGetGenderStr(gender: model.recieverGender)
        model.recieverUserInfo = tempStr + spaceStr + model.recieverTel + spaceStr + model.recieverAdress
        
        //下单人信息
        model.generationUserName = orderJson["CreatorName"].stringValue
        model.generationUserGender = orderJson["CreatorSex"].intValue
        model.generationUserTel = orderJson["CreatorPhone"].stringValue
        model.orderGenerationUserInfo = model.generationUserName + spaceStr + cmGetGenderStr(gender: model.generationUserGender) + spaceStr + model.generationUserTel
        
        
        //model.orderStatusDes = orderJson["Status"].stringValue
        model.IfJFExchange = orderJson["IfJFExchange"].boolValue
        model.JFReduce = orderJson["JFReduce"].intValue
        model.IfUseCC = orderJson["IfUseCC"].boolValue
        model.CCAmount = orderJson["CCAmount"].intValue
        
        
        if orderJson["IfNUReduce"].boolValue == true {
            let discountModel = StaffOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = StaffOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = StaffOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["Reduce"].intValue
            discountModel.discountStatus = .enoughReduce
            discountModel.discountStr = "满¥" + String(orderJson["Enough"].intValue) + "减¥" + String(discountModel.reduceMoney)
            model.userDiscountArr.append(discountModel)
        }
        
        model.isDeliveryFree = orderJson["IfEFDelivery"].boolValue
        model.deliveryMoney = "¥" + moneyExchangeToString(moneyAmount: orderJson["DeliveryFee"].intValue)
        
        model.totalMoney = orderJson["TotalAmount"].intValue
        model.discountAmount = orderJson["ReduceAmount"].intValue
        model.needPayAmount = orderJson["PayAmount"].intValue
        model.otherInfo = "备注: "+orderJson["Remarks"].stringValue
        
        
        //商品model
        for cellJson in jsonData["data"]["OrderDetailList"].arrayValue {
            let cellmodel = StaffOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = StaffOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        

        model.DeliveryUseTime = orderJson["DeliveryUseTime"].intValue
        model.ArriveStatus = orderJson["ArriveStatus"].stringValue
        model.HasArrive = orderJson["HasArrive"].boolValue
        
        return model
    }
}

class StaffOrderDetailCellModel: NSObject {
    var goodsCount:Int!
    var goodsName:String!
    var goodsPrice:Int!
    var goodsOtherInfo:String = ""
    
    //商品Cell
    public class func praseOrderGoodsCellData(jsonData:JSON) -> StaffOrderDetailCellModel{
        let model = StaffOrderDetailCellModel()
        model.goodsCount = jsonData["Num"].intValue
        model.goodsName = jsonData["Name"].stringValue
        model.goodsPrice = jsonData["Money"].intValue
        return model
    }
    
    //解析配件Cell
    public class func praseAttachData(jsonData:JSON) -> StaffOrderDetailCellModel{
        let model = StaffOrderDetailCellModel()
        model.goodsCount = jsonData["Num"].intValue
        model.goodsName = jsonData["Name"].stringValue
        model.goodsPrice = jsonData["Money"].intValue
        return model
    }
    
}

//MARK: - 配送员订单详情折扣类
enum StaffOrderDetailDiscountEnum:String {
    //默认
    case none
    //新用户立减
    case newUser = "新用户立减"
    //满减
    case enoughReduce = "满减"
    
}
class StaffOrderDetailDiscountModel: NSObject {
    var reduceMoney:Int!
    var discountStatus:StaffOrderDetailDiscountEnum = .none
    var discountStr:String!
    
    
}

//MARK: - 配送员订单信息类
class StaffStatusListModel: NSObject {
    var StatusDetail:String!
    var HappenDT:String!
    var StatusDes:String!
    
    public class func praseStatusCellModelData(jsonData:JSON) -> StaffStatusListModel{
        let model = StaffStatusListModel()
        model.StatusDetail = jsonData["StatusDetail"].stringValue
        model.HappenDT = jsonData["HappenDT"].stringValue
        model.StatusDes = jsonData["StatusDes"].stringValue
        return model
    }
    
}


