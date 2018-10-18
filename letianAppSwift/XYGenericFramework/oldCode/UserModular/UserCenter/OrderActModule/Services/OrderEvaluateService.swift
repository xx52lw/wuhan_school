//
//  OrderEvaluateService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/30.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderEvaluateService: NSObject {
    
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 订单评价主页data
    func orderWaitEvaluateDataRequest(target: UIViewController,orderId:String){
        if let orderEvaluateVC  = target as? OrderEvaluateVC {
            
            requestTool.getRequest(target: target, url:waitForEvaluatePageUrl + "/" + orderId , params: nil, isShowWaiting: true, success: { [ weak orderEvaluateVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if orderEvaluateVC?.orderEvaluateAbnormalView != nil {
                        orderEvaluateVC?.orderEvaluateAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  OrderEvaluateModel.praseOrderEvaluateModelData(jsonData: jsonResponse)
                    
                    orderEvaluateVC?.evaluateModel = resultModel
                    
                    DispatchQueue.main.async {
                        if orderEvaluateVC?.mainTabView == nil {
                            orderEvaluateVC?.creatMainTabView()
                        }else{
                            orderEvaluateVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if orderEvaluateVC?.evaluateModel.waitEvaluateGoodsModelArr.count == 0{
                            if orderEvaluateVC?.orderEvaluateNoDataView == nil{
                                orderEvaluateVC?.creatAbnormalView(isNetError: false)
                            }else{
                                orderEvaluateVC?.orderEvaluateNoDataView.abnormalType = .noData
                            }
                        }else{
                            if orderEvaluateVC?.orderEvaluateNoDataView != nil{
                                orderEvaluateVC?.orderEvaluateNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak orderEvaluateVC] (erroModel) in
                //展示错误页
                if orderEvaluateVC?.orderEvaluateAbnormalView == nil{
                    orderEvaluateVC?.creatAbnormalView(isNetError: true)
                }else{
                    orderEvaluateVC?.orderEvaluateAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    orderEvaluateVC?.orderEvaluateAbnormalView.abnormalType = .dataError
                    if let erroJson = erroModel.response as? JSON {
                        netWorkRequestAct(erroJson)
                    }
                }
            }
        }
    }
    
    
    
    
    
    //MARK: - 订单评价
    func orderEvaluateSubmitRequest(orderEvaluateModel:OrderEvaluateModel,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        if orderEvaluateModel.merchantEvaluateContent.trimmingCharacters(in: .whitespaces).count < 2 {
            cmShowHUDToWindow(message: "商家评价内容不能少于2个字符")
            failureAct()
            return
        }
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserOrderID"] = orderEvaluateModel.UserOrderID
        paramsDict["Star"] = orderEvaluateModel.merchantScore + 1
        paramsDict["Comment"] = orderEvaluateModel.merchantEvaluateContent
        
        for index in 0..<orderEvaluateModel.waitEvaluateGoodsModelArr.count {
            paramsDict["DetailComment[\(index)].OrderDetailID"] = orderEvaluateModel.waitEvaluateGoodsModelArr[index].OrderDetailID
            paramsDict["DetailComment[\(index)].Star"] = orderEvaluateModel.waitEvaluateGoodsModelArr[index].evaluateScore + 1
            paramsDict["DetailComment[\(index)].Comment"] = orderEvaluateModel.waitEvaluateGoodsModelArr[index].evaluateContent
            
            if orderEvaluateModel.waitEvaluateGoodsModelArr[index].evaluateContent.trimmingCharacters(in: .whitespaces).count < 2 {
                cmShowHUDToWindow(message: "商品评价内容不能少于2个字符")
                failureAct()
                return
            }
        }
        
        
        requestTool.postRequest(target: nil, url:orderEvaluateUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"评价提交失败,请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
}
