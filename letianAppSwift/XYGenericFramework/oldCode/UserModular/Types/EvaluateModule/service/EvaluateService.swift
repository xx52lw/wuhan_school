//
//  EvaluateService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class EvaluateService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 请求商家主页评论数据
    func sellerEvaluatesDataRequest(target: UIViewController,merchantID:String){
        if let sellerEvaluateVC  = target as? EvaluateVC {
            self.currentPage = 1
            
            let urlParameters = sellerEvaluateHomeUrl + "/" + merchantID
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak sellerEvaluateVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if sellerEvaluateVC?.evaluateAbnormalView != nil {
                        sellerEvaluateVC?.evaluateAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  EvaluateModel.praseEvaluateData(jsonData: jsonResponse)
                    
                    
                    DispatchQueue.main.async {
                        if sellerEvaluateVC?.evaluateView == nil {
                            sellerEvaluateVC?.evaluateModel = resultModel
                            sellerEvaluateVC?.creatEvaluateView()

                        }else{
                            sellerEvaluateVC?.evaluateView.evaluateModel = resultModel
                            sellerEvaluateVC?.evaluateView.evaluateTableView.reloadData()
                        }
                        
                        //无数据
                        if sellerEvaluateVC?.evaluateView.evaluateModel.cellModelArr.count == 0{

                        }
                        
                        
                    }
                }
                
            }) { [ weak sellerEvaluateVC] (erroModel) in
                //展示错误页
                if sellerEvaluateVC?.evaluateAbnormalView == nil{
                    sellerEvaluateVC?.creatAbnormalView(isNetError: true)
                }else{
                    sellerEvaluateVC?.evaluateAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    sellerEvaluateVC?.evaluateAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 商家主页评论上拉加载
    func sellerEvaluatesPullListData(target: UIViewController,merchantID:String){
        if let sellerEvaluateVC  = target as? EvaluateVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if sellerEvaluateVC.evaluateView.evaluateModel.hasNextPage == false {
                sellerEvaluateVC.evaluateView.evaluateTableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = sellerEvaluateHomeUrl + "/" + merchantID + "/\(requestPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak sellerEvaluateVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let resultModel =  EvaluateModel.praseEvaluatePullData(jsonData: jsonResponse)
                    for model in resultModel.cellModelArr{
                        sellerEvaluateVC?.evaluateView.evaluateModel.cellModelArr.append(model)
                    }
                    sellerEvaluateVC?.evaluateView.evaluateModel.hasNextPage = resultModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        sellerEvaluateVC?.evaluateView.evaluateTableView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if sellerEvaluateVC?.evaluateView.evaluateModel.hasNextPage == false {
                            sellerEvaluateVC?.evaluateView.evaluateTableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            sellerEvaluateVC?.evaluateView.evaluateTableView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak sellerEvaluateVC] (erroModel) in
                
                //上拉加载请求错误处理
                sellerEvaluateVC?.evaluateView.evaluateTableView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
    
    
}
