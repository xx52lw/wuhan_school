//
//  StaffManageListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class StaffManageListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求配送员列表数据
    func staffManagerListDataRequest(target: UIViewController){
        if let staffManagerListVC  = target as? StaffManageListVC {
            
            requestTool.getRequest(target: target, url:staffManageListUrl , params: nil, isShowWaiting: true, success: { [ weak staffManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if staffManagerListVC?.staffManagerAbnormalView != nil {
                        staffManagerListVC?.staffManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  StaffManageListModel.praseStaffManageListData(jsonData: jsonResponse)
                    
                    staffManagerListVC?.staffManagerModel = resultModel
                    
                    DispatchQueue.main.async {
                        if staffManagerListVC?.mainTabView == nil {
                            staffManagerListVC?.creatMainTabView()
                        }else{
                            staffManagerListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if staffManagerListVC?.staffManagerModel.unusefulStaffModelArr.count == 0 && staffManagerListVC?.staffManagerModel.usefulStaffModelArr.count == 0{
                            if staffManagerListVC?.staffManagerNoDataView == nil{
                                staffManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                staffManagerListVC?.staffManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if staffManagerListVC?.staffManagerNoDataView != nil{
                                staffManagerListVC?.staffManagerNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak staffManagerListVC] (erroModel) in
                //展示错误页
                if staffManagerListVC?.staffManagerAbnormalView == nil{
                    staffManagerListVC?.creatAbnormalView(isNetError: true)
                }else{
                    staffManagerListVC?.staffManagerAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    staffManagerListVC?.staffManagerAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 下拉刷新配送员列表页
    func refreshStaffManagerListData(target: UIViewController){
        if let staffManagerListVC  = target as? StaffManageListVC {
            
            
            requestTool.getRequest(target: target, url:staffManageListUrl , params: nil, isShowWaiting: false, success: { [ weak staffManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  StaffManageListModel.praseStaffManageListData(jsonData: jsonResponse)
                    
                    staffManagerListVC?.staffManagerModel = resultModel
                    
                    DispatchQueue.main.async {
                        staffManagerListVC?.mainTabView.mj_header.endRefreshing()
                        staffManagerListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if staffManagerListVC?.staffManagerModel.unusefulStaffModelArr.count == 0 && staffManagerListVC?.staffManagerModel.usefulStaffModelArr.count == 0{
                            if staffManagerListVC?.staffManagerNoDataView == nil{
                                staffManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                staffManagerListVC?.staffManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if staffManagerListVC?.staffManagerNoDataView != nil{
                                staffManagerListVC?.staffManagerNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak staffManagerListVC] (erroModel) in
                //下拉网络请求错误处理
                staffManagerListVC?.mainTabView.mj_header.endRefreshing()
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
    
    
    
    //MARK: - 新增配送员
    func addNewStaffRequest(staffName:String,staffPhone:String,password:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["StaffName"] = staffName
        paramsDict["Phone"] = staffPhone
        paramsDict["Password"] = password
        
        requestTool.postRequest(target: nil, url:addNewStaffUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"新增失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 更新配送员
    func updateStaffRequest(canUse:Bool,staffName:String,staffID:Int,password:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["StaffName"] = staffName
        paramsDict["DStaffID"] = staffID
        paramsDict["Password"] = password
        if canUse == true {
            paramsDict["CanUse"] = "true"
        }else{
            paramsDict["CanUse"] = "false"

        }
        
        requestTool.postRequest(target: nil, url:updateStaffUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
            successAct()
        }) {  (erroModel) in
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"修改失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 删除配送员
    func deleteMerchantStaffRequest(DStaffID:Int,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        let parametersUrl = deleteStaffUrl + "/" + String(DStaffID)
        
        
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
