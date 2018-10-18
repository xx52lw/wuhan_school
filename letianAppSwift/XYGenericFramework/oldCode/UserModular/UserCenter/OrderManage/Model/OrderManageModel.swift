//
//  OrderManageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

enum OrderActStatusEnum:String {
    //默认无状态
    case none = ""
    //待支付
    case cancel = "取消订单"
    //删除订单
    case delete = "删除订单"
    //申请退款
    case applyRefund = "申请退款"
    //申请客服介入
    case applyCustomerService = "申请客服介入"
    //去支付
    case pay = "去支付"
    //申请退单
    case applyReturn = "申请退单"

    
}

class OrderManageModel: NSObject {
    
    var allOrderCellModelArr:[OrderManageCellModel] = Array()
    var hasNextPage:Bool!
    
    public class func praseOrderManageData(jsonData:JSON) -> OrderManageModel{
        
        let model = OrderManageModel()
        model.hasNextPage = jsonData["data"]["HasMore"].boolValue
        
        for cellJson in jsonData["data"]["OrderList"].arrayValue {
            let cellModel = OrderManageCellModel.praseOrderManageCellData(jsonData: cellJson)
            model.allOrderCellModelArr.append(cellModel)
        }
        
        return model
        
    }

    
    public class func testData() -> OrderManageModel{
        
        let model = OrderManageModel()
        
        for index in 0..<10 {
            let cellModel = OrderManageCellModel.testData()
            model.allOrderCellModelArr.append(cellModel)
        }
        
        return model
        
    }
    
    
}


class OrderManageCellModel: NSObject {
    
    var sellerAvatarUrl:String!
    var sellerName:String!
    var orderTime:String!
    var totalGoods:String!
    var totalMoney:Int!
    var goodsNum:Int!
    var UserOrderID:String!
    var DeliveryNo:String!
    
    //是否可以支付
    var CanPay:Bool!
    var CanComment:Bool!
    var CanDelete:Bool!
    
    //当前商品的财务信息
    var FinanceStatus:String!
    var statusStr:String!
    
    public class func praseOrderManageCellData(jsonData:JSON) -> OrderManageCellModel{
        
        let model = OrderManageCellModel()

        model.sellerAvatarUrl = jsonData["Logo"].stringValue//PIC_DOMAIN_URL + "Content/images/Logo/" +  jsonData["Logo"].stringValue
        model.totalMoney = jsonData["TotalAmount"].intValue
        model.sellerName = jsonData["MerchantName"].stringValue
        model.goodsNum = jsonData["GoodsNum"].intValue
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.CanPay = jsonData["CanPay"].boolValue
        model.CanComment = jsonData["CanComment"].boolValue
        model.CanDelete = jsonData["CanDelete"].boolValue
        model.FinanceStatus = jsonData["FinanceStatus"].stringValue
        model.statusStr = jsonData["Status"].stringValue
        
            model.orderTime = "下单时间: " + timeStrFormate(timeStr: jsonData["OrderCreateDT"].stringValue)
        

            model.totalGoods = "共计" + String(model.goodsNum) + "件商品 " + model.FinanceStatus
        
        
        

        return model
        
    }
    
    
    
    public class func testData() -> OrderManageCellModel{
        
        let model = OrderManageCellModel()
        model.sellerAvatarUrl = "这是一个哈哈-中杯"
        model.totalMoney = 1550
        model.sellerName = "测试数据测试数据测试数据测试数据测试数据测试数据测试数据"
        model.orderTime = "退单时间: " + "2017-11-11 16:25:36"
        model.statusStr = "已退款"
        model.totalGoods = "共计" + "5" + "件商品 " + "待支付"

        
        
        
        
        return model
        
    }
    
}


enum orderRequestTypeEnum {
    case allOrders
    case waitPay
    case waitRecieve
    case waiteEvaluate
    case refund
    case none
}

class OrderManageRequstTypeModel: NSObject {

    var requestTypeUrl:String!
    var typeName:String!
    var requestType:orderRequestTypeEnum = .none

}



