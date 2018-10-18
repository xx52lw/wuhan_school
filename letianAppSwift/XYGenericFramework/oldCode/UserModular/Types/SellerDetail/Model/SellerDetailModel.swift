//
//  SellerDetailModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerDetailModel: NSObject {
    var sellerTips:String!
    var sellerTel:String!
    var telOne:String!
    var telTwo:String!
    var sellerAdress:String!
    var AddressGeohash:String!
    //var sellerDeliveryTime:String!
    var sellerDeliveryType:String!
    var qualificationImageUrlArr:[String] = Array()
    var environmentImageUrlArr:[String] = Array()
    
    
    
    public class func praseSellerDetailData(jsonData:JSON) -> SellerDetailModel{
        
        let model = SellerDetailModel()
        
        model.sellerTips = "无"
        model.telOne  = jsonData["data"]["TelOne"].stringValue
        model.telTwo = jsonData["data"]["TelTwo"].stringValue
        model.AddressGeohash = jsonData["data"]["AddressGeohash"].stringValue
        
        if !model.telOne.isEmpty && !model.telTwo.isEmpty{
            model.sellerTel = model.telOne + " 、" + model.telTwo
        }else if !model.telOne.isEmpty {
            model.sellerTel = model.telOne
        }else if !model.telTwo.isEmpty {
            model.sellerTel = model.telTwo
        }else{
            model.sellerTel =  "无"
        }
        
        model.sellerAdress = jsonData["data"]["MAddress"].stringValue
        if jsonData["data"]["ExpressWayType"].intValue == 2{
            model.sellerDeliveryType = "商家配送"
        }else if jsonData["data"]["ExpressWayType"].intValue == 1{
           model.sellerDeliveryType = "校园众包"
        }else {
            model.sellerDeliveryType = "无"
        }
        
        
        for tempUrlStr in jsonData["data"]["Qualification"].stringValue.components(separatedBy: "-") {
            let qualificationImageUrlStr = tempUrlStr//PIC_DOMAIN_URL + "content/images/Qualif/" + tempUrlStr
            model.qualificationImageUrlArr.append(qualificationImageUrlStr)
        }
        
        for tempUrlStr in jsonData["data"]["Picture"].stringValue.components(separatedBy: "-") {
            let environmentUrlStr = tempUrlStr//PIC_DOMAIN_URL + "content/images/MPic/" + tempUrlStr
            model.environmentImageUrlArr.append(environmentUrlStr)
        }
        
        
        return model
    }
}
