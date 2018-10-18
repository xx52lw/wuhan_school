//
//  SearchSellerGoodsService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/11.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SearchSellerGoodsService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 搜索历史记录请求
    func searchHistoryRequest(target: UIViewController){
        if let searchHistoryVC  = target as? SearchViewController {
            
            requestTool.getRequest(target: target, url:searchHistoryUrl, params: nil, isShowWaiting: true, success: { [ weak searchHistoryVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    for cellJosn in jsonResponse["data"].arrayValue {
                        searchHistoryVC?.SearchArr.append(cellJosn.stringValue)
                    }
                    
                    DispatchQueue.main.async {
                        if searchHistoryVC?.searchTable == nil {
                            searchHistoryVC?.CreateSearchTable()
                            searchHistoryVC?.searchTable.reloadData()
                        }else{
                            searchHistoryVC?.searchTable.reloadData()
                        }
                    }
                }
                
            }) {  (erroModel) in
                if netWorkIsReachable == true{
                    if let erroJson = erroModel.response as? JSON {
                        netWorkRequestAct(erroJson)
                        return
                    }
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
        }
    }

    
    //MARK: - 删除历史记录
    func deleteSearchHistoryRequest(successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        requestTool.deleteRequest(target: nil, url:deleteHistoryUrl, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"清除失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    //MARK: - 根据关键字请求分类数据
    func searchSellerRequest(target: UIViewController,keyWord:String,searchType:LTSearchType){
        if let searchResultVC  = target as? SearchResultVC {
            self.currentPage = 1
            
             var urlParameters = ""
            
            let noWhiteSpaceStr = keyWord.trimmingCharacters(in: .whitespaces)
            
            if searchResultVC.searchType == 0{
                urlParameters = searchSellerUrl + "/\(noWhiteSpaceStr)/\(self.currentPage)/\(searchType.rawValue)"
            }else{
                urlParameters = searchGoodsUrl + "/\(noWhiteSpaceStr)/\(self.currentPage)/\(searchType.rawValue)"
            }
            
            
            requestTool.getRequest(target: target, url:urlParameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, params: nil, isShowWaiting: true, success: { [ weak searchResultVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if searchResultVC?.sellerListAbnormalView != nil {
                        searchResultVC?.sellerListAbnormalView.abnormalType = .none
                    }
                    
                    let sellerListModel =  SearchResultModel.praseSearchResultData(jsonData: jsonResponse)
                    
                    searchResultVC?.searchModel = sellerListModel
                    
                    DispatchQueue.main.async {
                        if searchResultVC?.mainTabView == nil {
                            searchResultVC?.creatMainTabView()
                            searchResultVC?.mainTabView.reloadData()
                        }else{
                            searchResultVC?.mainTabView.reloadData()
                        }
                        
                        //无数据展示无数据页面
                        if searchResultVC?.searchType == 0{
                            if searchResultVC?.searchModel.searchSellerCellArr.count == 0{
                                if searchResultVC?.sellerListNoDataView == nil{
                                    searchResultVC?.creatAbnormalView(isNetError: false)
                                }else{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .noData
                                }
                            }else{
                                if searchResultVC?.sellerListNoDataView != nil{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .none
                                }
                            }
                        }else{
                            if searchResultVC?.searchModel.searchGoodsCellArr.count == 0{
                                if searchResultVC?.sellerListNoDataView == nil{
                                    searchResultVC?.creatAbnormalView(isNetError: false)
                                }else{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .noData
                                }
                            }else{
                                if searchResultVC?.sellerListNoDataView != nil{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .none
                                }
                            }
                        }
                        
                    }
                }
                
            }) { [ weak searchResultVC] (erroModel) in
                //展示错误页
                if searchResultVC?.sellerListAbnormalView == nil{
                    searchResultVC?.creatAbnormalView(isNetError: true)
                }else{
                    searchResultVC?.sellerListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    searchResultVC?.sellerListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    //MARK: - 商家列表根据选择的类型下拉刷新
    func refreshSellerListData(target: UIViewController,keyWord:String,searchType:LTSearchType){
        if let searchResultVC  = target as? SearchResultVC {
            self.currentPage = 1
            
            let noWhiteSpaceStr = keyWord.trimmingCharacters(in: .whitespaces)

            var urlParameters = ""
            if searchResultVC.searchType == 0{
                urlParameters = searchSellerUrl + "/\(noWhiteSpaceStr)/\(self.currentPage)/\(searchType.rawValue)"
            }else{
                urlParameters = searchGoodsUrl + "/\(noWhiteSpaceStr)/\(self.currentPage)/\(searchType.rawValue)"
            }
            
            requestTool.getRequest(target: target, url:urlParameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! , params: nil, isShowWaiting: false, success: { [ weak searchResultVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    let sellerListModel =  SearchResultModel.praseSearchResultData(jsonData: jsonResponse)
                    
                    searchResultVC?.searchModel = sellerListModel
                    
                    DispatchQueue.main.async {
                        searchResultVC?.mainTabView.mj_header.endRefreshing()
                        searchResultVC?.mainTabView.reloadData()
                        
                        //无数据展示无数据页面
                        if searchResultVC?.searchType == 0{
                            if searchResultVC?.searchModel.searchSellerCellArr.count == 0{
                                if searchResultVC?.sellerListNoDataView == nil{
                                    searchResultVC?.creatAbnormalView(isNetError: false)
                                }else{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .noData
                                }
                            }else{
                                if searchResultVC?.sellerListNoDataView != nil {
                                    searchResultVC?.sellerListNoDataView.abnormalType = .none
                                }
                            }
                        }else{
                            if searchResultVC?.searchModel.searchGoodsCellArr.count == 0{
                                if searchResultVC?.sellerListNoDataView == nil{
                                    searchResultVC?.creatAbnormalView(isNetError: false)
                                }else{
                                    searchResultVC?.sellerListNoDataView.abnormalType = .noData
                                }
                            }else{
                                if searchResultVC?.sellerListNoDataView != nil {
                                    searchResultVC?.sellerListNoDataView.abnormalType = .none
                                }
                            }
                        }
                        
                    }
                }
                
            }) { [ weak searchResultVC] (erroModel) in
                //下拉网络请求错误处理
                searchResultVC?.mainTabView.mj_header.endRefreshing()
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
    
    //MARK: - 分类详情商家列表页上拉加载
    func getTypePullSellerListData(target: UIViewController,keyWord:String,searchType:LTSearchType){
        if let searchResultVC  = target as? SearchResultVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if searchResultVC.searchModel.hasNextPage == false {
                searchResultVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let noWhiteSpaceStr = keyWord.trimmingCharacters(in: .whitespaces)

            var urlParameters = ""
            if searchResultVC.searchType == 0{
                urlParameters = searchSellerUrl + "/\(noWhiteSpaceStr)/\(requestPage)/\(searchType.rawValue)"
            }else{
                urlParameters = searchGoodsUrl + "/\(noWhiteSpaceStr)/\(requestPage)/\(searchType.rawValue)"
            }
            
            requestTool.getRequest(target: target, url:urlParameters.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: urlParameters).inverted)! , params: nil, isShowWaiting: false, success: { [ weak searchResultVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let sellerListModel =  SearchResultModel.praseSearchResultData(jsonData: jsonResponse)
                    for model in sellerListModel.searchSellerCellArr{
                        searchResultVC?.searchModel.searchSellerCellArr.append(model)
                    }
                    searchResultVC?.searchModel.hasNextPage = sellerListModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        searchResultVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if searchResultVC?.searchModel.hasNextPage == false {                            searchResultVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            searchResultVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak searchResultVC] (erroModel) in
                
                //上拉加载请求错误处理
                searchResultVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    

    
}
