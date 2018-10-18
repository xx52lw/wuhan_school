//
//  MerchantOrderManageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MerchantOrderRequestTypeEnum {
    case current //实时订单
    case delivering //配送中
    case hasDeliveried //已送达
    case returnOrder //退单
    case hasReturned //已退单
    case none
}

class MerchantOrderManageModel: NSObject {
    
    var allOrderSectionModelArr:[Any] = Array()
    var requestType:MerchantOrderRequestTypeEnum!
    
    public class func praseMerchantOrderManageData(jsonData:JSON,requestType:MerchantOrderRequestTypeEnum) -> MerchantOrderManageModel{
        
        let model = MerchantOrderManageModel()
        model.requestType = requestType
        
        switch  requestType{
        case .current:
            for sectionJson in jsonData["data"].arrayValue {
                let sectionModel = MerchantCurrentOrderModel.praseMerchantCurrentOrderData(jsonData: sectionJson)
                model.allOrderSectionModelArr.append(sectionModel)
            }
            break
        case .delivering:
            for sectionJson in jsonData["data"].arrayValue {
                let sectionModel = MerchantDeliveringOrderModel.praseMerchantDeliveringOrderData(jsonData: sectionJson)
                model.allOrderSectionModelArr.append(sectionModel)
            }
            break
        case .hasDeliveried:
            for sectionJson in jsonData["data"].arrayValue {
                let sectionModel = MerchantDeliveriedOrderModel.praseMerchantDeliveriedOrderData(jsonData: sectionJson)
                model.allOrderSectionModelArr.append(sectionModel)
            }
        case .returnOrder:
            for sectionJson in jsonData["data"].arrayValue {
                let sectionModel = MerchantReturnOrderModel.praseMerchantReturnOrderData(jsonData: sectionJson)
                model.allOrderSectionModelArr.append(sectionModel)
            }
        case .hasReturned:
            for sectionJson in jsonData["data"].arrayValue {
                let sectionModel = MerchantHasReturnedOrderModel.praseMerchantHasReturnedOrderData(jsonData: sectionJson)
                model.allOrderSectionModelArr.append(sectionModel)
            }
            break
        default:
            break
        }
        

        
        return model
        
    }
    
    
    
    
}






class MerchantOrderManageRequstTypeModel: NSObject {
    
    var requestTypeUrl:String!
    var typeName:String!
    var requestType:MerchantOrderRequestTypeEnum = .none
    
}
