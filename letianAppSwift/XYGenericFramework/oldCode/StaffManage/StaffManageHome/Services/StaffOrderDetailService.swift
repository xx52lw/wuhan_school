//
//  StaffOrderDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class StaffOrderDetailService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    //MARK: - 请求配送员订单详情数据
    func staffOrderDetailDataRequest(target: UIViewController,orderID:String){
        if let staffOrderDetailVC  = target as? StaffOrderDetailVC {
            
            let urlPrameter = staffOrderDetailUrl + "/" + orderID
            requestTool.getRequest(target: target, url:urlPrameter , params: nil, isShowWaiting: true, success: { [ weak staffOrderDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if staffOrderDetailVC?.staffOrderAbnormalView != nil {
                        staffOrderDetailVC?.staffOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  StaffOrderDetailModel.praseOrderDetailData(jsonData: jsonResponse)
                    
                    staffOrderDetailVC?.oderDetailModel = resultModel
                    DispatchQueue.main.async {
                        if staffOrderDetailVC?.mainTabView == nil {
                            staffOrderDetailVC?.creatMainTabView()
                        }else{
                            staffOrderDetailVC?.mainTabView.reloadData()
                        }
                        
                    }
                }
                
            }) { [ weak staffOrderDetailVC] (erroModel) in
                //展示错误页
                if staffOrderDetailVC?.staffOrderAbnormalView == nil{
                    staffOrderDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    staffOrderDetailVC?.staffOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    staffOrderDetailVC?.staffOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    
    
    //MARK: - 设置送达信息
    func staffSetDeliveryStatusRequest(userOrderID:String,ArriveStatus:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void){
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = userOrderID
        paramsDict["ArriveStatus"] = ArriveStatus
        
        requestTool.postRequest(target: nil, url:setDeliveryInfoUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
