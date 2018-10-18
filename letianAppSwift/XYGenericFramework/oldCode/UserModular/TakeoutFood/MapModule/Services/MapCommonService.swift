//
//  MapCommonService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MapCommonService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 修改当前地址
    func updateDeliveryAdressRequest(AreaCode:Int,Location:String,Geohash:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["AreaCode"] = AreaCode
        paramsDict["Location"] = Location
        paramsDict["Geohash"] = Geohash
        
        
        requestTool.postRequest(target: nil, url:updateCurrentLocationUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"修改失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
}
