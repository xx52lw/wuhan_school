//
//  OrderDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderDetailService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    
    //MARK: - 待支付订单详情数据
    func waitPayOrderDetailDataRequest(userOrderID:String) {

        let urlParameters =  waitePayOrderDetailUrl + "/\(userOrderID)"
        requestTool.getRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let response = sucessModel.response as? JSON{
                let resultModel = OrderDetailModel.praseOrderDetailData(jsonData:response)
                DispatchQueue.main.async {
                    let waitPayOrderDetailVC = OrderDetailVC()
                    waitPayOrderDetailVC.oderDetailModel = resultModel
                    GetCurrentViewController()?.navigationController?.pushViewController(waitPayOrderDetailVC, animated: true)
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
    

    //MARK: - 其余订单详情数据请求
    func otherOrderDetailDataRequest(userOrderID:String) {
        
        let urlParameters =  otherOrderDetailUrl + "/\(userOrderID)"
        requestTool.getRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let response = sucessModel.response as? JSON{
                let resultModel = OrderDetailModel.praseOrderDetailData(jsonData:response)
                DispatchQueue.main.async {
                    let orderDetailVC = OrderDetailVC()
                    orderDetailVC.oderDetailModel = resultModel
                    GetCurrentViewController()?.navigationController?.pushViewController(orderDetailVC, animated: true)
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
    
    
    //MARK: - 申请退单
    func applicationForReturnRequest(userOrderID:String,content:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        paramsDict["Content"] = content
        
        requestTool.postRequest(target: nil, url:applicationForReturn, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"申请失败,请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }

    //MARK: - 申请退款
    func applicationForRefundRequest(userOrderID:String,content:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        paramsDict["Content"] = content
        
        requestTool.postRequest(target: nil, url:applicationForRefund, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"申请失败,请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    //MARK: - 申请客服介入
    func applicationForServiceRequest(userOrderID:String,content:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        paramsDict["Content"] = content
        
        requestTool.postRequest(target: nil, url:applicationForService, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"申请失败,请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    //MARK: - 投诉商家
    func applicationForComplainRequest(merchantID:String,content:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["MerchantID"] = merchantID
        paramsDict["Content"] = content
        
        requestTool.postRequest(target: nil, url:applicationForComplain, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:DATA_ERROR_TIPS)
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
}
