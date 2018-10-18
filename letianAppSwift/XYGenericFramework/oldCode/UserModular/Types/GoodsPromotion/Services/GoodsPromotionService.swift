//
//  GoodsPromotionService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class GoodsPromotionService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求商家主页活动数据
    func sellerPromotionDataRequest(target: UIViewController,merchantID:String){
        if let sellerPromotionVC  = target as? GoodsPromotionTableViewController {
            
            let urlParameters = sellerPromotionUrl + "/" + merchantID
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak sellerPromotionVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if sellerPromotionVC?.promotionAbnormalView != nil {
                        sellerPromotionVC?.promotionAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  GoodsPromotionModel.praseGoodsPromotionData(jsonData: jsonResponse)
                    sellerPromotionVC?.promotionModel = resultModel

                    
                    DispatchQueue.main.async {
                        if sellerPromotionVC?.mainTableView == nil {
                            sellerPromotionVC?.creatTableView()
                            sellerPromotionVC?.mainTableView.reloadData()
                            
                        }else{
                            sellerPromotionVC?.mainTableView.reloadData()
                        }
                        
                        //无数据
                        if sellerPromotionVC?.promotionModel.cellModelArr.count == 0{
                            
                        }
                        
                        
                    }
                }
                
            }) { [ weak sellerPromotionVC] (erroModel) in
                //展示错误页
                if sellerPromotionVC?.promotionAbnormalView == nil{
                    sellerPromotionVC?.creatAbnormalView(isNetError: true)
                }else{
                    sellerPromotionVC?.promotionAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    sellerPromotionVC?.promotionAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    
    //MARK: - 获取优惠
    func getSellerPromotionRequest(target: UIViewController,promotionID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void){
        
        let urlParameters = getSellerPromotionUrl + "/\(promotionID)"
        requestTool.getRequest(target: nil, url:urlParameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
                cmShowHUDToWindow(message:"领取成功")
            }
            
        }) {  (erroModel) in
            
            failureAct()
            if netWorkIsReachable == true{
                if let erroJson = erroModel.response as? JSON {
                    netWorkRequestAct(erroJson)
                    return
                }
                cmShowHUDToWindow(message:"领取失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
}
