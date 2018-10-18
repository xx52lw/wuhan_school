//
//  OrderDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

enum OrderTimeShowTypeEnum {
    case timeStop
    case timeAdd
    case timeReduce
    case timeAppointment
}

class OrderDetailModel: NSObject {
    
    var statusListModelArr:[StatusListModel] = Array()
    var firstStatusListModel:StatusListModel!
    
    //剩余支付时长
    var payLimitTime:Int!
    //时间展示方式
    var TimeShowType:OrderTimeShowTypeEnum!
    //订单号
    var orderNumber:String!
    //下单时间
    var orderGenerationTime:String!
    //配送时间类型字段
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
    var MerchantID:String!
    //订单状态描述
    var orderStatusDes:String!
    //折扣数组
    var userDiscountArr:[OrderDetailDiscountModel] = Array()
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
    
    //退单原因
    var ReturnReason:String!
    var RefundReason:String!
    //商家拒绝退款原因
    var MRefuseRefundReason:String!
    //申请客服原因
    var RequireServiceReason:String!
    //仲裁结果
    var ZCReason:String!
    //用户证据(图片)
    var UEvidenceArr:[String] = Array()
    //商家证据(图片)
    var MEvidenceArr:[String] = Array()
    


    
    //Action字段
    //支付
    var CanPay:Bool!
    //取消
    var CanCancel:Bool!
    //删除
    var CanDelete:Bool!
    //退单
    var CanRequireReturn:Bool!
    //退款
    var CanRequireRefund:Bool!
    //申请客服
    var CanRequireKF:Bool!
    
    var orderActModelArr:[OrderActModel] = Array()
    
    //备注
    var otherInfo:String!
    //商家电话
    var merchantTelOne:String!
    var merchantTelTwo:String!
    

    //商品数组
    var goodsCellArr:[OrderDetailCellModel] = Array()
    

    public class func praseOrderDetailData(jsonData:JSON) -> OrderDetailModel{
        let model = OrderDetailModel()
        let spaceStr = " "
        
        for cellJson in jsonData["data"]["StatusList"].arrayValue{
            
            model.statusListModelArr.append(StatusListModel.praseStatusCellModelData(jsonData: cellJson))
            
        }
        if model.statusListModelArr.count > 0 {
            model.firstStatusListModel = model.statusListModelArr.first
        }
        
        let orderJson = jsonData["data"]["Order"]
        model.payLimitTime = orderJson["leftSeconds"].intValue
        model.orderNumber = orderJson["UserOrderID"].stringValue
        model.sellerName = orderJson["MerchantName"].stringValue
        model.DeliveryType = orderJson["DeliveryType"].stringValue
        model.orderGenerationTime = "下单时间: " +  timeStrFormate(timeStr: orderJson["OrderCreateDT"].stringValue)
        model.MerchantID = orderJson["MerchantID"].stringValue
        
        switch orderJson["TimeShowType"].intValue {
        case 1:
            model.TimeShowType = .timeStop
            break
        case 2:
            model.TimeShowType = .timeAdd
            break
        case 3:
            model.TimeShowType = .timeReduce
        case 4:
            model.TimeShowType = .timeAppointment
            break
        default:
            break
        }
        

        //收件人信息
        model.recieverName = orderJson["ReceiverName"].stringValue
        model.recieverGender = orderJson["ReceiverSex"].intValue
        model.recieverTel = orderJson["RecieverPhone"].stringValue
        model.recieverAdress = orderJson["ReceiveAddress"].stringValue
        
        let tempInfo = model.recieverName + spaceStr + cmGetGenderStr(gender: model.recieverGender)
        model.recieverUserInfo = tempInfo + spaceStr + model.recieverTel + spaceStr + model.recieverAdress

        //下单人信息
        model.generationUserName = orderJson["CreatorName"].stringValue
        model.generationUserGender = orderJson["CreatorSex"].intValue
        model.generationUserTel = orderJson["CreatorPhone"].stringValue
        model.orderGenerationUserInfo = model.generationUserName + spaceStr + cmGetGenderStr(gender: model.generationUserGender) + spaceStr + model.generationUserTel

        
        model.orderStatusDes = orderJson["Status"].stringValue
        model.IfJFExchange = orderJson["IfJFExchange"].boolValue
        model.JFReduce = orderJson["JFReduce"].intValue
        model.IfUseCC = orderJson["IfUseCC"].boolValue
        model.CCAmount = orderJson["CCAmount"].intValue
        
        
        if orderJson["IfNUReduce"].boolValue == true {
            let discountModel = OrderDetailDiscountModel()
            discountModel.reduceMoney = orderJson["NUReduce"].intValue
            discountModel.discountStatus = .newUser
            discountModel.discountStr = OrderDetailDiscountEnum.newUser.rawValue
            model.userDiscountArr.append(discountModel)
        }
        
        if orderJson["IfEnoughReduce"].boolValue == true {
            let discountModel = OrderDetailDiscountModel()
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

        //退单原因
        model.ReturnReason = orderJson["ReturnReason"].stringValue
        model.RefundReason = orderJson["RefundReason"].stringValue
        //商家拒绝退款原因
        model.MRefuseRefundReason = orderJson["MRefuseRefundReason"].stringValue
        //申请客服原因
        model.RequireServiceReason = orderJson["RequireServiceReason"].stringValue
        //仲裁结果
        model.ZCReason = orderJson["ZCReason"].stringValue
        //用户证据(图片)
        for UEvidenceStr in orderJson["UEvidence"].stringValue.components(separatedBy: "-") {
            let picUrlStr = UEvidenceStr//PIC_DOMAIN_URL + "Content/images/Evidence/" + UEvidenceStr
        model.UEvidenceArr.append(picUrlStr)
        }
        //商家证据(图片)
        for MEvidenceStr in orderJson["MEvidence"].stringValue.components(separatedBy: "-") {
            let picUrlStr = MEvidenceStr//PIC_DOMAIN_URL + "Content/images/Evidence/" + MEvidenceStr
            model.MEvidenceArr.append(picUrlStr)
        }
        
        
        model.CanPay = orderJson["CanPay"].boolValue
        model.CanCancel = orderJson["CanCancel"].boolValue
        model.CanDelete = orderJson["CanDelete"].boolValue
        model.CanRequireReturn = orderJson["CanRequireReturn"].boolValue
        model.CanRequireRefund = orderJson["CanRequireRefund"].boolValue
        model.CanRequireKF = orderJson["CanRequireKF"].boolValue

        model.orderActModelArr = OrderActModel.getOrderActModelData(orderModel: model)
        
        model.merchantTelOne = orderJson["TelOne"].stringValue
        model.merchantTelTwo = orderJson["TelTwo"].stringValue

        
        for cellJson in jsonData["data"]["OrderDetailList"].arrayValue {
            let cellmodel = OrderDetailCellModel.praseOrderDetailInfoCellData(jsonData: cellJson)
            model.goodsCellArr.append(cellmodel)
        }
        
        //将配件的一起加入商品cell
        for otherCellJson in jsonData["data"]["AttachList"].arrayValue {
            let cellmodel = OrderDetailCellModel.praseOrderDetailAttachData(jsonData: otherCellJson)
            model.goodsCellArr.append(cellmodel)
        }
        

        return model
    }
    
    
}

//MARK: - cellModel

enum  GoodsStatusEnum:Int {
    case prepareSell  = 1
    case selling = 2
    case pauseSell = 3
    case none = -1
}
    class OrderDetailCellModel: NSObject {
        var goodsCount:Int!
        var goodsName:String!
        var goodsPrice:Int!
        var goodsOtherInfo:String = ""
        //商品状态 1:待上架，2:销售中，3：暂停销售
        var SKUStatus:GoodsStatusEnum = .none
        var sellerPrice:Int!
        var shopcartId:String!
        
        //提交订单时区分是否为配件用
        var goodsIsAttach = false
        
        
        //解析准备提交订单商品Cell
        public class func prasePrparSubmitOrderCellData(jsonData:JSON) -> OrderDetailCellModel{
            let model = OrderDetailCellModel()
            model.goodsCount = jsonData["BuyNum"].intValue
            model.goodsName = jsonData["GoodsName"].stringValue
            model.goodsPrice = jsonData["BuyPrice"].intValue
            model.sellerPrice = jsonData["SellPrice"].intValue
            model.shopcartId = jsonData["ShopCartID"].stringValue
            switch  jsonData["SKUStatus"].intValue{
            case 1:
                model.SKUStatus = .prepareSell
                break
            case 2:
                model.SKUStatus = .selling
                break
            case 3:
                model.SKUStatus = .pauseSell
                break
            default:
                model.SKUStatus = .none
                break
            }
            
            return model
        }
        
        

        //解析准备提交配件Cell
        public class func praseAttachData(jsonData:JSON) -> OrderDetailCellModel{
            let model = OrderDetailCellModel()
            model.goodsCount = jsonData["Num"].intValue
            model.goodsName = jsonData["AttachName"].stringValue
            model.goodsPrice = jsonData["TotalMoney"].intValue
            model.SKUStatus = .selling
            
            
            return model
        }
        
        
        
        //解析订单详情商品Cell
        public class func praseOrderDetailInfoCellData(jsonData:JSON) -> OrderDetailCellModel{
            let model = OrderDetailCellModel()
            model.goodsCount = jsonData["Num"].intValue
            model.goodsName = jsonData["Name"].stringValue
            model.goodsPrice = jsonData["Money"].intValue
            return model
        }
        
        
        //解析订单详情配件Cell
        public class func praseOrderDetailAttachData(jsonData:JSON) -> OrderDetailCellModel{
            let model = OrderDetailCellModel()
            model.goodsCount = jsonData["Num"].intValue
            model.goodsName = jsonData["Name"].stringValue
            model.goodsPrice = jsonData["Money"].intValue
            return model
        }
        
}




//MARK: - 折扣类
enum OrderDetailDiscountEnum:String {
    //默认
    case none
    //新用户立减
    case newUser = "新用户立减"
    //满减
    case enoughReduce = "满减"
    
}
class OrderDetailDiscountModel: NSObject {
    var reduceMoney:Int!
    var discountStatus:OrderDetailDiscountEnum = .none
    var discountStr:String!
    
    public class func praseOrderDetailDiscountData() -> OrderDetailDiscountModel{
        let model = OrderDetailDiscountModel()
        model.reduceMoney = 2
        model.discountStatus = .newUser
        return model
    }
}


//MARK: - 商家代金券
class SellerPromotionCellModel: NSObject {
    //ID
    var UserCCID:String!
    //面额
    var CCAmount:Int!
    //订单满多少可使用
    var UseLimit:Int!
    //开始使用时间
    var UseStartDT:String!
    //结束使用时间
    var UseEndDT:String!
    var promotionName = "商家代金券"
    //是否已选择
    var isSelected = false


    public class func prasePromotionCellData(jsonData:JSON) -> SellerPromotionCellModel{
        let model = SellerPromotionCellModel()
        model.UserCCID = jsonData["UserCCID"].stringValue
        model.CCAmount = jsonData["CCAmount"].intValue
        model.UseLimit = jsonData["UseLimit"].intValue
        model.UseStartDT = jsonData["UseStartDT"].stringValue
        model.UseEndDT = jsonData["UseEndDT"].stringValue

        return model
    }
    
}

class StatusListModel: NSObject {
    var StatusDetail:String!
    var HappenDT:String!
    var StatusDes:String!

    public class func praseStatusCellModelData(jsonData:JSON) -> StatusListModel{
        let model = StatusListModel()
        model.StatusDetail = jsonData["StatusDetail"].stringValue
        model.HappenDT = timeStrFormate(timeStr: jsonData["HappenDT"].stringValue)
        model.StatusDes = jsonData["StatusDes"].stringValue
        return model
    }
    
}


class  OrderActModel: NSObject {
    
    var orderActStr:String!
    var orderActStatus:OrderActStatusEnum = .none
    
    public class func getOrderActModelData(orderModel:OrderDetailModel) -> [OrderActModel]{
        
        var orderActModelArr:[OrderActModel] = Array()
        
        if orderModel.CanCancel == true {
            let model = OrderActModel()
            model.orderActStatus = .cancel
            model.orderActStr = OrderActStatusEnum.cancel.rawValue
            orderActModelArr.append(model)
        }
        if orderModel.CanDelete  == true {
            let model = OrderActModel()
            model.orderActStatus = .delete
            model.orderActStr = OrderActStatusEnum.delete.rawValue
            orderActModelArr.append(model)
        }
        if orderModel.CanRequireRefund  == true {
            let model = OrderActModel()
            model.orderActStatus = .applyRefund
            model.orderActStr = OrderActStatusEnum.applyRefund.rawValue
            orderActModelArr.append(model)
        }
        if orderModel.CanRequireKF  == true {
            let model = OrderActModel()
            model.orderActStatus = .applyCustomerService
            model.orderActStr = OrderActStatusEnum.applyCustomerService.rawValue
            orderActModelArr.append(model)
        }
        if orderModel.CanRequireReturn  == true {
            let model = OrderActModel()
            model.orderActStatus = .applyReturn
            model.orderActStr = OrderActStatusEnum.applyReturn.rawValue
            orderActModelArr.append(model)
        }
        if orderModel.CanPay  == true {
            let model = OrderActModel()
            model.orderActStatus = .pay
            model.orderActStr = OrderActStatusEnum.pay.rawValue
            orderActModelArr.append(model)
        }
        
        return orderActModelArr

    }
    
}



