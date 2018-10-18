//
//  HotestRankService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/17.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestRankService: NSObject {

    
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    //MARK: - 请求热销排行分类数据
    func hotestRankTypeRequest(target: UIViewController){
        if let hotestRankVC  = target as? HotestRankVC {
            let urlParameters = hotestRankSearchTypeUrl
             weak var weakSelf =  self
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ unowned hotestRankVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    if hotestRankVC.rankAbnormalView != nil {
                        hotestRankVC.rankAbnormalView.abnormalType = .none
                    }
                    hotestRankVC.rankTypeModel = HotestRankTypeModel.praseRankTypeJsonData(jsonData: jsonResponse)
                    
                    weakSelf?.hotestRankGoodsDataRequest(target: hotestRankVC, typeCellModel: hotestRankVC.rankTypeModel.typesModelArr.first!)
                }
                
            }) { [ weak hotestRankVC] (erroModel) in
                //展示错误页
                if hotestRankVC?.rankAbnormalView == nil{
                    hotestRankVC?.creatAbnormalView(isNetError: true)
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }else{
                    hotestRankVC?.rankAbnormalView.abnormalType = .networkError
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }
                if netWorkIsReachable == true{
                    hotestRankVC?.rankAbnormalView.abnormalType = .dataError
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }
            }
        }
    }

    
    //MARK: - 请求热销排名商品数据
    func hotestRankGoodsDataRequest(target: UIViewController,typeCellModel:HotestRankTypeCellModel){
        if let hotestRankVC  = target as? HotestRankVC {
            self.currentPage = 1
            
            let urlParameters = hotestRankUrl + "/\(typeCellModel.typeID!)"//"/\(self.currentPage)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak hotestRankVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if hotestRankVC?.rankAbnormalView != nil {
                        hotestRankVC?.rankAbnormalView.abnormalType = .none
                    }
                    
                    let hotestRankModel =  HotestRankModel.praseRankJsonData(jsonData: jsonResponse)
                    
                    hotestRankVC?.rankModel = hotestRankModel
                    
                    DispatchQueue.main.async {
                        if hotestRankVC?.mainTabView == nil {
                            hotestRankVC?.creatTableHeaderView()
                            
                            hotestRankVC?.creatMainTabView()
                            hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                            hotestRankVC?.mainTabView.reloadData()
                        }else{
                            hotestRankVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if hotestRankVC?.rankModel.cellModelArr.count == 0{
                            if hotestRankVC?.rankNoDataView == nil{
                                hotestRankVC?.creatAbnormalView(isNetError: false)
                                hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                            }else{
                                hotestRankVC?.rankNoDataView.abnormalType = .noData
                                hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                            }
                        }else{
                            if hotestRankVC?.rankNoDataView != nil {
                                hotestRankVC?.rankNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak hotestRankVC] (erroModel) in
                //展示错误页
                if hotestRankVC?.rankAbnormalView == nil{
                    hotestRankVC?.creatAbnormalView(isNetError: true)
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }else{
                    hotestRankVC?.rankAbnormalView.abnormalType = .networkError
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }
                if netWorkIsReachable == true{
                    hotestRankVC?.rankAbnormalView.abnormalType = .dataError
                    hotestRankVC?.view.bringSubview(toFront: hotestRankVC!.topView)
                }
            }
        }
    }
    
    
    //MARK: - 热销排名列表页上拉加载
    func getHotestRankPullListData(target: UIViewController,typeCellModel:HotestRankTypeCellModel){
        if let hotestRankVC  = target as? HotestRankVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if hotestRankVC.rankModel.hasNextPage == false {
                hotestRankVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = hotestRankUrl +  "/\(typeCellModel.typeID!)"//"/\(requestPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak hotestRankVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let hotestRankModel =  HotestRankModel.praseRankJsonData(jsonData: jsonResponse)
                    for model in hotestRankModel.cellModelArr{
                        hotestRankVC?.rankModel.cellModelArr.append(model)
                    }
                    hotestRankVC?.rankModel.hasNextPage = hotestRankModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        hotestRankVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if hotestRankVC?.rankModel.hasNextPage == false {                            hotestRankVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            hotestRankVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak hotestRankVC] (erroModel) in
                
                //上拉加载请求错误处理
                hotestRankVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
    //MARK: - 根据价格筛选热销排名中的数据
    func searchRankGoodsByPrice(target: UIViewController,typeCellModel:HotestRankTypeCellModel) {
        if let hotestRankVC  = target as? HotestRankVC {
            self.currentPage = 1
            let urlParameters = hotestRankUrl +  "/\(typeCellModel.typeID!)"//"/\(currentPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak hotestRankVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let hotestRankModel =  HotestRankModel.praseRankJsonData(jsonData: jsonResponse)
                    
                    hotestRankVC?.rankModel = hotestRankModel
                    
                    DispatchQueue.main.async {
                        
                        if hotestRankVC?.rankNoDataView != nil && hotestRankVC?.rankNoDataView.abnormalType != .none{
                            hotestRankVC?.rankNoDataView.abnormalType = .none
                        }
                        
                        hotestRankVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if hotestRankVC?.rankModel.cellModelArr.count == 0{
                            if hotestRankVC?.rankNoDataView == nil{
                                hotestRankVC?.creatAbnormalView(isNetError: false)
                            }else{
                                hotestRankVC?.rankNoDataView.abnormalType = .noData
                            }
                        }else{
                            if hotestRankVC?.rankNoDataView != nil {
                                hotestRankVC?.rankNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) {  (erroModel) in
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
    
    
    
}
