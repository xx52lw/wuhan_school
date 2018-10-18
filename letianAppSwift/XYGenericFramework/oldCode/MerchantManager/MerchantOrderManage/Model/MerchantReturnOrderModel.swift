//
//  merchantReturnOrderModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantReturnOrderModel: NSObject {
    
    var Day:String!
    var sectionCellModelArr:[MerchantReturnOrderCellModel] = Array()
    
    public class func praseMerchantReturnOrderData(jsonData:JSON) -> MerchantReturnOrderModel{
        
        let model = MerchantReturnOrderModel()
        model.Day = jsonData["Day"].stringValue
        for cellJson in jsonData["OrderList"].arrayValue {
            let cellModel = MerchantReturnOrderCellModel.praseMerchantOrderCellData(jsonData: cellJson)
            model.sectionCellModelArr.append(cellModel)
        }
        
        return model
    }
    
}


class MerchantReturnOrderCellModel: NSObject {
    var UserOrderID:String!
    var DeliveryNo:String!
    var TDDT:String!
    var TDStatus:String!
    var LeftTimeDes:String!
    var OrderStatus:String!
    var OrderCreateDT:String!

    
    public class func praseMerchantOrderCellData(jsonData:JSON) -> MerchantReturnOrderCellModel{
        
        let model = MerchantReturnOrderCellModel()
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.TDDT = jsonData["TDDT"].stringValue
        model.TDStatus = jsonData["TDStatus"].stringValue
        model.LeftTimeDes = jsonData["LeftTimeDes"].stringValue
        model.OrderStatus = jsonData["OrderStatus"].stringValue
        model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
        
        return model
        
    }
}


