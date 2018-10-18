//
//  LoginRegisterService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

//是否是绑定微信
var clickWechatIsBinding = false

class LoginRegisterService: NSObject {
    
    
    

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    
    //MARK: - 注册
    func userRegisterRequest(target: UIViewController) {
        if let registerVC  = target as? RegisterViewController {
            var paramsDict: [String: Any] = Dictionary()
            paramsDict["AreaCode"] = registerVC.settingInfoModel.selectedAreaModel.areaCode
            paramsDict["Account"] = registerVC.settingInfoModel.account
            paramsDict["NickName"] = registerVC.settingInfoModel.nickName
            paramsDict["Password"] = registerVC.settingInfoModel.passWord
            //paramsDict["Address"] = registerVC.settingInfoModel.schoolAdress
            //paramsDict["Geohash"] = registerVC.settingInfoModel.geoHash
            paramsDict["Sex"] = registerVC.settingInfoModel.userSex
            paramsDict["UserName"] = registerVC.settingInfoModel.userName
            paramsDict["UserPhone"] = registerVC.settingInfoModel.userTel
            
            requestTool.postRequestNoToken(target: target, url: userRegisterUrl, params: paramsDict, isShowWaiting: true, success: { [ weak registerVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if jsonResponse["code"].stringValue == requestSuccessCode {
                        DispatchQueue.main.async {
                            
                            //跳转绑定页面
                            let bindingWeiXinVC = BindingWechatViewController()
                            bindingWeiXinVC.account = registerVC!.settingInfoModel.account
                            bindingWeiXinVC.password = registerVC!.settingInfoModel.passWord
                            registerVC?.navigationController?.pushViewController(bindingWeiXinVC, animated: true)
                        }
                    }
                }
                
            }) {  (erroModel) in
                if netWorkIsReachable == true{
                    if let erroJson = erroModel.response as? JSON {
                        netWorkRequestAct(erroJson)
                        return
                    }
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
        }
    }

    
    
    //MARK: - 获取用户角色
    func getUserRoleRequest(successAct:@escaping (UserRoleEnum)->Void,failureAct:@escaping ()->Void) {

        requestTool.getRequest(target: nil, url: getUserRoleUrl, params: nil, isShowWaiting: true, success: { (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                saveUserRoleInfo(roleStr: jsonResponse["data"]["role"].stringValue)
                successAct(getUserRole())
                
            }
        }) { (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:DATA_ERROR_TIPS)
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
        
    }
    
    
    
    
    //MARK: - 直接用账号登录
    func loginByAccount(account:String,passWord:String,loginSuccessAct:@escaping ()->Void,failure:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["grant_type"] = "password"
        paramsDict["username"] = account
        paramsDict["password"] = passWord
        
        
        
        requestTool.postRequstNoTokenAndCode(target: GetCurrentViewController(), url: loginGetTokenUrl, params: paramsDict, isShowWaiting: true, success: { (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                    cmDebugPrint("获取到token")
                    if !jsonResponse["access_token"].stringValue.isEmpty {
                        saveToken(tokenStr: jsonResponse["access_token"].stringValue)
                        resetNetManagerToken()
                        //先获取用户角色
                        self.getUserRoleRequest(successAct: { (userRole) in
                            switch userRole {
                            case .ExpressManager:
                                break
                            case .Guest:
                                loginSuccessAct()
                                break
                            case .Merchant:
                                DispatchQueue.main.async {
                                    let merchantHomepagevc = MerchantManagerHomepageVC()
                                    GetCurrentViewController()?.navigationController?.pushViewController(merchantHomepagevc, animated: true)
                                }
                                break
                            case .MerchantDeliver:
                                DispatchQueue.main.async {
                                    let staffHomepagevc = StaffOrderListVC()
                                    GetCurrentViewController()?.navigationController?.pushViewController(staffHomepagevc, animated: true)
                                }
                                break
                            case .User:
                                //获取用户信息
                                UserInfoSettingService().getUserSettingInfoRequest(successAct: { (userInfoModel) in
                                    //保存用户信息
                                    saveLoginInfo(model: userInfoModel)
                                    //执行登录成功后回调
                                    loginSuccessAct()
                                }, failureAct: {
                                    
                                })
                                break
                            case .UserDeliver:
                                break
                            case .none:
                                break
                            }
                        }, failureAct: {
                            
                        })
                        
                        

                        
                        
                        


                    }
                
            }
            
        }) {  (erroModel) in
            failure()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"用户名或密码不正确")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
        
        
    }
    
    
    
    //MARK: - 绑定微信流程
    func bindingWechat(account:String,passWord:String) {
        
        self.loginByAccount(account: account, passWord: passWord, loginSuccessAct: {
            clickWechatIsBinding = true
            //调起微信
            ltWechatAuth()
        }) {
            
        }
    }
    
    //MARK: - 不绑定微信
    func cancelBindingWechat(account:String,passWord:String) {
        
        self.loginByAccount(account: account, passWord: passWord, loginSuccessAct: {
            
            //如果是从首页进入，并注册后未绑定的，直接登录并刷新首页数据
                if let rootVC = GetCurrentViewController()?.navigationController?.viewControllers.first as? TakeOutFoodVC {
                    rootVC.service.takefoodOutDataRequest(target: rootVC)
                }
                GetCurrentViewController()?.navigationController?.popToRootViewController(animated: true)
            
        }) {
            
        }
    }
    
    
    //MARK: - 开始绑定微信
    func bindingWeixinRequest(code:String){
        requestTool.postRequest(target: nil, url: bindingWechatUrl + "/" + code, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                cmShowHUDToWindow(message: "绑定成功")
                let navVCCount = GetCurrentViewController()!.navigationController!.viewControllers.count
                
                //如果是从首页进入，并注册后绑定的，绑定成功后刷新首页数据
                if navVCCount >= 4 {

                    if let needVC = GetCurrentViewController()?.navigationController?.viewControllers[navVCCount - 4] as? TakeOutFoodVC {
                        needVC.service.takefoodOutDataRequest(target: needVC)
                        GetCurrentViewController()?.navigationController?.popToViewController((GetCurrentViewController()?.navigationController?.viewControllers[navVCCount - 4])!, animated: true)
                    }
                    
                }
                //如果是在用户信息设置当中点击的绑定微信
                if let currentVC = GetCurrentViewController() as? UserAccountInfoVC {
                    currentVC.service.userInfoRequest(target: currentVC)
                }else{
                    if getUserRole() == .User {
                        if let rootVC = GetCurrentViewController()?.navigationController?.viewControllers.first as? TakeOutFoodVC {
                            rootVC.service.takefoodOutDataRequest(target: rootVC)
                        }
                        GetCurrentViewController()?.navigationController?.popToRootViewController(animated: true)
                    }

                }

                
            }
        }) {  (erroModel) in
            cmDebugPrint(erroModel.response)
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    if   erroJson["code"].stringValue == wechatHasBeBinded21 {
                        cmShowHUDToWindow(message:erroJson["msg"].stringValue)
                        return
                    }
                }
                cmShowHUDToWindow(message:"绑定失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 通过微信获得token(绑定微信后通过微信登录)
    func getTokenDataFromWxLogin(code:String){
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["grant_type"] = "password"
        paramsDict["username"] = "wechat"
        paramsDict["password"] = code
        
        requestTool.postRequstNoTokenAndCode(target: nil, url: loginGetTokenUrl, params: paramsDict, isShowWaiting: true, success: { (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                cmDebugPrint("获取到token")
                if !jsonResponse["access_token"].stringValue.isEmpty {
                    saveToken(tokenStr: jsonResponse["access_token"].stringValue)
                    resetNetManagerToken()
                    saveUserRoleInfo(roleStr: "User")
                    UserInfoSettingService().getUserSettingInfoRequest(successAct: { (userInfoModel) in
                        //保存用户信息
                        saveLoginInfo(model:userInfoModel)
                        let navCount = GetCurrentViewController()!.navigationController!.viewControllers.count
                        if let currentVC = GetCurrentViewController()?.navigationController?.viewControllers[navCount - 2] as? TakeOutFoodVC {
                            currentVC.service.takefoodOutDataRequest(target: currentVC)
                            currentVC.navigationController?.popViewController(animated: true)
                        }else {
                            
                            if getUserRole() == .User {
                                    if let rootVC = GetCurrentViewController()?.navigationController?.viewControllers.first as? TakeOutFoodVC {
                                        rootVC.service.takefoodOutDataRequest(target: rootVC)
                                    }
                                GetCurrentViewController()?.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                        
                    }, failureAct: {
                        
                    })
                    
                    
                }
            }
            
        }) { (errormodel) in
            cmDebugPrint(errormodel)
        }
        
    }
    
    
    
    
}

//MARK: - 调起微信
func ltWechatAuth(){
    //拉起微信
    let req = SendAuthReq()
    req.scope = "snsapi_userinfo"
    req.state = "letian123"
    WXApi.send(req)
}





