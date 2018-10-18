//
//  MerchantOrderEvaluateListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderEvaluateListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求用户评价列表数据
    func merchantOrderEvaluateManagerListDataRequest(target: UIViewController){
        if let orderEvaluateManagerListVC  = target as? MerchantOrderEvaluateListVC {
            
            requestTool.getRequest(target: target, url:userOrderEvaluateListUrl , params: nil, isShowWaiting: true, success: { [ weak orderEvaluateManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if orderEvaluateManagerListVC?.evaluateListAbnormalView != nil {
                        orderEvaluateManagerListVC?.evaluateListAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderEvaluateListModel.praseMerchantOrderEvaluateListData(jsonData: jsonResponse)
                    
                    orderEvaluateManagerListVC?.evaluateListModel = resultModel
                    
                    DispatchQueue.main.async {
                        if orderEvaluateManagerListVC?.mainTabView == nil {
                            orderEvaluateManagerListVC?.creatMainTabView()
                        }else{
                            orderEvaluateManagerListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if orderEvaluateManagerListVC?.evaluateListModel.evaluateSectionModelArr.count == 0 {
                            if orderEvaluateManagerListVC?.evaluateListNoDataView == nil{
                                orderEvaluateManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                orderEvaluateManagerListVC?.evaluateListNoDataView.abnormalType = .noData
                            }
                        }else{
                            if orderEvaluateManagerListVC?.evaluateListNoDataView != nil{
                                orderEvaluateManagerListVC?.evaluateListNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak orderEvaluateManagerListVC] (erroModel) in
                //展示错误页
                if orderEvaluateManagerListVC?.evaluateListAbnormalView == nil{
                    orderEvaluateManagerListVC?.creatAbnormalView(isNetError: true)
                }else{
                    orderEvaluateManagerListVC?.evaluateListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    orderEvaluateManagerListVC?.evaluateListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 下拉刷新订单评价管理列表页
    func refreshmerchantOrderEvaluateListData(target: UIViewController){
        if let orderEvaluateManagerListVC  = target as? MerchantOrderEvaluateListVC {
            
            
            requestTool.getRequest(target: target, url:userOrderEvaluateListUrl , params: nil, isShowWaiting: false, success: { [ weak orderEvaluateManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  MerchantOrderEvaluateListModel.praseMerchantOrderEvaluateListData(jsonData: jsonResponse)
                    
                    orderEvaluateManagerListVC?.evaluateListModel = resultModel
                    
                    DispatchQueue.main.async {
                        orderEvaluateManagerListVC?.mainTabView.mj_header.endRefreshing()
                        orderEvaluateManagerListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if orderEvaluateManagerListVC?.evaluateListModel.evaluateSectionModelArr.count == 0 {
                            if orderEvaluateManagerListVC?.evaluateListNoDataView == nil{
                                orderEvaluateManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                orderEvaluateManagerListVC?.evaluateListNoDataView.abnormalType = .noData
                            }
                        }else{
                            if orderEvaluateManagerListVC?.evaluateListNoDataView != nil{
                                orderEvaluateManagerListVC?.evaluateListNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak orderEvaluateManagerListVC] (erroModel) in
                //下拉网络请求错误处理
                orderEvaluateManagerListVC?.mainTabView.mj_header.endRefreshing()
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
    
    //MARK: - 删除评价
    func deleteUserEvaluationRequest(merchantEvaluateID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        let parametersUrl = deleteEvaluarionUrl + "/" + merchantEvaluateID
        
        
        requestTool.deleteRequest(target: nil, url:parametersUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"删除失败，请重试")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
}
