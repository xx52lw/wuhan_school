//
//  SettlementFinishDayListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
//日结算
class SettlementFinishDayListModel: NSObject {

    var finishDaySettlementCellModelArr:[SettlementFinishDayListCellModel] = Array()
    
    public class func praseSettlementFinishDayListData(jsonData:JSON) -> SettlementFinishDayListModel{
        let model = SettlementFinishDayListModel()
        for cellJson in jsonData["data"].arrayValue {
            let cellModel = SettlementFinishDayListCellModel.praseSettlementFinishDayListCellData(jsonData: cellJson)
            model.finishDaySettlementCellModelArr.append(cellModel)
        }
        return model
    }
    
}


class SettlementFinishDayListCellModel: NSObject {
    
    var Day:String!
    var Money:Int!
    var HasJS:Bool!
    
    
    public class func praseSettlementFinishDayListCellData(jsonData:JSON) -> SettlementFinishDayListCellModel{
        let model = SettlementFinishDayListCellModel()
        model.Day = jsonData["Day"].stringValue
        model.Money = jsonData["Money"].intValue
        model.HasJS = jsonData["HasJS"].boolValue
        return model
    }
    
    
    
}
