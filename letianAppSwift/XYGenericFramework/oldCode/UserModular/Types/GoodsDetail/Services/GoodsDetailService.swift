//
//  GoodsDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class GoodsDetailService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    //当前页
    private var currentPage:Int = 1
    
    
    //MARK: - 请求商品详情数据
    func goodsDetailDataRequest(target: UIViewController,goodsID:String){
        if let goodsDetailVC  = target as? ShowGoodsDetailVC {
            self.currentPage = 1
            
            let urlParameters = goodsDetailUrl + "/" + goodsID
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak goodsDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if goodsDetailVC?.goodsDetailAbnormalView != nil {
                        goodsDetailVC?.goodsDetailAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  GoodsDetailShowModel.praseGoodsDetailShowData(jsonData: jsonResponse)
                    
                    goodsDetailVC?.goodsDetailShowModel = resultModel
                    goodsDetailVC?.goodsDetailShowModel.selectedCount =  goodsDetailVC!.currentGoodsSelectedNum
                    DispatchQueue.main.async {
                        if goodsDetailVC?.mainTabView == nil {
                            goodsDetailVC?.creatMainTabView()
                            goodsDetailVC?.view.bringSubview(toFront: goodsDetailVC!.topView)
                            
                        }else{
                            goodsDetailVC?.mainTabView.reloadData()
                        }
                        
                        //无数据
                        if goodsDetailVC?.goodsDetailShowModel.goodsDetailEvaluateArr.count == 0{
                            
                        }
                        
                        
                    }
                }
                
            }) { [ weak goodsDetailVC] (erroModel) in
                //展示错误页
                if goodsDetailVC?.goodsDetailAbnormalView == nil{
                    goodsDetailVC?.creatAbnormalView(isNetError: true)
                    goodsDetailVC?.view.bringSubview(toFront: goodsDetailVC!.topView)
                }else{
                    goodsDetailVC?.goodsDetailAbnormalView.abnormalType = .networkError
                    goodsDetailVC?.view.bringSubview(toFront: goodsDetailVC!.topView)
                }
                if netWorkIsReachable == true{
                    goodsDetailVC?.goodsDetailAbnormalView.abnormalType = .dataError
                    goodsDetailVC?.view.bringSubview(toFront: goodsDetailVC!.topView)
                }
            }
        }
    }
    
    
    //MARK: - 商家商品评论上拉加载
    func goodsEvaluatesPullListData(target: UIViewController,goodsID:String){
        if let goodsDetailVC  = target as? ShowGoodsDetailVC {
            //如果已经是最后一页，则不再进行上拉加载请求
            if goodsDetailVC.goodsDetailShowModel.hasNextPage == false {
                goodsDetailVC.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let requestPage =  self.currentPage + 1
            //如果不是最后一页则进行数据请求
            let urlParameters = goodsCommentsUrl + "/" + goodsID + "/\(requestPage)"
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: false, success: { [ weak goodsDetailVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    let resultModel =  EvaluateModel.praseEvaluatePullData(jsonData: jsonResponse)
                    for model in resultModel.cellModelArr{
                        goodsDetailVC?.goodsDetailShowModel.goodsDetailEvaluateArr.append(model)
                    }
                    goodsDetailVC?.goodsDetailShowModel.hasNextPage = resultModel.hasNextPage
                    DispatchQueue.main.async {
                        //数据加载
                        goodsDetailVC?.mainTabView.reloadData()
                        //当请求到最后一页时，调用endRefreshingWithNoMoreData
                        if goodsDetailVC?.goodsDetailShowModel.hasNextPage == false {
                            goodsDetailVC?.mainTabView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            //请求成功才将当前页加1
                            self.currentPage += 1
                            goodsDetailVC?.mainTabView.mj_footer.endRefreshing()
                        }
                    }
                    
                }
                
            }) { [ weak goodsDetailVC] (erroModel) in
                
                //上拉加载请求错误处理
                goodsDetailVC?.mainTabView.mj_footer.endRefreshing()
                
                if netWorkIsReachable == true{
                    cmShowHUDToWindow(message:DATA_ERROR_TIPS)
                }else{
                    cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
                }
            }
            
        }
        
    }
}
