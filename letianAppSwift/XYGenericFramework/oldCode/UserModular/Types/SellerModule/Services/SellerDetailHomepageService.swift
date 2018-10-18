//
//  SellerDetailHomepageService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerDetailHomepageService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 商家首页数据
    func sellerDetailHomepageDataRequest(target: UIViewController,merchantID:String){
        if let sellerDetailHomepageVC  = target as? SellerDetailPageVC {
            
            let urlParameters = sellerDetailUrl + "/\(merchantID)"
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak sellerDetailHomepageVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if sellerDetailHomepageVC?.sellerDetailHomepageAbnormalView != nil {
                        sellerDetailHomepageVC?.sellerDetailHomepageAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SellerHomePageModel.praseSellerHomepageData(jsonData: jsonResponse)
                    
                    sellerDetailHomepageVC?.sellerHomepageModel = resultModel
                    
                    //将购物车当中已买的商品数据数量同步到当前页面的cell当中
                    for index in 0..<sellerDetailHomepageVC!.sellerHomepageModel.typeAndGoodsModelDicArr.count {
                        for shopcartTempModel in sellerDetailHomepageVC!.sellerHomepageModel.shopcartModelArr {
                            for goodsCellIndex in 0..<sellerDetailHomepageVC!.sellerHomepageModel.typeAndGoodsModelDicArr[index].values.first!.count {
                                if shopcartTempModel.goodsID == sellerDetailHomepageVC!.sellerHomepageModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].goodsID {
                                    
                                    sellerDetailHomepageVC!.sellerHomepageModel.typeAndGoodsModelDicArr[index].values.first![goodsCellIndex].selectedCount += shopcartTempModel.selectedCount
                                    break
                                }
                            }
                        }
                    }
                    SellerDetailPageVC.shopVCSellerHomeCommonModel = sellerDetailHomepageVC?.sellerHomepageModel

                    
                    DispatchQueue.main.async {
                        sellerDetailHomepageVC?.setupView()
                    }
                }
                
            }) { [ weak sellerDetailHomepageVC] (erroModel) in
                //展示错误页
                if sellerDetailHomepageVC?.sellerDetailHomepageAbnormalView == nil{
                    sellerDetailHomepageVC?.creatAbnormalView(isNetError: true)
                }else{
                    sellerDetailHomepageVC?.sellerDetailHomepageAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    sellerDetailHomepageVC?.sellerDetailHomepageAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    
    //MARK: - 收藏商家
    func collectMerchantRequest(merchantId:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = merchantId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = collectMerchantUrl + "/" + encodeId!
        requestTool.postRequest(target: nil, url:urlPrameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"收藏失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
}
