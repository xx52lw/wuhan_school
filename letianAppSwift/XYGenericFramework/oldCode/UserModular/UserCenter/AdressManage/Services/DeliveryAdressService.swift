//
//  DeliveryAdressService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/29.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class DeliveryAdressService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求配送地址列表数据
    func deliveryAdressManagerListDataRequest(target: UIViewController){
        if let adressManagerListVC  = target as? DeliveryAdressManagerVC {
            
            requestTool.getRequest(target: target, url:deliveryAdressManagerUrl , params: nil, isShowWaiting: true, success: { [ weak adressManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if adressManagerListVC?.adressManagerAbnormalView != nil {
                        adressManagerListVC?.adressManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  AdressManageModel.praseDeliveryAdressManageData(jsonData: jsonResponse)
                    
                    adressManagerListVC?.adressManagerModel = resultModel

                    DispatchQueue.main.async {
                        if adressManagerListVC?.mainTabView == nil {
                            adressManagerListVC?.creatMainTabView()
                        }else{
                            adressManagerListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if adressManagerListVC?.adressManagerModel.adressCellModelArr.count == 0{
                            if adressManagerListVC?.adressManagerNoDataView == nil{
                                adressManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                adressManagerListVC?.adressManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if adressManagerListVC?.adressManagerNoDataView != nil{
                                adressManagerListVC?.adressManagerNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak adressManagerListVC] (erroModel) in
                //展示错误页
                if adressManagerListVC?.adressManagerAbnormalView == nil{
                    adressManagerListVC?.creatAbnormalView(isNetError: true)
                }else{
                    adressManagerListVC?.adressManagerAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    adressManagerListVC?.adressManagerAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 下拉刷新地址列表页
    func refreshDeliveryAdressManagerListData(target: UIViewController){
        if let adressManagerListVC  = target as? DeliveryAdressManagerVC {


            requestTool.getRequest(target: target, url:deliveryAdressManagerUrl , params: nil, isShowWaiting: false, success: { [ weak adressManagerListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  AdressManageModel.praseDeliveryAdressManageData(jsonData: jsonResponse)

                    adressManagerListVC?.adressManagerModel = resultModel
                    
                    DispatchQueue.main.async {
                        adressManagerListVC?.mainTabView.mj_header.endRefreshing()
                        adressManagerListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if adressManagerListVC?.adressManagerModel.adressCellModelArr.count == 0{
                            if adressManagerListVC?.adressManagerNoDataView == nil{
                                adressManagerListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                adressManagerListVC?.adressManagerNoDataView.abnormalType = .noData
                            }
                        }else{
                            if adressManagerListVC?.adressManagerNoDataView != nil{
                                adressManagerListVC?.adressManagerNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak adressManagerListVC] (erroModel) in
                //下拉网络请求错误处理
                adressManagerListVC?.mainTabView.mj_header.endRefreshing()
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
    
    
    
    //MARK: - 新增地址
    func addNewDeliveryAdressRequest(model:AdressManageCellModel,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserName"] = model.userName
        paramsDict["PhoneNumber"] = model.ueserTel
        paramsDict["Sex"] = model.userGender
        paramsDict["Address"] = model.userAdress
        if !model.addressDetail.isEmpty {
            paramsDict["AddressDetail"] = model.addressDetail
        }
        paramsDict["AddressGeohash"] = model.addressGeohash
        
        requestTool.putRequest(target: nil, url:addNewDeliveryAdressUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
    
    //MARK: - 修改收货人地址
    func updateDeliveryAdressRequest(model:AdressManageCellModel,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["UserName"] = model.userName
        paramsDict["PhoneNumber"] = model.ueserTel
        paramsDict["Sex"] = model.userGender
        paramsDict["Address"] = model.userAdress
        if !model.addressDetail.isEmpty {
            paramsDict["AddressDetail"] = model.addressDetail
        }
        paramsDict["AddressGeohash"] = model.addressGeohash
        paramsDict["UserAddressID"] = model.userAddressID

        
        requestTool.postRequest(target: nil, url:updateDeliveryAdressUrl, params: paramsDict, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"修改失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 删除收货人地址
    func deleteDeliveryAdressRequest(deliveryAdressID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = deliveryAdressID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = deleteDeliveryAdressUrl + "/" + encodeId!
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
