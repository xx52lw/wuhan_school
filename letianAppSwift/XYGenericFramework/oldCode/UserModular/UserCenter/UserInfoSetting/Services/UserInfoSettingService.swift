//
//  UserInfoSettingService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/27.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserInfoSettingService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    
    
    //MARK: - 获取城市信息列表
    func cityDataRequest(target: UIViewController,successAct:@escaping ([UserInfoSettingCityModel])->Void){
        requestTool.getRequstNoToken(target: target, url:getCitiesUrl , params: nil, isShowWaiting: true, success: { (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                let areaModelArr =  UserInfoSettingCityModel.praseCityData(jsonData: jsonResponse)
                successAct(areaModelArr)
            }
            
        }) {  (erroModel) in
            if netWorkIsReachable == true{
                cmShowHUDToWindow(message:"获取服务城市信息失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 通过城市请求区域
    func areaRequestBycity(target: UIViewController,cityCode:Int){
        if let chooseAreaVC  = target as? ChooseAreaVC {
            requestTool.getRequstNoToken(target: target, url:getAreaInfoUrl + "/\(cityCode)" , params: nil, isShowWaiting: true, success: { [ weak chooseAreaVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let areaModel =  ChooseAreaModel.praseChooseAreaData(jsonData: jsonResponse)
                    
                    chooseAreaVC?.chooseAreaModel = areaModel
                    chooseAreaVC?.cityDataManage()

                    DispatchQueue.main.async {
                        if chooseAreaVC?.mainTableView == nil {
                            chooseAreaVC?.creatTableView()
                        }else{
                           chooseAreaVC?.mainTableView.reloadData()
                        }
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
    
    

    
    /*
    //MARK: - 查看用户是否注册
    func userIsRegisteredRequest(successAct:@escaping (UserHasRegisterModel)->Void,failureAct:@escaping ()->Void) {
            requestTool.getRequest(target: nil, url:userHasRegisterUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let hasRegisterModel =  UserHasRegisterModel.praseUserHasRegisterData(jsonData: jsonResponse)
                    successAct(hasRegisterModel)
                }
                
            }) {  (erroModel) in
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
                failureAct()
            }
        }
    */
    //MARK: - 请求用户的信息
    func getUserSettingInfoRequest(successAct:@escaping (UserInfoSettingModel)->Void,failureAct:@escaping ()->Void) {
        requestTool.getRequest(target: nil, url:getUserAllInfoUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                let userSettingInfoModel =  UserInfoSettingModel.praseGetUserInfoData(jsonData: jsonResponse)
                successAct(userSettingInfoModel)
            }
            
        }) {  (erroModel) in
            if netWorkIsReachable == true{
                cmShowHUDToWindow(message:DATA_ERROR_TIPS)
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
            failureAct()
        }
    }
    
    
    
    

    
}
