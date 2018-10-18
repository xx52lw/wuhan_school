//
//  StaffOrderListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class StaffOrderListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    
    
    //MARK: - 请求配送员订单列表数据
    func staffOrderListDataRequest(target: UIViewController,requestTypeModel:StaffOrderManageRequstTypeModel){
        if let orderListVC  = target as? StaffOrderListVC {
            
            requestTool.getRequest(target: target, url:requestTypeModel.requestTypeUrl , params: nil, isShowWaiting: true, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if orderListVC?.orderManagerAbnormalView != nil {
                        orderListVC?.orderManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  StaffOrderListModel.praseStaffOrderListData(jsonData: jsonResponse, requestType: requestTypeModel.requestType)
                    
                    orderListVC?.staffOrderManageModel = resultModel
                    DispatchQueue.main.async {
                        if orderListVC?.mainTabView == nil {
                            orderListVC?.creatMainTabView()
                        }else{
                            orderListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if orderListVC?.staffOrderManageModel.orderSectionModelArr.count == 0{
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
    
  
    
    //MARK: - 下拉刷新配送员订单管理列表页
    func refreshStaffOrderListData(target: UIViewController,requestTypeModel:StaffOrderManageRequstTypeModel){
        if let staffOrderListVC  = target as? StaffOrderListVC {
            
            
            requestTool.getRequest(target: target, url:requestTypeModel.requestTypeUrl , params: nil, isShowWaiting: false, success: { [ weak staffOrderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  StaffOrderListModel.praseStaffOrderListData(jsonData: jsonResponse, requestType: requestTypeModel.requestType)
                    
                    staffOrderListVC?.staffOrderManageModel = resultModel
                    
                    DispatchQueue.main.async {
                        staffOrderListVC?.mainTabView.mj_header.endRefreshing()
                        staffOrderListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if staffOrderListVC?.staffOrderManageModel.orderSectionModelArr.count == 0 {
                            if staffOrderListVC?.orderManagerNoDataView == nil{
                                staffOrderListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                staffOrderListVC?.orderManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if staffOrderListVC?.orderManagerNoDataView != nil{
                                staffOrderListVC?.orderManagerNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak staffOrderListVC] (erroModel) in
                //下拉网络请求错误处理
                staffOrderListVC?.mainTabView.mj_header.endRefreshing()
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

    
    
    

    //MARK: - 获取基本信息
    func getStaffSystemInfoRequest(target: UIViewController){
        if let currentStaffHomePageVC  = target as? StaffOrderListVC {
            
            requestTool.postRequest(target: target, url:getStaffInfoUlr , params: nil, isShowWaiting: true, success: { [weak currentStaffHomePageVC](sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    let resultModel =  StaffInfoModel.parseStaffInfoModelData(jsonData: jsonResponse)
                    
                    currentStaffHomePageVC?.staffInfoModel = resultModel
                    DispatchQueue.main.async {
                        currentStaffHomePageVC?.topView.titleLabel.text = resultModel.MerchantName
                    }
                }
                
            }) { (erroModel) in
                
            }
        }
    }
    
    
    
}
