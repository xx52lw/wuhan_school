//
//  MerchantDeliveringOrderModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantDeliveringOrderModel: NSObject {

    var Day:String!
    var sectionCellModelArr:[MerchantDeliveringOrderCellModel] = Array()
    
    public class func praseMerchantDeliveringOrderData(jsonData:JSON) -> MerchantDeliveringOrderModel{
        
        let model = MerchantDeliveringOrderModel()
        model.Day = jsonData["Day"].stringValue
        for cellJson in jsonData["OrderList"].arrayValue {
            let cellModel = MerchantDeliveringOrderCellModel.praseMerchantOrderCellData(jsonData: cellJson)
            model.sectionCellModelArr.append(cellModel)
        }
        
        return model
    }
    
}


class MerchantDeliveringOrderCellModel: NSObject {
    var UserOrderID:String!
    var DeliveryNo:String!
    var OrderCreateDT:String!
    var LeftSeconds:Int!
    var DStaffName:String!
    var Status:String!
    var TimeShowType:Int!
    
    
    public class func praseMerchantOrderCellData(jsonData:JSON) -> MerchantDeliveringOrderCellModel{
        
        let model = MerchantDeliveringOrderCellModel()
        model.DStaffName = jsonData["DStaffName"].stringValue
        model.Status = jsonData["Status"].stringValue
        model.LeftSeconds = jsonData["LeftSeconds"].intValue
        model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.TimeShowType = jsonData["TimeShowType"].intValue
        return model
        
    }
}
