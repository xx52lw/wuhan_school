//
//  BusinnessSettingService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class BusinnessSettingService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 开启或者暂停营业，0：营业，1：暂停营业
    func businessActRequest(type:Int,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        var requestUrl = ""
        if type == 0 {
            requestUrl = startBusinerssUrl
        }else{
            requestUrl = closeBusinnessUrl
        }
        
        requestTool.postRequest(target: nil, url:requestUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"操作失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }

    
}
