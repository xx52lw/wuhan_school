//
//  SettlementFinishDayDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SettlementFinishDayDetailService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求日结算详细订单列表数据
    func settlementDayDetailOrderDataRequest(target: UIViewController,dayStr:String){
        if let settlementDayOrderDetailListVC  = target as? SettlementOrderListhVC {
            
            requestTool.getRequest(target: target, url:finishDayOrderListUrl + "/" + dayStr , params: nil, isShowWaiting: true, success: { [ weak settlementDayOrderDetailListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if settlementDayOrderDetailListVC?.dayOrderAbnormalView != nil {
                        settlementDayOrderDetailListVC?.dayOrderAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SettlementFinishDayDetailModel.praseSettlementFinishDayDetailData(jsonData: jsonResponse)
                    
                    settlementDayOrderDetailListVC?.dayOrderListModel = resultModel
                    
                    DispatchQueue.main.async {
                        if settlementDayOrderDetailListVC?.mainTabView == nil {
                            settlementDayOrderDetailListVC?.creatMainTabView()
                        }else{
                            settlementDayOrderDetailListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if settlementDayOrderDetailListVC?.dayOrderListModel.finishDayDetailCellModelArr.count == 0 {
                            if settlementDayOrderDetailListVC?.dayOrderNoDataView == nil{
                                settlementDayOrderDetailListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                settlementDayOrderDetailListVC?.dayOrderNoDataView.abnormalType = .noData
                            }
                        }else{
                            if settlementDayOrderDetailListVC?.dayOrderNoDataView != nil{
                                settlementDayOrderDetailListVC?.dayOrderNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak settlementDayOrderDetailListVC] (erroModel) in
                //展示错误页
                if settlementDayOrderDetailListVC?.dayOrderAbnormalView == nil{
                    settlementDayOrderDetailListVC?.creatAbnormalView(isNetError: true)
                }else{
                    settlementDayOrderDetailListVC?.dayOrderAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    settlementDayOrderDetailListVC?.dayOrderAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
}
