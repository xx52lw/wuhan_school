//
//  orderSubmitService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class orderSubmitService: NSObject {

    
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 准备提交订单数据
    func orderPrepareDataGetRequest(target: UIViewController,merchantID:String){
        if let orderSubmitVC  = target as? OrderSubmitViewController {
            
            let urlParameters = orderSubmitPrepareUrl + "/\(merchantID)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak orderSubmitVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    if orderSubmitVC?.orderSubmitAbnormalView != nil {
                        orderSubmitVC?.orderSubmitAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  OrderSubmitModel.prasePrepareSubmitModeData(jsonData: jsonResponse)
                    resultModel.deliveryMoney = orderSubmitVC!.deliveryFee
                    resultModel.sellerName = orderSubmitVC!.sellerName
                    orderSubmitVC?.submiteModel = resultModel
                    
                    DispatchQueue.main.async {
                        orderSubmitVC?.creatMainTabView()
                        orderSubmitVC?.createBottomView()
                    }
                }
                
            }) { [ weak orderSubmitVC] (erroModel) in
                cmDebugPrint(erroModel)

                if netWorkIsReachable == true{
                    if let erroJson = erroModel.response as? JSON {
                        netWorkRequestAct(erroJson)
                        return
                    }
                    if orderSubmitVC?.orderSubmitAbnormalView == nil{
                        orderSubmitVC?.creatAbnormalView(isNetError: true)
                    }
                    orderSubmitVC?.orderSubmitAbnormalView.abnormalType = .dataError
                }else{
                    //展示错误页
                    if orderSubmitVC?.orderSubmitAbnormalView == nil{
                        orderSubmitVC?.creatAbnormalView(isNetError: true)
                    }else{
                        orderSubmitVC?.orderSubmitAbnormalView.abnormalType = .networkError
                    }
                }
            }
        }
    }
    
    
    //MARK: - 提交订单
    func submitOrderRequest(model:OrderSubmitParametersModel,successAct:@escaping (OrderSubmitResultModel)->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["MerchantID"] = model.merchantID!
        paramsDict["UserName"] = model.selectedRecieverModel.UserName!
        paramsDict["PhoneNumber"] = model.selectedRecieverModel.PhoneNumber!
         paramsDict["Sex"] = model.selectedRecieverModel.Sex!
        if model.selectedPromotionModel != nil {
         paramsDict["UseCC"] = "true"
         paramsDict["UserCCID"] = model.selectedPromotionModel.UserCCID!
        }else{
            paramsDict["UseCC"] = "false"
        }
        if model.isUseJF == true {
            paramsDict["UseJF"] = "true"
         paramsDict["JFAmount"] = model.useJFAmount!
        }else{
            paramsDict["UseJF"] = "false"
         paramsDict["JFAmount"] = 0
        }
         paramsDict["SAreaID"] = model.selectedSchoolBuildingModel.SAreaID!
         paramsDict["TotalPay"] = model.needPayAmount!
        if model.remarksInfo != nil {
         paramsDict["Remarks"] = model.remarksInfo!
        }
        
        if model.selectedDeliveryTimeModel.isDeliverySoon == true {
            paramsDict["ChooseYuYue"] = "false"
        }else{
            paramsDict["ChooseYuYue"] = "true"
            paramsDict["MExpressTimeID"] = model.selectedDeliveryTimeModel.MExpressTimeID
        }
        
        
        requestTool.putRequest(target: nil, url:submitOrderUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                let resultModel = OrderSubmitResultModel.praseOrderSubmitResultData(jsonData: jsonResponse)
                successAct(resultModel)
            }
            
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"提交失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
}
