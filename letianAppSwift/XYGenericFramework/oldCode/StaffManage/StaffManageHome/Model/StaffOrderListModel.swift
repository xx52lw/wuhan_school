//
//  StaffOrderListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
enum StaffOrderRequestTypeEnum {
    case waiteToDelivery //配送中
    case hasDeliveried //已送达
    case none
}

class StaffOrderManageRequstTypeModel: NSObject {
    
    var requestTypeUrl:String!
    var typeName:String!
    var requestType:StaffOrderRequestTypeEnum = .none
    
}

class StaffOrderListModel: NSObject {
    
    var orderSectionModelArr:[StaffOrderSectionListModel] = Array()
    var requestType:StaffOrderRequestTypeEnum!
    
    public class func praseStaffOrderListData(jsonData:JSON,requestType: StaffOrderRequestTypeEnum) -> StaffOrderListModel{
        
        let model = StaffOrderListModel()
        model.requestType = requestType
        for sectionJson in jsonData["data"].arrayValue {
            let sectionModel = StaffOrderSectionListModel.praseStaffOrderSectionListData(jsonData: sectionJson)
            model.orderSectionModelArr.append(sectionModel)
        }
        return model
        
    }
}


class StaffOrderSectionListModel: NSObject {
    var FAreaName:String!
    var orderCellModelArr:[StaffOrderListCellModel] = Array()

    public class func praseStaffOrderSectionListData(jsonData:JSON) -> StaffOrderSectionListModel{
        
        let model = StaffOrderSectionListModel()
        
        model.FAreaName = jsonData["Day"].stringValue
        if model.FAreaName.isEmpty {
            model.FAreaName = jsonData["FAreaName"].stringValue
        }
        
        for sectionJson in jsonData["OrderList"].arrayValue {
            let sectionModel = StaffOrderListCellModel.praseStaffOrderListCellData(jsonData: sectionJson)
            model.orderCellModelArr.append(sectionModel)
        }
        
        return model
        
    }
}




class StaffOrderListCellModel: NSObject{
        var UserOrderID:String!
        var DeliveryNo:String!
        var OrderCreateDT:String!
        var LeftSeconds:Int!
        //展示时长方式
        var TimeShowType:Int!
        var UseTime:Int!
        var HasArrive:Bool!
        var ArriveStatus:String!
        var Address:String!
        var ReceiverName:String!
        var RecieverPhone:String!
        var FAreaID:Int!
    var DeliveryType:String!

        public class func praseStaffOrderListCellData(jsonData:JSON) -> StaffOrderListCellModel{
            
            let model = StaffOrderListCellModel()
         
            model.UserOrderID = jsonData["UserOrderID"].stringValue
            model.DeliveryNo = jsonData["DeliveryNo"].stringValue
            model.OrderCreateDT = jsonData["OrderCreateDT"].stringValue
            model.LeftSeconds = jsonData["LeftSeconds"].intValue
            model.UseTime = jsonData["UseTime"].intValue
            model.HasArrive = jsonData["HasArrive"].boolValue
            model.ArriveStatus = jsonData["ArriveStatus"].stringValue
            model.Address = jsonData["Address"].stringValue
            model.ReceiverName = jsonData["ReceiverName"].stringValue
            model.RecieverPhone = jsonData["RecieverPhone"].stringValue
            model.FAreaID = jsonData["FAreaID"].intValue
            model.TimeShowType = jsonData["TimeShowType"].intValue
            model.DeliveryType = jsonData["DeliveryType"].stringValue
            return model
        }
        
        
    
    
}




