//
//  OrderPayService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/29.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderPayService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 支付
    func orderPayRequest(userOrderID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let urlParameters =  orderPayUrl + "/\(userOrderID)"

        requestTool.postRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"支付失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 订单支付信息
    func orderPayInfoRequest(userOrderID:String,successAct:@escaping (OrderSubmitResultModel)->Void,failureAct:@escaping ()->Void) {
        let urlParameters =  orderPayInfoUrl + "/\(userOrderID)"
        
        requestTool.getRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let resonseJson = sucessModel.response as? JSON{
                let resultModel = OrderSubmitResultModel.praseOrderInfoData(jsonData: resonseJson)
                successAct(resultModel)
            }
            
        }) {  (erroModel) in
            
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
    
    
}
