//
//  CollerctionListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class CollerctionListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求收藏商家列表
    func getMerchantCollectListRequest(target: UIViewController){
        if let collectionListVC  = target as? CollectionListVC {
            
            let urlParameters = collectionMerchantListUrl
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak collectionListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if collectionListVC?.collectionListAbnormalView != nil {
                        collectionListVC?.collectionListAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  CollectionListModel.praseCollectionListData(jsonData: jsonResponse)
                    collectionListVC?.collectionListModel = resultModel
                    
                    
                    DispatchQueue.main.async {
                        if collectionListVC?.mainTabView == nil {
                            collectionListVC?.creatMainTabView()
                            
                        }else{
                            collectionListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据
                        if collectionListVC?.collectionListModel.cellModelArr.count == 0{
                            if collectionListVC?.collectionListNoDataView == nil{
                                collectionListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                collectionListVC?.collectionListNoDataView.abnormalType = .noData
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak collectionListVC] (erroModel) in
                //展示错误页
                if collectionListVC?.collectionListAbnormalView == nil{
                    collectionListVC?.creatAbnormalView(isNetError: true)
                }else{
                    collectionListVC?.collectionListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    collectionListVC?.collectionListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 下拉刷新地址列表页
    func refreshCollectionListData(target: UIViewController){
        if let collectionListVC  = target as? CollectionListVC {
            
            
            requestTool.getRequest(target: target, url:collectionMerchantListUrl , params: nil, isShowWaiting: false, success: { [ weak collectionListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let resultModel =  CollectionListModel.praseCollectionListData(jsonData: jsonResponse)

                    collectionListVC?.collectionListModel = resultModel
                    
                    DispatchQueue.main.async {
                        collectionListVC?.mainTabView.mj_header.endRefreshing()
                        collectionListVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if collectionListVC?.collectionListModel.cellModelArr.count == 0{
                            if collectionListVC?.collectionListNoDataView == nil{
                                collectionListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                collectionListVC?.collectionListNoDataView.abnormalType = .noData
                            }
                        }else{
                            if collectionListVC?.collectionListNoDataView != nil {
                                collectionListVC?.collectionListNoDataView.abnormalType = .none
                            }
                        }
                    }
                }
                
            }) { [ weak collectionListVC] (erroModel) in
                //下拉网络请求错误处理
                collectionListVC?.mainTabView.mj_header.endRefreshing()
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
    
    
    
    
    
    
    //MARK: - 删除收藏
    func deleteCollectionRequest(collectionID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = collectionID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = deleteCollectionUrl + "/" + encodeId!
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
