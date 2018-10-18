//
//  MerchantOrderEvaluateDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderEvaluateDetailService: NSObject {
//网络请求工具
private var requestTool = NetworkRequestTool()

//MARK: - 商家订单评价主页data
func merchantOrderEvaluateDataRequest(target: UIViewController,orderId:String){
    if let MerchantAnswerEvluateVC  = target as? MerchantEvaluateDetailVC {
        
        requestTool.getRequest(target: target, url:orderEvaluateDetailUrl + "/" + orderId , params: nil, isShowWaiting: true, success: { [ weak MerchantAnswerEvluateVC] (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                
                
                if MerchantAnswerEvluateVC?.orderEvaluateAbnormalView != nil {
                    MerchantAnswerEvluateVC?.orderEvaluateAbnormalView.abnormalType = .none
                }
                
                let resultModel =  MerchantOrderEvaluateDetailModel.praseMerchantOrderEvaluateDetailData(jsonData: jsonResponse)
                
                MerchantAnswerEvluateVC?.evaluateModel = resultModel
                
                DispatchQueue.main.async {
                    if MerchantAnswerEvluateVC?.mainTabView == nil {
                        MerchantAnswerEvluateVC?.creatMainTabView()
                    }else{
                        MerchantAnswerEvluateVC?.mainTabView.reloadData()
                    }
                    
                    //无数据展示无数据页面
                    if MerchantAnswerEvluateVC?.evaluateModel.GoodsEvaluateCellModelArr.count == 0{
                        if MerchantAnswerEvluateVC?.orderEvaluateNoDataView == nil{
                            MerchantAnswerEvluateVC?.creatAbnormalView(isNetError: false)
                        }else{
                            MerchantAnswerEvluateVC?.orderEvaluateNoDataView.abnormalType = .noData
                        }
                    }else{
                        if MerchantAnswerEvluateVC?.orderEvaluateNoDataView != nil{
                            MerchantAnswerEvluateVC?.orderEvaluateNoDataView.abnormalType = .none
                        }
                    }
                    
                    
                }
            }
            
        }) { [ weak MerchantAnswerEvluateVC] (erroModel) in
            //展示错误页
            if MerchantAnswerEvluateVC?.orderEvaluateAbnormalView == nil{
                MerchantAnswerEvluateVC?.creatAbnormalView(isNetError: true)
            }else{
                MerchantAnswerEvluateVC?.orderEvaluateAbnormalView.abnormalType = .networkError
            }
            if netWorkIsReachable == true{
                MerchantAnswerEvluateVC?.orderEvaluateAbnormalView.abnormalType = .dataError
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                }
            }
        }
    }
}
    
    
    //MARK: - 回复对商家的评论
    func answerMerchantCommentRequest(evaluateID:String,commentStr:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["ID"] = evaluateID
        paramsDict["Content"] = commentStr
        
        requestTool.postRequest(target: nil, url:ansewerMerchantEvaluationUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"回复失败，请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 回复对商品的评论
    func answerGoodsCommentRequest(evaluateID:String,commentStr:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["ID"] = evaluateID
        paramsDict["Content"] = commentStr
        
        requestTool.postRequest(target: nil, url:ansewerGoodsEvaluationUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"回复失败，请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    //MARK: - 屏蔽评价
    func shieldEvaluationRequest(merchantEvaluateID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        let parametersUrl = shieldEvaluationUrl + "/" + merchantEvaluateID

        
        requestTool.postRequest(target: nil, url:parametersUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"回复失败，请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    

    
}
