//
//  MerchantSystemSettingModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit



enum MerchantOrderBellSettingEnum:String {
    case userBell = "铃声"
    case unuseBell = "无铃声"
}


enum MerchantOrderVibrateSettingEnum:String {
    case userVibrate = "已开启"
    case unuseVibrate = "已关闭"
}


class MerchantSystemSettingModel: NSObject {

}


//MARK: - 是否开启铃声信息保存
func saveBellSettingInfo(isUserBell:Bool) {
    if isUserBell == true {
        UserDefaults.standard.set("true", forKey: "BellSetting")
    }else{
        UserDefaults.standard.set("false", forKey: "BellSetting")
    }
    
}

//MARK: - 获取是否开启铃声
func isMerchantOrderUseBell() -> Bool {
    
    if let bellSettingInfo = UserDefaults.standard.value(forKey: "BellSetting") as? String {
        
        if bellSettingInfo == "true" {
            return true
        }
        
    }
    return false
}


//MARK: - 是否开启震动信息保存
func saveVibrateSettingInfo(isUseVibrate:Bool) {
    if isUseVibrate == true {
        UserDefaults.standard.set("true", forKey: "VibrateSetting")
    }else{
        UserDefaults.standard.set("false", forKey: "VibrateSetting")
    }
    
}

//MARK: - 获取是否开启震动
func isOrderUseVibrate() -> Bool {
    if let vibrateSettingInfo = UserDefaults.standard.value(forKey: "VibrateSetting") as? String {
        if vibrateSettingInfo == "true" {
            return true
        }
    }
    return false
}
