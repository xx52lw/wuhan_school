//
//  SettlementFinishDayDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

//日结算订单详情列表
class SettlementFinishDayDetailModel: NSObject {

    var Day:String!
    var Money:Int!
    var finishDayDetailCellModelArr:[SettlementFinishDayDetailListCellModel] = Array()
    
    public class func praseSettlementFinishDayDetailData(jsonData:JSON) -> SettlementFinishDayDetailModel{
        let model = SettlementFinishDayDetailModel()
        model.Day = jsonData["data"]["Day"].stringValue
        model.Money = jsonData["data"]["Money"].intValue
        
        for cellJson in jsonData["data"]["OrderList"].arrayValue {
            let cellModel = SettlementFinishDayDetailListCellModel.praseSettlementFinishDayDetailListCellData(jsonData: cellJson)
            model.finishDayDetailCellModelArr.append(cellModel)
        }
        return model
    }
    
}


class SettlementFinishDayDetailListCellModel: NSObject {
    
    var UserOrderID:String!
    var PayAmount:Int!
    
    
    public class func praseSettlementFinishDayDetailListCellData(jsonData:JSON) -> SettlementFinishDayDetailListCellModel{
        let model = SettlementFinishDayDetailListCellModel()
        model.UserOrderID = jsonData["UserOrderID"].stringValue
        model.PayAmount = jsonData["PayAmount"].intValue
        return model
    }
    
    
    
}
