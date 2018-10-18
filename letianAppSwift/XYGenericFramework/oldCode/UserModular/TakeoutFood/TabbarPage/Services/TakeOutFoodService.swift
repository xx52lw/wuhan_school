//
//  TakeOutFoodService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class TakeOutFoodService: NSObject {
    
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //MARK: - 请求外卖首页数据
    func takefoodOutDataRequest(target: UIViewController){
        if let homePageVC  = target as? TakeOutFoodVC {

            requestTool.getRequest(target: target, url:takeFoodOutHomepageUrl , params: nil, isShowWaiting: true, success: { [ weak homePageVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let homepageModel =  TakeFoodModel.praseTakeFoodData(jsonData: jsonResponse)
                    
                    homePageVC?.takeFoodModel = homepageModel
                    currentSelectedAdress = homepageModel.currentAdress
                    
                    DispatchQueue.main.async {
                        
                        if homePageVC?.topView == nil {
                            homePageVC?.creatNavTopView()
                        }
                        
                        if homePageVC?.tableHeaderView == nil {
                            homePageVC?.creatTableHeaderView()
                        }
                        if homePageVC?.mainTabView == nil {
                            homePageVC?.creatMainTabView()
                            homePageVC?.mainTabView.reloadData()
                        }else{
                            homePageVC?.mainTabView.reloadData()
                        }
                    }
                }
                
            }) { [ weak homePageVC] (erroModel) in
                //没有缓存展示错误页
                if homePageVC?.takefoodOutAbnormalView == nil{
                    homePageVC?.creatAbnormalView(isNetError: true)
                }else{
                    homePageVC?.takefoodOutAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    homePageVC?.takefoodOutAbnormalView.abnormalType = .dataError
                    
                }
            }
        }
    }
    
    //MARK: - 外卖首页数据下拉刷新
    func refreshTakeFoodOutData(target: UIViewController){
        if let homePageVC  = target as? TakeOutFoodVC {
            requestTool.getRequest(target: target, url:takeFoodOutHomepageUrl , params: nil, isShowWaiting: false, success: { [ weak homePageVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let homepageModel = TakeFoodModel.praseTakeFoodData(jsonData: jsonResponse)
                    
                    homePageVC?.takeFoodModel = homepageModel
                    currentSelectedAdress = homepageModel.currentAdress

                    DispatchQueue.main.async {
                        //停止刷新
                        homePageVC?.mainTabView.mj_header.endRefreshing()
                        homePageVC?.mainTabView.reloadData()
                        homePageVC?.refreshCurrentLocation()
                    }
                }
                
            }) { [ weak homePageVC] (erroModel) in
                //下拉网络请求错误处理
                homePageVC?.mainTabView.mj_header.endRefreshing()
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
}
