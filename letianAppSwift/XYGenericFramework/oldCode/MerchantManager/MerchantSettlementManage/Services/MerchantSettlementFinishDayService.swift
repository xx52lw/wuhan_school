//
//  MerchantSettlementFinishDayService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantSettlementFinishDayService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求日结算列表数据
    func settlementFinishDayDataRequest(target: UIViewController,dayRange:String){
        if let settlementDayListVC  = target as? SettlementDayListVC {
            
            requestTool.getRequest(target: target, url:finishDaySettlementUrl + "/" + dayRange , params: nil, isShowWaiting: true, success: { [ weak settlementDayListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if settlementDayListVC?.finishDayAbnormalView != nil {
                        settlementDayListVC?.finishDayAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SettlementFinishDayListModel.praseSettlementFinishDayListData(jsonData: jsonResponse)
                    
                    settlementDayListVC?.finishDayModel = resultModel
                    
                    DispatchQueue.main.async {
                        if settlementDayListVC?.mainTabView == nil {
                            settlementDayListVC?.creatMainTabView()
                        }else{
                            settlementDayListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if settlementDayListVC?.finishDayModel.finishDaySettlementCellModelArr.count == 0 {
                            if settlementDayListVC?.finishDayNoDataView == nil{
                                settlementDayListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                settlementDayListVC?.finishDayNoDataView.abnormalType = .noData
                            }
                        }else{
                            if settlementDayListVC?.finishDayNoDataView != nil{
                                settlementDayListVC?.finishDayNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak settlementDayListVC] (erroModel) in
                //展示错误页
                if settlementDayListVC?.finishDayAbnormalView == nil{
                    settlementDayListVC?.creatAbnormalView(isNetError: true)
                }else{
                    settlementDayListVC?.finishDayAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    settlementDayListVC?.finishDayAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
}
