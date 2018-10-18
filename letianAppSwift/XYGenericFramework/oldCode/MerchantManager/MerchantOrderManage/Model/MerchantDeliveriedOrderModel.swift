//
//  MerchantDeliveriedOrderModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantDeliveriedOrderModel: NSObject {
    
    var Day:String!
    var sectionCellModelArr:[MerchantDeliveriedOrderCellModel] = Array()
    
    public class func praseMerchantDeliveriedOrderData(jsonData:JSON) -> MerchantDeliveriedOrderModel{
        
        let model = MerchantDeliveriedOrderModel()
        model.Day = jsonData["Day"].stringValue
        for cellJson in jsonData["OrderList"].arrayValue {
            let cellModel = MerchantDeliveriedOrderCellModel.praseMerchantOrderCellData(jsonData: cellJson)
            model.sectionCellModelArr.append(cellModel)
        }
        
        return model
    }
    
}


class MerchantDeliveriedOrderCellModel: NSObject {
    var UserOrderID:String!
    var DeliveryNo:String!
    var OrderCreateDT:String!
    var DeliveryUseTime:Int!
    var ArriveStatus:String!
    var DStaffName:String!
    
    
    public class func praseMerchantOrderCellData(jsonData:JSON) -> MerchantDeliveriedOrderCellModel{
        
        let model = MerchantDeliveriedOrderCellModel()
        model.DStaffName = jsonData["DStaffName"].stringValue
        model.ArriveStatus = jsonData["ArriveStatus"].stringValue
        model.DeliveryUseTime = jsonData["DeliveryUseTime"].intValue
        model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        
        return model
        
    }
}

