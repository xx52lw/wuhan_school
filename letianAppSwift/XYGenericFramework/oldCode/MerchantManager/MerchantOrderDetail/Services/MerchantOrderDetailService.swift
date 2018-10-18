//
//  MerchantOrderDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderDetailService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    //MARK: - 请求商家今日订单详情数据
    func merchantCurrentOrderDetailDataRequest(target: UIViewController,orderID:String){
        if let currentOrderDetailVC  = target as? MerchantCurrentOrderDetailVC {
            
            let urlPrameter = currentMerchantOrderDetailUrl + "/" + orderID
            requestTool.getRequest(target: target, url:urlPrameter , params: nil, isShowWaiting: true, success: { [ weak currentOrderDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if currentOrderDetailVC?.merchantOrderAbnormalView != nil {
                        currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderDetailModel.praseOrderDetailData(jsonData: jsonResponse)
                    
                    currentOrderDetailVC?.oderDetailModel = resultModel
                    DispatchQueue.main.async {
                        if currentOrderDetailVC?.mainTabView == nil {
                            currentOrderDetailVC?.creatMainTabView()
                        }else{
                            currentOrderDetailVC?.mainTabView.reloadData()
                        }
                        
                    }
                }
                
            }) { [ weak currentOrderDetailVC] (erroModel) in
                //展示错误页
                if currentOrderDetailVC?.merchantOrderAbnormalView == nil{
                    currentOrderDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 配送中订单详情
    func merchantDeliveringOrderDetailRequest(target: UIViewController,orderID:String){
        if let currentOrderDetailVC  = target as? MerchantOrderDeliveringDetailVC {
            
            let urlPrameter = merchantDeliveringOrderDetailUrl + "/" + orderID
            requestTool.getRequest(target: target, url:urlPrameter , params: nil, isShowWaiting: true, success: { [ weak currentOrderDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if currentOrderDetailVC?.merchantOrderAbnormalView != nil {
                        currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderDetailModel.praseDeliveringOrderDetailData(jsonData: jsonResponse)
                    
                    currentOrderDetailVC?.oderDetailModel = resultModel
                    DispatchQueue.main.async {
                        if currentOrderDetailVC?.mainTabView == nil {
                            currentOrderDetailVC?.creatMainTabView()
                        }else{
                            currentOrderDetailVC?.mainTabView.reloadData()
                        }
                        
                    }
                }
                
            }) { [ weak currentOrderDetailVC] (erroModel) in
                //展示错误页
                if currentOrderDetailVC?.merchantOrderAbnormalView == nil{
                    currentOrderDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 已送达订单详情
    func merchantDeliveriedOrderDetailRequest(target: UIViewController,orderID:String){
        if let currentOrderDetailVC  = target as? MerchantOrderDeliveriedDetailVC {
            
            let urlPrameter = merchantDeliveriedDetailUrl + "/" + orderID
            requestTool.getRequest(target: target, url:urlPrameter , params: nil, isShowWaiting: true, success: { [ weak currentOrderDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if currentOrderDetailVC?.merchantOrderAbnormalView != nil {
                        currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderDetailModel.praseDeliveriedOrderDetailData(jsonData: jsonResponse)
                    
                    currentOrderDetailVC?.oderDetailModel = resultModel
                    DispatchQueue.main.async {
                        if currentOrderDetailVC?.mainTabView == nil {
                            currentOrderDetailVC?.creatMainTabView()
                        }else{
                            currentOrderDetailVC?.mainTabView.reloadData()
                        }
                        
                    }
                }
                
            }) { [ weak currentOrderDetailVC] (erroModel) in
                //展示错误页
                if currentOrderDetailVC?.merchantOrderAbnormalView == nil{
                    currentOrderDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 已退单订单详情
    func merchantHasReturnedOrderDetailRequest(target: UIViewController,orderID:String){
        if let currentOrderDetailVC  = target as? MerchantHasReturnOrderDetailVC {
            
            let urlPrameter = hasReturnedOrderDetailUrl + "/" + orderID
            requestTool.getRequest(target: target, url:urlPrameter , params: nil, isShowWaiting: true, success: { [ weak currentOrderDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if currentOrderDetailVC?.merchantOrderAbnormalView != nil {
                        currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderDetailModel.praseHasReturnedOrderDetailData(jsonData: jsonResponse)
                    
                    currentOrderDetailVC?.oderDetailModel = resultModel
                    DispatchQueue.main.async {
                        if currentOrderDetailVC?.mainTabView == nil {
                            currentOrderDetailVC?.creatMainTabView()
                        }else{
                            currentOrderDetailVC?.mainTabView.reloadData()
                        }
                        
                    }
                }
                
            }) { [ weak currentOrderDetailVC] (erroModel) in
                //展示错误页
                if currentOrderDetailVC?.merchantOrderAbnormalView == nil{
                    currentOrderDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    currentOrderDetailVC?.merchantOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 退单订单详情
    func merchantReturnOrderDetailRequest(userOrderID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let urlParameters =  returnOrderDetailUrl + "/\(userOrderID)"
        
        requestTool.getRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                
                let resultModel =  MerchantOrderDetailModel.praseReturnOrderDetailData(jsonData: jsonResponse)
                
                switch resultModel.TDType {
                case .returnOrder,.refund:
                    let returnOrderDetailVC = MerchantReturnOrderDetailVC()
                    returnOrderDetailVC.oderDetailModel = resultModel
                    GetCurrentViewController()?.navigationController?.pushViewController(returnOrderDetailVC, animated: true)
                    break
                case .platform:
                    let customServiceOrderDetailVC = MerchantCustomServiceOrderDetailVC()
                    customServiceOrderDetailVC.oderDetailModel = resultModel
                    GetCurrentViewController()?.navigationController?.pushViewController(customServiceOrderDetailVC, animated: true)
                    break
                default:
                    break
                }
                
                
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
    
    
    
    //MARK: - 清除配送员
    func clearOrderStaffRequest(userOrderID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let urlParameters =  clearOrderStaffUrl + "/\(userOrderID)"
        
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
                cmShowHUDToWindow(message:"操作失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    
    //MARK: - 设置配送员
    func setStaffRequest(userOrderID:String,dStaffID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let urlParameters =  setStaffUrl + "/\(userOrderID)" + "/\(dStaffID)" + "/2"
        
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
                cmShowHUDToWindow(message:"设置失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 商家退单
    func merchantReturnOrderRequest(userOrderID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void){
        let urlParameters =  merchantReturnOrder + "/\(userOrderID)"
        
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
                cmShowHUDToWindow(message:"设置失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    //MARK: - 商家同意/拒绝退单
    func returnOrderMerchantActRequest(userOrderID:String,isAgree:Bool,reason:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void){
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        if isAgree == true {
            paramsDict["Agree"] = "true"
        }else{
            paramsDict["Agree"] = "false"
        }
        paramsDict["Reason"] = reason
        requestTool.postRequest(target: nil, url:returnOrderMerchantActUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
    
    
    
    //MARK: - 上传证据
    func uploadMerchantServicePic(userOrderID:String,imageArr:[UIImage],successAct:@escaping ()->Void,failureAct:@escaping ()->Void){
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        requestTool.uploadPicsSync(target: GetCurrentViewController(), url: uploadMerchantServicePicUrl, isShowWaiting: true, chooseImageArr: imageArr, successAct: {(sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
        }, faileAct:  {(erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                cmShowHUDToWindow(message:"只支持上传png,jpg,bmp格式且小于500k的文件")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }, parameters: paramsDict
        )
        
    }
    
}
