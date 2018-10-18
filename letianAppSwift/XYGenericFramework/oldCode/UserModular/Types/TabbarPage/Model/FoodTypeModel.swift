//
//  FoodTypeModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/12/6.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class FoodTypeModel: NSObject {
    

    var FoodTypeModelArr:[Dictionary<String,[FoodSecondTypeModel]>] = Array()

    
    
}



class FoodFirstTypeModel: NSObject {

    var goodsFCatID:Int!
    var goodsFCatStr:String!
    
    
    public class func praseFoodFirstTypeData(jsonData:JSON) -> FoodFirstTypeModel{
        
        let model = FoodFirstTypeModel()
        model.goodsFCatID = jsonData["GoodsFCatID"].intValue
        model.goodsFCatStr  = jsonData["CatName"].stringValue
        return model
        
    }
    
    
    
}

class FoodSecondTypeModel: NSObject {
    
    var goodsSCatID:Int!
    var goodsSCatStr:String!
    
    public class func praseFoodSecondTypeData(jsonData:JSON) -> FoodSecondTypeModel{
        
        let model = FoodSecondTypeModel()
        model.goodsSCatID = jsonData["GoodsSCatID"].intValue
        model.goodsSCatStr  = jsonData["CatName"].stringValue
        return model
        
    }
    
    
}
