//
//  OrderManageListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class OrderManageListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 请求订单列表数据
    func orderManagerListDataRequest(target: UIViewController,requestTypeModel:OrderManageRequstTypeModel){
        if let orderListVC  = target as? OrderManageVC {
            self.currentPage = 1
            
            if orderListVC.mainTabView != nil {
                orderListVC.mainTabView.mj_footer.resetNoMoreData()
            }
            
            var  urlParameters = ""
            if requestTypeModel.requestType == .allOrders || requestTypeModel.requestType == .refund {
                urlParameters =  requestTypeModel.requestTypeUrl + "/\(self.currentPage)"
            }else{
                urlParameters =  requestTypeModel.requestTypeUrl
            }
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if orderListVC?.orderManagerAbnormalView != nil {
                        orderListVC?.orderManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  OrderManageModel.praseOrderManageData(jsonData: jsonResponse)
                    
                    orderListVC?.orderManageModel = resultModel
                    DispatchQueue.main.async {
                        if orderListVC?.mainTabView == nil {
                            orderListVC?.creatMainTabView()
                        }else{
                            orderListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if orderListVC?.orderManageModel.allOrderCellModelArr.count == 0{
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
                    
                    if let erroJson = erroModel.response as? JSON {
                        if erroJson["code"].stringValue == requestCode401 {
                            orderListVC?.orderManagerAbnormalView.dataErrorView.detailLabel.text = "登录后点击按钮刷新页面"
                            orderListVC?.orderManagerAbnormalView.dataErrorView.titleLabel.text = "请登录后查看订单列表"
                        }else{
                            orderListVC?.orderManagerAbnormalView.dataErrorView.titleLabel.text = "服务器繁忙，请稍后再试"
                            orderListVC?.orderManagerAbnormalView.dataErrorView.detailLabel.text = "请点击刷新按钮刷新页面"
                        }
                    }
                    
                    orderListVC?.orderManagerAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    
    //MARK: - 下拉刷新订单列表页
    func refreshOrderManagerListData(target: UIViewController,requestTypeModel:OrderManageRequstTypeModel){
        if let orderListVC  = target as? OrderManageVC {
            self.currentPage = 1
            var  urlParameters = ""
            if requestTypeModel.requestType == .allOrders || requestTypeModel.requestType == .refund {
                urlParameters =  requestTypeModel.requestTypeUrl + "/\(self.currentPage)"
            }else{
                urlParameters =  requestTypeModel.requestTypeUrl
            }
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  OrderManageModel.praseOrderManageData(jsonData: jsonResponse)
                    
                    orderListVC?.orderManageModel = resultModel
                    
                    DispatchQueue.main.async {
                        orderListVC?.mainTabView.mj_header.endRefreshing()
                        orderListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if orderListVC?.orderManageModel.allOrderCellModelArr.count == 0{
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
                        if erroJson["code"].stringValue == requestCode401 {
                            orderListVC?.orderManageModel.allOrderCellModelArr.removeAll()
                            orderListVC?.mainTabView.reloadData()
                            cmShowHUDToWindow(message:"登录后才可查看订单")
                        }
                    }else{
                        if let erroJson = erroModel.response as? JSON {
                            netWorkRequestAct(erroJson)
                            return
                        }
                        cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                    }
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
    //MARK: - 订单列表页上拉加载
    func orderManagerListPullData(target: UIViewController,requestTypeModel:OrderManageRequstTypeModel){
        if let orderListVC  = target as? OrderManageVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if orderListVC.orderManageModel.hasNextPage == false {
                orderListVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            var  urlParameters = ""
            if requestTypeModel.requestType == .allOrders || requestTypeModel.requestType == .refund {
                urlParameters =  requestTypeModel.requestTypeUrl + "/\(requestPage)"
            }else{
                urlParameters =  requestTypeModel.requestTypeUrl
            }
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak orderListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let resultModel =   OrderManageModel.praseOrderManageData(jsonData: jsonResponse)
                    for model in resultModel.allOrderCellModelArr{
                        orderListVC?.orderManageModel.allOrderCellModelArr.append(model)
                    }
                    orderListVC?.orderManageModel.hasNextPage = resultModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        orderListVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if orderListVC?.orderManageModel.hasNextPage == false
                        {
                            orderListVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            orderListVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak orderListVC] (erroModel) in
                
                //上拉加载请求错误处理
                orderListVC?.mainTabView.mj_footer.endRefreshing()
                
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
    
    
    //MARK: - 取消订单
    func cancelOrderRequest(orderId:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = orderId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = cancelOrderUrl + "/" + encodeId!
        requestTool.postRequest(target: nil, url:urlPrameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"取消失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 删除订单
    func deleteOrderRequest(orderId:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = orderId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = deleteOrderUrl + "/" + encodeId!
        requestTool.deleteRequest(target: nil, url:urlPrameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"删除失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
}
