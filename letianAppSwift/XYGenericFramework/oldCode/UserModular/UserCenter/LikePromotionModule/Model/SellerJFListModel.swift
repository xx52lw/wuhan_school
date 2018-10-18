//
//  SellerJFListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerJFListModel: NSObject {
    var cellModelArr:[SellerJFListCellModel] = Array()
    
    public class func praseSellerJFListData(jsonData:JSON) -> SellerJFListModel{
        
        let model = SellerJFListModel()
        
        for cellJson in jsonData["data"].arrayValue {
            model.cellModelArr.append(SellerJFListCellModel.praseSellerJFListCellData(jsonData: cellJson))
        }
        
        return model
    }
}


class SellerJFListCellModel: NSObject {
    var MerchantID:String!
    var MerchantName:String!
    var JFAmount:Int!
    var JFExchangeAmount:Int!
    var DeliveryLimit:Int!
    var DeliveryFee:Int!
    
    public class func praseSellerJFListCellData(jsonData:JSON) -> SellerJFListCellModel{
        
        let model = SellerJFListCellModel()
        model.MerchantID = jsonData["MerchantID"].stringValue
        model.MerchantName = jsonData["MerchantName"].stringValue
        model.JFAmount = jsonData["JFAmount"].intValue
        model.JFExchangeAmount  = jsonData["JFExchangeAmount"].intValue
        model.DeliveryLimit = jsonData["DeliveryLimit"].intValue
        model.DeliveryFee = jsonData["DeliveryFee"].intValue
        return model
    }
    
}



