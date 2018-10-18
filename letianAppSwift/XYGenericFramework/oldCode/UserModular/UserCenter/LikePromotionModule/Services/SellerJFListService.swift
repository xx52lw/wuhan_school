//
//  SellerJFListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerJFListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求用户积分列表
    func getUserJFListRequest(target: UIViewController){
        if let sellerJFListVC  = target as? SellerJFListVC {
            
            let urlParameters = userJFListUrl
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak sellerJFListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if sellerJFListVC?.sellerJFListAbnormalView != nil {
                        sellerJFListVC?.sellerJFListAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SellerJFListModel.praseSellerJFListData(jsonData: jsonResponse)
                    sellerJFListVC?.sellerJFListModel = resultModel
                    
                    
                    DispatchQueue.main.async {
                        if sellerJFListVC?.mainTabView == nil {
                            sellerJFListVC?.creatMainTabView()
                            
                        }else{
                            sellerJFListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据
                        if sellerJFListVC?.sellerJFListModel.cellModelArr.count == 0{
                            if sellerJFListVC?.sellerJFListNoDataView == nil{
                                sellerJFListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                sellerJFListVC?.sellerJFListNoDataView.abnormalType = .noData
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak sellerJFListVC] (erroModel) in
                //展示错误页
                if sellerJFListVC?.sellerJFListAbnormalView == nil{
                    sellerJFListVC?.creatAbnormalView(isNetError: true)
                }else{
                    sellerJFListVC?.sellerJFListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    sellerJFListVC?.sellerJFListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
}
