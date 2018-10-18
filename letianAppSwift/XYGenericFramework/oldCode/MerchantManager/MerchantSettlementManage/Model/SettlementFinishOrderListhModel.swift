//
//  SettlementFinishOrderListhModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
//MARK: - 已完成订单周期统计
class SettlementFinishOrderListModel: NSObject {

    var finishOrderSettlementCellModelArr:[SettlementFinishOrderListCellModel] = Array()
    
    public class func praseSettlementFinishOrderListData(jsonData:JSON) -> SettlementFinishOrderListModel{
        let model = SettlementFinishOrderListModel()
        for cellJson in jsonData["data"].arrayValue {
            let cellModel = SettlementFinishOrderListCellModel.praseSettlementFinishOrderListCellData(jsonData: cellJson)
                model.finishOrderSettlementCellModelArr.append(cellModel)
        }
        return model
    }
    
}


class SettlementFinishOrderListCellModel: NSObject {
    
    var Start:String!
    var End:String!
    var Money:Int!
    var HasJS:Bool!

    
    public class func praseSettlementFinishOrderListCellData(jsonData:JSON) -> SettlementFinishOrderListCellModel{
        let model = SettlementFinishOrderListCellModel()
        model.Start = jsonData["Start"].stringValue
        model.End = jsonData["End"].stringValue
        model.Money = jsonData["Money"].intValue
        model.HasJS = jsonData["HasJS"].boolValue
        return model
    }

    
    
}



class SettlementHomeCellModel: NSObject {
    var functionImage:UIImage!
    var functionStr:String!
}
