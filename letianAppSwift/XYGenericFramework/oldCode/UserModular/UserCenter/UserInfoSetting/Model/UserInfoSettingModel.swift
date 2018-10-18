//
//  UserInfoSettingModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/27.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserInfoSettingModel: NSObject {
    var avatarUrl:String!
    var nickName:String!
    var account:String!
    var passWord:String!
    var cityModelArr:[UserInfoSettingCityModel] = Array()
    var selectedCityModel:UserInfoSettingCityModel!
    var selectedAreaModel:ChooseAreaCellModel!
    var userName:String!
    //1男，2女
    var userSex:Int = -1
    var userTel:String!
    var userDetailAdress:String!
    var geoHash:String!
    var schoolAdress:String!
    
    /* 获取用户信息用到 */
    //是否绑定了微信
    var hasWechat:Bool!
    
    public class func praseUserInfoSettingData(jsonData:JSON) -> UserInfoSettingModel{
        let model = UserInfoSettingModel()
        model.avatarUrl =  jsonData["data"]["HeadImg"].stringValue//PIC_DOMAIN_URL + "content/images/HeadImg/" + jsonData["data"]["HeadImg"].stringValue
        model.nickName = jsonData["data"]["NickName"].stringValue
        
        for cityModelJson in jsonData["data"]["CityList"].arrayValue {
              let cityModel = UserInfoSettingCityModel()
            cityModel.cityCode = cityModelJson["CityCode"].intValue
            cityModel.cityName = cityModelJson["CityName"].stringValue
            model.cityModelArr.append(cityModel)

        }
        return model
    }
    
    
    //解析获取用户的信息
    public class func praseGetUserInfoData(jsonData:JSON) -> UserInfoSettingModel{
        let model = UserInfoSettingModel()
        model.avatarUrl =  jsonData["data"]["HeadImg"].stringValue//PIC_DOMAIN_URL + "content/images/HeadImg/" + jsonData["data"]["HeadImg"].stringValue
        model.nickName = jsonData["data"]["NickName"].stringValue
        model.selectedCityModel = UserInfoSettingCityModel()
        model.selectedCityModel.cityCode = jsonData["data"]["CityCode"].intValue
        model.selectedAreaModel = ChooseAreaCellModel()
        model.selectedAreaModel.areaCode = jsonData["data"]["AreaCode"].intValue
        model.userName = jsonData["data"]["UserName"].stringValue
        model.userTel = jsonData["data"]["UserPhone"].stringValue
        model.userSex = jsonData["data"]["Sex"].intValue
        model.schoolAdress  = jsonData["data"]["Address"].stringValue
        model.hasWechat = jsonData["data"]["HasWechat"].boolValue
        model.account = jsonData["data"]["Account"].stringValue
        
        for cityModelJson in jsonData["data"]["CityList"].arrayValue {
            let cityModel = UserInfoSettingCityModel()
            cityModel.cityCode = cityModelJson["CityCode"].intValue
            cityModel.cityName = cityModelJson["CityName"].stringValue
            model.cityModelArr.append(cityModel)
            
            if cityModelJson["CityCode"].intValue == model.selectedCityModel.cityCode{
                 model.selectedCityModel.cityName = cityModelJson["CityName"].stringValue
            }
        }
        
        for areaModelJson in jsonData["data"]["AreaList"].arrayValue {
            if areaModelJson["AreaCode"].intValue == model.selectedAreaModel.areaCode{
                model.selectedAreaModel.areaName = areaModelJson["AreaName"].stringValue
                model.selectedAreaModel.expressPoints = areaModelJson["ExpressPoints"].stringValue
            }
        }
        
        return model
    }
}

/*
class UserHasRegisterModel: NSObject {
    var HasRegister:Bool!
    var Location:String!
    var AreaCode:Int!
    var Geohash:String!
    var CityCode:Int!
    
    public class func praseUserHasRegisterData(jsonData:JSON) -> UserHasRegisterModel{
        let model = UserHasRegisterModel()
        model.HasRegister = jsonData["data"]["HasRegister"].boolValue
        model.Location = jsonData["data"]["Location"].stringValue
        model.Geohash = jsonData["data"]["Geohash"].stringValue
        model.CityCode = jsonData["data"]["CityCode"].intValue
        model.AreaCode = jsonData["data"]["AreaCode"].intValue
        return model
    }
    
}
*/

class UserInfoSettingCityModel: NSObject {
    var cityName:String!
    var cityCode:Int!
    
    public class func praseCityData(jsonData:JSON) -> [UserInfoSettingCityModel]{
        var cityModelArr:[UserInfoSettingCityModel] = Array()
        for jsonCellData in jsonData["data"].arrayValue {
            let model = UserInfoSettingCityModel()
            model.cityName = jsonCellData["CityName"].stringValue
            model.cityCode = jsonCellData["CityCode"].intValue
            cityModelArr.append(model)
        }
        return cityModelArr
    }
}


