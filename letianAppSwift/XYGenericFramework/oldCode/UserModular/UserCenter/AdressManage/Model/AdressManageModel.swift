//
//  AdressManageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class AdressManageModel: NSObject {

    var adressCellModelArr:[AdressManageCellModel] = Array()
    
    public class func praseDeliveryAdressManageData(jsonData:JSON) -> AdressManageModel{
        
        let model = AdressManageModel()
        
        for cellJson in jsonData["data"].arrayValue {
            
            model.adressCellModelArr.append(AdressManageCellModel.praseOrderManageCellData(jsonData: cellJson))
        }
        return model
    }
    
    
}



class AdressManageCellModel: NSObject {
    
    var userName:String!
    var userGender:Int!
    var ueserTel:String!
    var userAdress:String!
    var addressDetail:String = ""
    var userAddressID:String!
    var addressGeohash:String!
    var isselected:Bool = false
    
    
    public class func praseOrderManageCellData(jsonData:JSON) -> AdressManageCellModel{
        
        let model = AdressManageCellModel()
        model.userName = jsonData["UserName"].stringValue
        model.userGender = jsonData["Sex"].intValue
        model.ueserTel = jsonData["PhoneNumber"].stringValue
        model.userAdress = jsonData["Address"].stringValue
        model.addressDetail = jsonData["AddressDetail"].stringValue
        model.userAddressID = jsonData["UserAddressID"].stringValue
        model.addressGeohash = jsonData["AddressGeohash"].stringValue
        
        return model
        
        
        
    }
    
}
