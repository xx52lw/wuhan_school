//
//  StaffManageListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class StaffManageListModel: NSObject {

    var usefulStaffModelArr:[StaffManageListCellModel] = Array()
    var unusefulStaffModelArr:[StaffManageListCellModel] = Array()
    
    public class func praseStaffManageListData(jsonData:JSON) -> StaffManageListModel{
        let model = StaffManageListModel()
        
        for cellJson in jsonData["data"].arrayValue {
            let cellModel = StaffManageListCellModel.praseStaffManageListCellData(jsonData: cellJson)
            if cellModel.CanUse == true {
                model.usefulStaffModelArr.append(cellModel)
            }else{
                model.unusefulStaffModelArr.append(cellModel)
            }
        }
        
        return model
    }
}

class StaffManageListCellModel: NSObject {
    var DStaffID:Int!
    var StaffName:String!
    var Phone:String!
    var CanUse:Bool!

    
    
    public class func praseStaffManageListCellData(jsonData:JSON) -> StaffManageListCellModel{
        let model = StaffManageListCellModel()
        
        model.DStaffID = jsonData["DStaffID"].intValue
        model.StaffName = jsonData["StaffName"].stringValue
        model.Phone = jsonData["Phone"].stringValue
        model.CanUse = jsonData["CanUse"].boolValue
        
        return model
    }
    
}
