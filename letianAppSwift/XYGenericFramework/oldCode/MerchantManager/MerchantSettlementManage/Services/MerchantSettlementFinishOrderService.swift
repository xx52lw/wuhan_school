//
//  MerchantSettlementFinishOrderService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantSettlementFinishOrderService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求结算周期列表数据
    func settlementFinishWeekDataRequest(target: UIViewController){
        if let settlementWeekListVC  = target as? SettlementFinishOrderVC {
            
            requestTool.getRequest(target: target, url:finishWeekSettlementUrl , params: nil, isShowWaiting: true, success: { [ weak settlementWeekListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if settlementWeekListVC?.finishOrderAbnormalView != nil {
                        settlementWeekListVC?.finishOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SettlementFinishOrderListModel.praseSettlementFinishOrderListData(jsonData: jsonResponse)
                    
                    settlementWeekListVC?.finishOrderModel = resultModel
                    
                    DispatchQueue.main.async {
                        if settlementWeekListVC?.mainTabView == nil {
                            settlementWeekListVC?.creatMainTabView()
                        }else{
                            settlementWeekListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if settlementWeekListVC?.finishOrderModel.finishOrderSettlementCellModelArr.count == 0 {
                            if settlementWeekListVC?.finishOrderNoDataView == nil{
                                settlementWeekListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                settlementWeekListVC?.finishOrderNoDataView.abnormalType = .noData
                            }
                        }else{
                            if settlementWeekListVC?.finishOrderNoDataView != nil{
                                settlementWeekListVC?.finishOrderNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak settlementWeekListVC] (erroModel) in
                //展示错误页
                if settlementWeekListVC?.finishOrderAbnormalView == nil{
                    settlementWeekListVC?.creatAbnormalView(isNetError: true)
                }else{
                    settlementWeekListVC?.finishOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    settlementWeekListVC?.finishOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }

}
