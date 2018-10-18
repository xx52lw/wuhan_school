//
//  MerchantCurrentOrderModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/11.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

class MerchantCurrentOrderModel: NSObject {
    
    var FAreaID:Int!
    var FAreaName:String!
    var sectionCellModelArr:[MerchantCurrentOrderCellModel] = Array()
    
    public class func praseMerchantCurrentOrderData(jsonData:JSON) -> MerchantCurrentOrderModel{
        
        let model = MerchantCurrentOrderModel()
        model.FAreaID = jsonData["FAreaID"].intValue
        model.FAreaName = jsonData["FAreaName"].stringValue
        
        for cellJson in jsonData["OrderList"].arrayValue {
            let cellModel = MerchantCurrentOrderCellModel.praseMerchantOrderCellData(jsonData: cellJson)
            model.sectionCellModelArr.append(cellModel)
        }
        
        return model
    }
    
}


class MerchantCurrentOrderCellModel: NSObject {
    
    var UserOrderID:String!
    var DeliveryNo:String!
    var DeliveryType:String!
    var OrderCreateDT:String!
    var LeftSeconds:Int!
    var FAreaID:Int!
    //1:距离预约，2：距离超时
    var TimeShowType:Int!
    
    
    public class func praseMerchantOrderCellData(jsonData:JSON) -> MerchantCurrentOrderCellModel{
        
        let model = MerchantCurrentOrderCellModel()
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.DeliveryNo = jsonData["DeliveryNo"].stringValue
        model.DeliveryType = jsonData["DeliveryType"].stringValue
        model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
        model.LeftSeconds = jsonData["LeftSeconds"].intValue
        model.FAreaID = jsonData["FAreaID"].intValue
        model.TimeShowType  = jsonData["TimeShowType"].intValue
        
        return model
        
    }
}
