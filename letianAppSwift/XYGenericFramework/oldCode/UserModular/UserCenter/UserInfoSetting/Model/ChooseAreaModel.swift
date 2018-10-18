//
//  ChooseAreaAndCityModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/28.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChooseAreaModel: NSObject {
    var areaModelArr:[ChooseAreaCellModel] = Array()

    
    public class func praseChooseAreaData(jsonData:JSON) -> ChooseAreaModel{
        let model = ChooseAreaModel()

        
        for areaModelJson in jsonData["data"].arrayValue {
            let areaModel = ChooseAreaCellModel()
            areaModel.areaCode = areaModelJson["AreaCode"].intValue
            areaModel.areaName = areaModelJson["AreaName"].stringValue
            areaModel.expressPoints = areaModelJson["ExpressPoints"].stringValue
            model.areaModelArr.append(areaModel)
        }
        return model
    }

    
}


class ChooseAreaCellModel: NSObject {
    var areaName:String!
    var areaCode:Int!
    //地图上多边形顶点
    var expressPoints:String!
}
