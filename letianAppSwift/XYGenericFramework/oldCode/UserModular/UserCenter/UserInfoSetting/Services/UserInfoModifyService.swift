//
//  UserInfoModifyService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/7.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserInfoModifyService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    
    //MARK: - 请求用户所有信息
    func userInfoRequest(target: UIViewController){
        if let accountInfoVC  = target as? UserAccountInfoVC {
            
            requestTool.getRequest(target: target, url:getUserAllInfoUrl , params: nil, isShowWaiting: true, success: { [ weak accountInfoVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let userSettingModel =  UserInfoSettingModel.praseGetUserInfoData(jsonData: jsonResponse)
                    
                    accountInfoVC?.settingInfoModel = userSettingModel
                    saveLoginInfo(model: userSettingModel)
                    DispatchQueue.main.async {
                        accountInfoVC?.refreshSubviewsUI()
                    }
                }
                
            }) {  (erroModel) in
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
        }
    }
    
    
    //MARK: - 更新用户名
    func updateUserNickNameRequest(nickName:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeName = nickName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = nickNameModifyUrl + "/" + encodeName!
        requestTool.postRequest(target: nil, url:urlPrameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    if   erroJson["code"].stringValue == requestCode5 {
                        cmShowHUDToWindow(message:"用户名只能修改一次")
                        return
                    }
                }
                
                cmShowHUDToWindow(message:"更新失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 更新账户设置
    func updateUserAccountRequest(userName:String,gender:Int,userTel:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserName"] = userName
        paramsDict["UserPhone"] = userTel
        paramsDict["Sex"] = gender
        requestTool.postRequest(target: nil, url:accountInfoModifyUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            if netWorkIsReachable == true{
                cmShowHUDToWindow(message:"更新失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
            failureAct()
        }
    }
    
    //MARK: - 更新密码
    func updatePassWordRequest(paramsDict:Dictionary<String,Any>,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        requestTool.postRequest(target: nil, url:resetPasswordUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            
            failureAct()
            
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    if   erroJson["code"].stringValue == passwordErroCode22 {
                        cmShowHUDToWindow(message:erroJson["msg"].stringValue)
                        return
                    }
                }
                cmShowHUDToWindow(message:"更新失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }

    //MARK: - 更新区域信息
    func updateAreaRequest(paramsDict:Dictionary<String,Any>,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        requestTool.postRequest(target: nil, url:resetAreaUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            
            failureAct()
            
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    if   erroJson["code"].stringValue == requestCode3 {
                        cmShowHUDToWindow(message:"找不到数据,请重新选择")
                        return
                    }
                }
                cmShowHUDToWindow(message:"更新失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
}
