//
//  XYCommonService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON
class XYCommonService: NSObject {

}



//MARK: - token
var commonTokenStr:String?

//存储token
func saveToken(tokenStr:String){
    UserDefaults.standard.set(tokenStr, forKey: "requestToken")
}

//MARK: - 移除token
func removeTokenInfo(){
    UserDefaults.standard.removeObject(forKey: "requestToken")
}


//获取token
func getToken(){
    
    if let tokenStr = UserDefaults.standard.value(forKey: "requestToken") as? String {
        if !tokenStr.isEmpty{
            commonTokenStr = tokenStr
        }else{
            commonTokenStr = nil
        }
    }else{
    commonTokenStr = nil
    }
}

//是否存在token验证
func tokenIsValid() -> Bool{
    getToken()
    if commonTokenStr == nil{
        return false
    }
    return true
}





//MARK: - 检查是否登录，未登录则跳登录界面
func checkLoginStatus(loginSuccessAct:LoginSuccess?) -> Bool{
    
    if isLogined() != true {
        let loginVC = LoginViewController()
        if loginSuccessAct != nil {
            loginVC.loginSucessClosure = loginSuccessAct
        }
        GetCurrentViewController()?.navigationController?.pushViewController(loginVC, animated: true)
        return false
    }else{
        return true
    }
}


