//
//  StaffSystemSettingModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
enum StaffOrderBellSettingEnum:String {
    case userBell = "铃声"
    case unuseBell = "无铃声"
}


enum StaffOrderVibrateSettingEnum:String {
    case userVibrate = "已开启"
    case unuseVibrate = "已关闭"
}

//MARK: - 是否开启铃声信息保存
func saveStaffBellSettingInfo(isUserBell:Bool) {
    if isUserBell == true {
        UserDefaults.standard.set("true", forKey: "StaffBellSetting")
    }else{
        UserDefaults.standard.set("false", forKey: "StaffBellSetting")
    }
    
}

//MARK: - 获取是否开启铃声
func isStaffOrderUseBell() -> Bool {
    
    if let bellSettingInfo = UserDefaults.standard.value(forKey: "StaffBellSetting") as? String {
        
        if bellSettingInfo == "true" {
            return true
        }
        
    }
    return false
}


//MARK: - 是否开启震动信息保存
func saveStaffVibrateSettingInfo(isUseVibrate:Bool) {
    if isUseVibrate == true {
        UserDefaults.standard.set("true", forKey: "StaffVibrateSetting")
    }else{
        UserDefaults.standard.set("false", forKey: "StaffVibrateSetting")
    }
    
}

//MARK: - 获取是否开启震动
func isStaffOrderUseVibrate() -> Bool {
    if let vibrateSettingInfo = UserDefaults.standard.value(forKey: "StaffVibrateSetting") as? String {
        if vibrateSettingInfo == "true" {
            return true
        }
    }
    return false
}





class StaffInfoModel: NSObject {
    var MerchantName:String!
    var StaffName:String!
    var Phone:String!
    
    public class func parseStaffInfoModelData(jsonData:JSON) -> StaffInfoModel{
        let model = StaffInfoModel()
        model.MerchantName = jsonData["data"]["MerchantName"].stringValue
        model.StaffName = jsonData["data"]["StaffName"].stringValue
        model.Phone = jsonData["data"]["Phone"].stringValue
        return model
}
}

class StaffSystemSettingModel: NSObject {

}
