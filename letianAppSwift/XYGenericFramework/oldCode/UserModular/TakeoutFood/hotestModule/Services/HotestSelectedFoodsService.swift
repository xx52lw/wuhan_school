//
//  HotestSelectedFoodsService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestSelectedFoodsService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 请求经济实惠数据
    func hotestSelectedFoodsDataRequest(target: UIViewController){
        if let economicalMealVC  = target as? HotestSetMenuVC {
            self.currentPage = 1
            
            let urlParameters = hotestSelectedUrl + "/\(self.currentPage)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak economicalMealVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if economicalMealVC?.economicalAbnormalView != nil {
                        economicalMealVC?.economicalAbnormalView.abnormalType = .none
                    }
                    
                    let hotestDiscountlModel =  HotestDiscountModel.praseHotestDiscountData(jsonData: jsonResponse)
                    
                    economicalMealVC?.discountModel = hotestDiscountlModel
                    
                    DispatchQueue.main.async {
                        if economicalMealVC?.mainTabView == nil {
                            economicalMealVC?.creatTableHeaderView()
                            economicalMealVC?.creatMainTabView()
                            economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                            economicalMealVC?.mainTabView.reloadData()
                        }else{
                            economicalMealVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if economicalMealVC?.discountModel.cellModelArr.count == 0{
                            if economicalMealVC?.ecnomicalNoDataView == nil{
                                economicalMealVC?.creatAbnormalView(isNetError: false)
                                economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                            }else{
                                economicalMealVC?.ecnomicalNoDataView.abnormalType = .noData
                                economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                            }
                        }else{
                            if economicalMealVC?.ecnomicalNoDataView != nil {
                                economicalMealVC?.ecnomicalNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak economicalMealVC] (erroModel) in
                //展示错误页
                if economicalMealVC?.economicalAbnormalView == nil{
                    economicalMealVC?.creatAbnormalView(isNetError: true)
                    economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                }else{
                    economicalMealVC?.economicalAbnormalView.abnormalType = .networkError
                    economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                }
                if netWorkIsReachable == true{
                    economicalMealVC?.economicalAbnormalView.abnormalType = .dataError
                    economicalMealVC?.view.bringSubview(toFront: economicalMealVC!.topView)
                }
            }
        }
    }
    
    
    
    //MARK: - 经济实惠列表页上拉加载
    func getHotestSelectedFoodsPullListData(target: UIViewController){
        if let economicalMealVC  = target as? HotestSetMenuVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if economicalMealVC.discountModel.hasNextPage == false {
                economicalMealVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = hotestSelectedUrl + "/\(requestPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak economicalMealVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let hotestDiscountlModel =  HotestDiscountModel.praseHotestDiscountData(jsonData: jsonResponse)
                    for model in hotestDiscountlModel.cellModelArr{
                        economicalMealVC?.discountModel.cellModelArr.append(model)
                    }
                    economicalMealVC?.discountModel.hasNextPage = hotestDiscountlModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        economicalMealVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if economicalMealVC?.discountModel.hasNextPage == false {                            economicalMealVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            economicalMealVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak economicalMealVC] (erroModel) in
                
                //上拉加载请求错误处理
                economicalMealVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
}
