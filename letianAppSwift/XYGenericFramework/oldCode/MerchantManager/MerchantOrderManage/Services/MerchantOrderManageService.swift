//
//  MerchantOrderManageService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantOrderManageService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()

    
    
    //MARK: - 请求商家订单列表数据
    func merchantOrderListDataRequest(target: UIViewController,requestTypeModel:MerchantOrderManageRequstTypeModel){
        if let orderListVC  = target as? MerchantOrderManageVC {
            
            
            requestTool.getRequest(target: target, url:requestTypeModel.requestTypeUrl , params: nil, isShowWaiting: true, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if orderListVC?.orderManagerAbnormalView != nil {
                        orderListVC?.orderManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MerchantOrderManageModel.praseMerchantOrderManageData(jsonData: jsonResponse, requestType: requestTypeModel.requestType)
                    
                    orderListVC?.merchantOrderManageModel = resultModel
                    DispatchQueue.main.async {
                        if orderListVC?.mainTabView == nil {
                            orderListVC?.creatMainTabView()
                        }else{
                            orderListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if orderListVC?.merchantOrderManageModel.allOrderSectionModelArr.count == 0{
                            if orderListVC?.orderManagerNoDataView == nil{
                                orderListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                orderListVC?.orderManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if orderListVC?.orderManagerNoDataView != nil{
                                orderListVC?.orderManagerNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak orderListVC] (erroModel) in
                //展示错误页
                if orderListVC?.orderManagerAbnormalView == nil{
                    orderListVC?.creatAbnormalView(isNetError: true)
                }else{
                    orderListVC?.orderManagerAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    orderListVC?.orderManagerAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    
    //MARK: - 下拉刷新商家订单管理列表页
    func refreshMerchantOrderListData(target: UIViewController,requestTypeModel:MerchantOrderManageRequstTypeModel){
        if let orderListVC  = target as? MerchantOrderManageVC {
            
            
            requestTool.getRequest(target: target, url:requestTypeModel.requestTypeUrl , params: nil, isShowWaiting: false, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  MerchantOrderManageModel.praseMerchantOrderManageData(jsonData: jsonResponse, requestType: requestTypeModel.requestType)
                    
                    orderListVC?.merchantOrderManageModel = resultModel
                    
                    DispatchQueue.main.async {
                        orderListVC?.mainTabView.mj_header.endRefreshing()
                        orderListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if orderListVC?.merchantOrderManageModel.allOrderSectionModelArr.count == 0 {
                            if orderListVC?.orderManagerNoDataView == nil{
                                orderListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                orderListVC?.orderManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if orderListVC?.orderManagerNoDataView != nil{
                                orderListVC?.orderManagerNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak orderListVC] (erroModel) in
                //下拉网络请求错误处理
                orderListVC?.mainTabView.mj_header.endRefreshing()
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
    
    
    
}
