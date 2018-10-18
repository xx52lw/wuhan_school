//
//  MerchantOrderDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MerchantReturnTypeEnum:Int {
    case returnOrder = 1
    case refund = 2
    case platform = 3 //平台取证
    case none = -1
}

class MerchantOrderDetailModel: NSObject {
    
    //剩余时长
    var leftLimitTime:Int!
    //展示时长方式
    var TimeShowType:Int!
    //订单号
    var orderNumber:String!
    //下单时间
    var orderGenerationTime:String!
    //订单时间要求
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
    //var MerchantID:String!
    //订单状态描述
    //var orderStatusDes:String!

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

    //配送员信息数组
    var staffListModelArr:[MerchantStaffListModel] = Array()

    //订单信息数组
    var statusListModelArr:[MerchantStatusListModel] = Array()
    //商品数组
    var goodsCellArr:[MerchantOrderDetailCellModel] = Array()
    //折扣数组
    var userDiscountArr:[MerchantOrderDetailDiscountModel] = Array()
    
    
    //当前选择的配送员model
    var chooseStaffModel:MerchantStaffListModel!
    
    /*已送达当中，含有配送时长及送达状态字段*/
    var DeliveryUseTime:Int!
    var ArriveStatus:String!
    
    /*已退单详情中有退单状态*/
    var TDStatus:String!
    
    
    /*退单详情中*/
    var OrderStatus:String!
    //用户申请退款退单原因
    var UserReason:String!
    var TDType:MerchantReturnTypeEnum = .none
    
    //MARK: - 解析当前订单详情数据
    public class func praseOrderDetailData(jsonData:JSON) -> MerchantOrderDetailModel{
        let model = MerchantOrderDetailModel()
     
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(MerchantStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }

        
        let orderJson = jsonData["data"]["Order"]
        model.leftLimitTime = orderJson["LeftSeconds"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.TimeShowType = orderJson["TimeShowType"].intValue
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
            let discountModel = MerchantOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = MerchantOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = MerchantOrderDetailDiscountModel()
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
            let cellmodel = MerchantOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = MerchantOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //配送员信息
        for staffCellJson in jsonData["data"]["StaffList"].arrayValue {
            let cellmodel = MerchantStaffListModel.praseStaffCellModelData(jsonData:staffCellJson )
            model.staffListModelArr.append(cellmodel)
        }
        
        return model
    }
    
    
    
    //MARK: - 解析配送中订单详情数据
    public class func praseDeliveringOrderDetailData(jsonData:JSON) -> MerchantOrderDetailModel{
        let model = MerchantOrderDetailModel()
        
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(MerchantStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
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
            let discountModel = MerchantOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = MerchantOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = MerchantOrderDetailDiscountModel()
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
            let cellmodel = MerchantOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = MerchantOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //配送员信息
        for staffCellJson in jsonData["data"]["StaffList"].arrayValue {
            let cellmodel = MerchantStaffListModel.praseStaffCellModelData(jsonData:staffCellJson )
            model.staffListModelArr.append(cellmodel)
        }
        
        //已选择的配送员
        model.chooseStaffModel = MerchantStaffListModel()
        model.chooseStaffModel.DStaffID = orderJson["DStaffID"].stringValue
        model.chooseStaffModel.StaffName = orderJson["DStaffName"].stringValue
        model.chooseStaffModel.isSelected = true
        
        return model
    }
    
    
    //MARK: - 解析已送达订单详情
    public class func praseDeliveriedOrderDetailData(jsonData:JSON) -> MerchantOrderDetailModel{
        let model = MerchantOrderDetailModel()
        
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(MerchantStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }
        
        
        let orderJson = jsonData["data"]["Order"]
        model.leftLimitTime = orderJson["LeftSeconds"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.DeliveryType = orderJson["DeliveryType"].stringValue
        model.orderGenerationTime = "下单时间: " +  timeStrFormate(timeStr: orderJson["OrderCreateDT"].stringValue)
        
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
            let discountModel = MerchantOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = MerchantOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = MerchantOrderDetailDiscountModel()
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
            let cellmodel = MerchantOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = MerchantOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //配送员信息
        for staffCellJson in jsonData["data"]["StaffList"].arrayValue {
            let cellmodel = MerchantStaffListModel.praseStaffCellModelData(jsonData:staffCellJson )
            model.staffListModelArr.append(cellmodel)
        }
        
        //已选择的配送员
        model.chooseStaffModel = MerchantStaffListModel()
        model.chooseStaffModel.DStaffID = orderJson["DStaffID"].stringValue
        model.chooseStaffModel.StaffName = orderJson["DStaffName"].stringValue
        model.chooseStaffModel.isSelected = true
        
        model.DeliveryUseTime = orderJson["DeliveryUseTime"].intValue
        model.ArriveStatus = orderJson["ArriveStatus"].stringValue
        
        return model
    }
    
    //MARK: - 解析退单订单详情
    public class func praseReturnOrderDetailData(jsonData:JSON) -> MerchantOrderDetailModel{
        let model = MerchantOrderDetailModel()
        
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(MerchantStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }
        
        
        let orderJson = jsonData["data"]["Order"]
        model.leftLimitTime = orderJson["LeftSeconds"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.DeliveryType = orderJson["DeliveryType"].stringValue
        model.orderGenerationTime = "下单时间: " +  timeStrFormate(timeStr: orderJson["OrderCreateDT"].stringValue)
        
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
            let discountModel = MerchantOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = MerchantOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = MerchantOrderDetailDiscountModel()
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
            let cellmodel = MerchantOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = MerchantOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //配送员信息
        for staffCellJson in jsonData["data"]["StaffList"].arrayValue {
            let cellmodel = MerchantStaffListModel.praseStaffCellModelData(jsonData:staffCellJson )
            model.staffListModelArr.append(cellmodel)
        }
        
        //已选择的配送员
        model.chooseStaffModel = MerchantStaffListModel()
        model.chooseStaffModel.DStaffID = orderJson["DStaffID"].stringValue
        model.chooseStaffModel.StaffName = orderJson["DStaffName"].stringValue
        model.chooseStaffModel.isSelected = true
        
        //model.DeliveryUseTime = orderJson["DeliveryUseTime"].intValue
        model.ArriveStatus = orderJson["ArriveStatus"].stringValue
        model.TDStatus = orderJson["TDStatus"].stringValue
        
        model.OrderStatus = orderJson["OrderStatus"].stringValue
        model.UserReason = orderJson["UserReason"].stringValue
    
        switch orderJson["TDType"].intValue {
        case 1:
            model.TDType = .returnOrder
            break
        case 2:
            model.TDType = .refund
            break
        case 3:
            model.TDType = .platform
            break
        default:
            model.TDType = .none
            break
        }
        
        return model
    }
    
    
    //MARK: - 解析已退单订单详情
    public class func praseHasReturnedOrderDetailData(jsonData:JSON) -> MerchantOrderDetailModel{
        let model = MerchantOrderDetailModel()
        
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(MerchantStatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }
        
        
        let orderJson = jsonData["data"]["Order"]
        model.leftLimitTime = orderJson["LeftSeconds"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.DeliveryType = orderJson["DeliveryType"].stringValue
        model.orderGenerationTime = "下单时间: " +  timeStrFormate(timeStr: orderJson["OrderCreateDT"].stringValue)
        
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
            let discountModel = MerchantOrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = MerchantOrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = MerchantOrderDetailDiscountModel()
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
            let cellmodel = MerchantOrderDetailCellModel.praseOrderGoodsCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = MerchantOrderDetailCellModel.praseAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //配送员信息
        for staffCellJson in jsonData["data"]["StaffList"].arrayValue {
            let cellmodel = MerchantStaffListModel.praseStaffCellModelData(jsonData:staffCellJson )
            model.staffListModelArr.append(cellmodel)
        }
        
        //已选择的配送员
        model.chooseStaffModel = MerchantStaffListModel()
        model.chooseStaffModel.DStaffID = orderJson["DStaffID"].stringValue
        model.chooseStaffModel.StaffName = orderJson["DStaffName"].stringValue
        model.chooseStaffModel.isSelected = true
        
        model.DeliveryUseTime = orderJson["DeliveryUseTime"].intValue
        model.ArriveStatus = orderJson["ArriveStatus"].stringValue
        model.TDStatus = orderJson["TDStatus"].stringValue
        
        return model
    }
    
    
}


class MerchantOrderDetailCellModel: NSObject {
    var goodsCount:Int!
    var goodsName:String!
    var goodsPrice:Int!
    var goodsOtherInfo:String = ""
    
    //商品Cell
    public class func praseOrderGoodsCellData(jsonData:JSON) -> MerchantOrderDetailCellModel{
        let model = MerchantOrderDetailCellModel()
        model.goodsCount = jsonData["Num"].intValue
        model.goodsName = jsonData["Name"].stringValue
        model.goodsPrice = jsonData["Money"].intValue
        return model
    }
    
    //解析配件Cell
    public class func praseAttachData(jsonData:JSON) -> MerchantOrderDetailCellModel{
        let model = MerchantOrderDetailCellModel()
        model.goodsCount = jsonData["Num"].intValue
        model.goodsName = jsonData["Name"].stringValue
        model.goodsPrice = jsonData["Money"].intValue
        return model
    }
    
}

//MARK: - 商家订单详情折扣类
enum MerchantOrderDetailDiscountEnum:String {
    //默认
    case none
    //新用户立减
    case newUser = "新用户立减"
    //满减
    case enoughReduce = "满减"
    
}
class MerchantOrderDetailDiscountModel: NSObject {
    var reduceMoney:Int!
    var discountStatus:MerchantOrderDetailDiscountEnum = .none
    var discountStr:String!
    

}

//MARK: - 商家订单信息类
class MerchantStatusListModel: NSObject {
    var StatusDetail:String!
    var HappenDT:String!
    var StatusDes:String!
    
    public class func praseStatusCellModelData(jsonData:JSON) -> MerchantStatusListModel{
        let model = MerchantStatusListModel()
        model.StatusDetail = jsonData["StatusDetail"].stringValue
        model.HappenDT = jsonData["HappenDT"].stringValue
        model.StatusDes = jsonData["StatusDes"].stringValue
        return model
    }
    
}

//MARK: - 商家订单配送员类
class MerchantStaffListModel: NSObject {
    var Phone:String!
    var StaffName:String!
    var DStaffID:String!
    var isSelected:Bool!
    
    public class func praseStaffCellModelData(jsonData:JSON) -> MerchantStaffListModel{
        let model = MerchantStaffListModel()
        model.Phone = jsonData["Phone"].stringValue
        model.StaffName = jsonData["StaffName"].stringValue
        model.DStaffID = jsonData["DStaffID"].stringValue
        model.isSelected = false
        return model
    }
    
}



