//
//  CatsHomeService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON

//搜索商家结果排序分类
enum LTSearchType:Int {
    case distance = 1
    case saleCount = 2
    case score = 3
    case none = -1
}


class CatsHomeService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1

    
    //MARK: - 根据分类ID请求分类数据
    func catsDetailDataRequest(target: UIViewController,goodsFCatID:Int,searchType:LTSearchType){
        if let catsDetailVC  = target as? CatsViewController {
            self.currentPage = 1
            
            let urlParameters = catsDetailVC.goodsCatsUrl + "/\(goodsFCatID)/\(self.currentPage)/\(searchType.rawValue)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak catsDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if catsDetailVC?.sellerListAbnormalView != nil {
                        catsDetailVC?.sellerListAbnormalView.abnormalType = .none
                    }
                    
                    let catsDetailModel =  CatsModel.praseCatsModelData(jsonData: jsonResponse)
                    
                    catsDetailVC?.catsModel = catsDetailModel
                    
                    DispatchQueue.main.async {
                        if catsDetailVC?.mainTabView == nil {
                            catsDetailVC?.creatMainTabView()
                            catsDetailVC?.mainTabView.reloadData()
                        }else{
                            catsDetailVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if catsDetailVC?.catsModel.cellModelArr.count == 0{
                            if catsDetailVC?.sellerListNoDataView == nil{
                                catsDetailVC?.creatAbnormalView(isNetError: false)
                            }else{
                                catsDetailVC?.sellerListNoDataView.abnormalType = .noData
                            }
                        }else{
                            if catsDetailVC?.sellerListNoDataView != nil{
                                catsDetailVC?.sellerListNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak catsDetailVC] (erroModel) in
                //展示错误页
                if catsDetailVC?.sellerListAbnormalView == nil{
                    catsDetailVC?.creatAbnormalView(isNetError: true)
                }else{
                    catsDetailVC?.sellerListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    catsDetailVC?.sellerListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    //MARK: - 商家列表根据选择的类型下拉刷新
    func refreshSellerListData(target: UIViewController,goodsFCatID:Int,searchType:LTSearchType){
        if let catsDetailVC  = target as? CatsViewController {
            self.currentPage = 1
            let urlParameters = catsDetailVC.goodsCatsUrl + "/\(goodsFCatID)/\(self.currentPage)/\(searchType.rawValue)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak catsDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let catsDetailModel =  CatsModel.praseCatsModelData(jsonData: jsonResponse)
                    
                    catsDetailVC?.catsModel = catsDetailModel

                    DispatchQueue.main.async {
                        catsDetailVC?.mainTabView.mj_header.endRefreshing()
                            catsDetailVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if catsDetailVC?.catsModel.cellModelArr.count == 0{
                            if catsDetailVC?.sellerListNoDataView == nil{
                                catsDetailVC?.creatAbnormalView(isNetError: false)
                            }else{
                                catsDetailVC?.sellerListNoDataView.abnormalType = .noData
                            }
                        }else{
                            if catsDetailVC?.sellerListNoDataView != nil{
                                catsDetailVC?.sellerListNoDataView.abnormalType = .none
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak catsDetailVC] (erroModel) in
                //下拉网络请求错误处理
                catsDetailVC?.mainTabView.mj_header.endRefreshing()
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
 
    
    
    //MARK: - 分类详情商家列表页上拉加载
    func getTypePullListData(target: UIViewController,goodsFCatID:Int,searchType:LTSearchType){
        if let catsDetailVC  = target as? CatsViewController {
            //如果已经是最后一页，则不再进行上拉加载请求
            if catsDetailVC.catsModel.hasNextPage == false {
                catsDetailVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
           let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = catsDetailVC.goodsCatsUrl + "/\(goodsFCatID)/\(requestPage)/\(searchType.rawValue)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak catsDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let catsDetailModel =  CatsModel.praseCatsModelData(jsonData: jsonResponse)
                        for model in catsDetailModel.cellModelArr{
                            catsDetailVC?.catsModel.cellModelArr.append(model)
                        }
                    catsDetailVC?.catsModel.hasNextPage = catsDetailModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        catsDetailVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if catsDetailVC?.catsModel.hasNextPage == false {                            catsDetailVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            catsDetailVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak catsDetailVC] (erroModel) in
                
                //上拉加载请求错误处理
                catsDetailVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }

    
    
    
    
}





