//
//  MerchantSystemSettingService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantSystemSettingService: NSObject {
    
    //网络请求工具
    private var requestTool = NetworkRequestTool()

    //MARK: - 更新商家密码
    func updateMerchantPassWordRequest(paramsDict:Dictionary<String,Any>,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        requestTool.postRequest(target: nil, url:updateMerchantPassWord, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
    
}
