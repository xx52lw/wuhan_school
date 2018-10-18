//
//  MerchantOrderCellModels.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantHasReturnedOrderModel: NSObject {

    var Day:String!
    var sectionCellModelArr:[MerchantHasReturnedOrderCellModel] = Array()
    
    public class func praseMerchantHasReturnedOrderData(jsonData:JSON) -> MerchantHasReturnedOrderModel{
        
        let model = MerchantHasReturnedOrderModel()
        model.Day = jsonData["Day"].stringValue
        for cellJson in jsonData["OrderList"].arrayValue {
            let cellModel = MerchantHasReturnedOrderCellModel.praseMerchantOrderCellData(jsonData: cellJson)
            model.sectionCellModelArr.append(cellModel)
        }
        
        return model
    }
    
}


class MerchantHasReturnedOrderCellModel: NSObject {
    
    var DStaffName:String!
    var TDStatus:String!
    var TDDT:String!
    var OrderCreateDT:String!
    var DeliveryNo:String!
    var UserOrderID:String!
    
    
    public class func praseMerchantOrderCellData(jsonData:JSON) -> MerchantHasReturnedOrderCellModel{
        
        let model = MerchantHasReturnedOrderCellModel()
        model.DStaffName = jsonData["DStaffName"].stringValue
        model.TDStatus = jsonData["TDStatus"].stringValue
        model.TDDT = jsonData["TDDT"].stringValue
        model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        
        return model
        
    }
}



