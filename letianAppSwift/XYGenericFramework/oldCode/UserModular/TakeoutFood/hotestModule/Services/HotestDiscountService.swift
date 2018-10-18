//
//  HotestDiscountService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestDiscountService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 请求天天打折数据
    func hotestDiscountDataRequest(target: UIViewController){
        if let discountEveryDayVC  = target as? HotestDiscountVC {
            self.currentPage = 1
            
            let urlParameters = hotestDiscountUrl + "/\(self.currentPage)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak discountEveryDayVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if discountEveryDayVC?.discountAbnormalView != nil {
                        discountEveryDayVC?.discountAbnormalView.abnormalType = .none
                    }
                    
                    let hotestDiscountlModel =  HotestDiscountModel.praseHotestDiscountData(jsonData: jsonResponse)
                    
                    discountEveryDayVC?.discountModel = hotestDiscountlModel
                    
                    DispatchQueue.main.async {
                        if discountEveryDayVC?.mainTabView == nil {
                            discountEveryDayVC?.creatTableHeaderView()
                            
                            discountEveryDayVC?.creatMainTabView()
                            discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                            discountEveryDayVC?.mainTabView.reloadData()
                        }else{
                            discountEveryDayVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if discountEveryDayVC?.discountModel.cellModelArr.count == 0{
                            if discountEveryDayVC?.discountNoDataView == nil{
                                discountEveryDayVC?.creatAbnormalView(isNetError: false)
                                discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                            }else{
                                discountEveryDayVC?.discountNoDataView.abnormalType = .noData
                                discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                            }
                        }else{
                            if discountEveryDayVC?.discountNoDataView != nil {
                                discountEveryDayVC?.discountNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak discountEveryDayVC] (erroModel) in
                //展示错误页
                if discountEveryDayVC?.discountAbnormalView == nil{
                    discountEveryDayVC?.creatAbnormalView(isNetError: true)
                    discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                }else{
                    discountEveryDayVC?.discountAbnormalView.abnormalType = .networkError
                    discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                }
                if netWorkIsReachable == true{
                    discountEveryDayVC?.discountAbnormalView.abnormalType = .dataError
                    discountEveryDayVC?.view.bringSubview(toFront: discountEveryDayVC!.topView)
                }
            }
        }
    }
    
    
    //MARK: - 天天打折列表页上拉加载
    func getHotestDiscountPullListData(target: UIViewController){
        if let discountEveryDayVC  = target as? HotestDiscountVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if discountEveryDayVC.discountModel.hasNextPage == false {
                discountEveryDayVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = hotestDiscountUrl + "/\(requestPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak discountEveryDayVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let hotestDiscountlModel =  HotestDiscountModel.praseHotestDiscountData(jsonData: jsonResponse)
                    for model in hotestDiscountlModel.cellModelArr{
                        discountEveryDayVC?.discountModel.cellModelArr.append(model)
                    }
                    discountEveryDayVC?.discountModel.hasNextPage = hotestDiscountlModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        discountEveryDayVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if discountEveryDayVC?.discountModel.hasNextPage == false {                            discountEveryDayVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            discountEveryDayVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak discountEveryDayVC] (erroModel) in
                
                //上拉加载请求错误处理
                discountEveryDayVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
    
    
}
