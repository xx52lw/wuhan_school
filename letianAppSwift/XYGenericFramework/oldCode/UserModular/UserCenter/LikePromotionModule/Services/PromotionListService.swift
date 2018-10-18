//
//  PromotionListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class PromotionListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求优惠券列表
    func getUserPromotionListRequest(target: UIViewController){
        if let userPromotionListVC  = target as? PromotionListVC {
            
            let urlParameters = userPromotionListUrl
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak userPromotionListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if userPromotionListVC?.promotionListAbnormalView != nil {
                        userPromotionListVC?.promotionListAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  PromotionListModel.praseUserPromotionListData(jsonData: jsonResponse)//PromotionListModel.testData()//
                    userPromotionListVC?.promotionListModel = resultModel
                    
                    
                    DispatchQueue.main.async {
                        if userPromotionListVC?.mainTabView == nil {
                            userPromotionListVC?.creatMainTabView()
                            
                        }else{
                            userPromotionListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据
                        if userPromotionListVC?.promotionListModel.cellModelArr.count == 0{
                            if userPromotionListVC?.promotionListNoDataView == nil{
                                userPromotionListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                userPromotionListVC?.promotionListNoDataView.abnormalType = .noData
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak userPromotionListVC] (erroModel) in
                //展示错误页
                if userPromotionListVC?.promotionListAbnormalView == nil{
                    userPromotionListVC?.creatAbnormalView(isNetError: true)
                }else{
                    userPromotionListVC?.promotionListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    userPromotionListVC?.promotionListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
}
