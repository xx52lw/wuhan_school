//
//  OrderAddRecieverService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderAddRecieverService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    //MARK: - 新增收货人
    func addOrderRecieverRequest(userName:String,gender:Int,userTel:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserName"] = userName
        paramsDict["PhoneNumber"] = userTel
        paramsDict["Sex"] = gender
        requestTool.putRequest(target: nil, url:addRecieverUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"新增失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
            failureAct()
        }
    }
    
}
