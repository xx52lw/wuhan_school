//
//  SellerDetailService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SellerDetailService: NSObject {

    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求商家主页详情信息数据
    func sellerDetailInfoDataRequest(target: UIViewController,merchantID:String){
        if let sellerInfoVC  = target as? SellerDetailViewController {
            
            let urlParameters = sellerDetailInfoUrl + "/" + merchantID
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak sellerInfoVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if sellerInfoVC?.sellerInfoAbnormalView != nil {
                        sellerInfoVC?.sellerInfoAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  SellerDetailModel.praseSellerDetailData(jsonData: jsonResponse)
                    sellerInfoVC?.detailModel = resultModel
                    
                    
                    DispatchQueue.main.async {
                        if sellerInfoVC?.mainScrollView == nil {
                            sellerInfoVC?.createSubViews()
                        }
                        
                    }
                }
                
            }) { [ weak sellerInfoVC] (erroModel) in
                //展示错误页
                if sellerInfoVC?.sellerInfoAbnormalView == nil{
                    sellerInfoVC?.creatAbnormalView(isNetError: true)
                }else{
                    sellerInfoVC?.sellerInfoAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    sellerInfoVC?.sellerInfoAbnormalView.abnormalType = .dataError
                }
            }
        }
    }

}
