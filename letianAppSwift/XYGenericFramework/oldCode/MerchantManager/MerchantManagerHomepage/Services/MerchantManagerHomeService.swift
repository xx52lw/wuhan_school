//
//  MerchantManagerHomeService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MerchantManagerHomeService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    func getMerchantManagerHomepageRequest(target: UIViewController) {
        if let merchantManagerVC  = target as? MerchantManagerHomepageVC {
            
            requestTool.getRequest(target: target, url:merchantManagerHompageUrl, params: nil, isShowWaiting: true, success: {  [ weak merchantManagerVC] (sucessModel) in
                if let jsonData = sucessModel.response as? JSON{
                    
                    if merchantManagerVC?.merchantManagerAbnormalView != nil {
                        merchantManagerVC?.merchantManagerAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel = MerchantManagerHomepageModel.praseMerchantManagerHomeData(jsonData: jsonData)
                    
                    merchantManagerVC?.merchantManagerModel = resultModel
                    
                    DispatchQueue.main.async {
                        merchantManagerVC?.refreshUI()
                    }
                    
                }
                
                
            }) {  [weak merchantManagerVC] (erroModel) in
                
                //展示错误页
                if merchantManagerVC?.merchantManagerAbnormalView == nil{
                    merchantManagerVC?.creatAbnormalView()
                }else{
                    merchantManagerVC?.merchantManagerAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    merchantManagerVC?.merchantManagerAbnormalView.abnormalType = .dataError
                }
                
            }
        }
    }
    
}
