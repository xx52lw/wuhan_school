//
//  CollectionListModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class CollectionListModel: NSObject {
    var cellModelArr:[CollectionListCellModel] = Array()
    
    public class func praseCollectionListData(jsonData:JSON) -> CollectionListModel{
        
        let model = CollectionListModel()
        
        for cellJson in jsonData["data"].arrayValue {
            model.cellModelArr.append(CollectionListCellModel.praseCollectionListCellData(jsonData: cellJson))
        }
        
        return model
    }
}





class CollectionListCellModel: NSObject {
    var UserFavoriteID:String!
    var MerchantName:String!
    var Logo:String!
    var DeliveryLimit:Int!
    var DeliveryFee:Int!
    var MerchantID:String!
    
    public class func praseCollectionListCellData(jsonData:JSON) -> CollectionListCellModel{
        
        let model = CollectionListCellModel()
        model.UserFavoriteID = jsonData["UserFavoriteID"].stringValue
        model.MerchantName = jsonData["MerchantName"].stringValue
        model.Logo = jsonData["Logo"].stringValue
        model.DeliveryLimit = jsonData["DeliveryLimit"].intValue
        model.DeliveryFee = jsonData["DeliveryFee"].intValue
        model.MerchantID = jsonData["MerchantID"].stringValue
        return model
    }
    
}
