//
//  MerchantManagerHomepageModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantManagerHomepageModel: NSObject {
    var OpenStatus:Bool!
    var Money:Int!
    var HasNewMS:Bool!
    var MerchantName:String!
    
    public class func praseMerchantManagerHomeData(jsonData:JSON) -> MerchantManagerHomepageModel{
        let model = MerchantManagerHomepageModel()
        model.OpenStatus = jsonData["data"]["OpenStatus"].boolValue
        model.MerchantName = jsonData["data"]["MerchantName"].stringValue
        model.Money = jsonData["data"]["Money"].intValue
        model.HasNewMS = jsonData["data"]["HasNewMS"].boolValue
        return model
    }

}
