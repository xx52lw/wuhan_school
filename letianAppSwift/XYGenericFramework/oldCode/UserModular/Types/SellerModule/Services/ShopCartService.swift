//
//  ShopCartService.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class ShopCartService: NSObject {

    
    //网络请求工具
    private var requestTool = NetworkRequestTool()

    //MARK: - 增加购物车
    func shopcartAddGoodsRequest(targetVC:UIViewController,goodsSpuid:String,addNum:Int,successAct:@escaping ([ShopcartModel])->Void,fialureAct:@escaping ()->Void){
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["ID"] = goodsSpuid
        paramsDict["Num"] = addNum
        requestTool.putRequest(target: targetVC, url:shopCartAddGoodsUrl , params: paramsDict, isShowWaiting: true, success: { (sucessModel) in
            if let jsonResponse = sucessModel.response as? JSON{
                let resultModelArr =  ShopcartModel.praseAddShopcartData(jsonData: jsonResponse)
                successAct(resultModelArr)
            }
            
        }) {  (erroModel) in
            fialureAct()
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
    
    //MARK: - 清空购物车
    func removeShopcartAllGoodsRequest(merchantID:String,successAct:@escaping ()->Void,fialureAct:@escaping ()->Void){
        
        let urlParameters = removeShopcartAllGoodsUrl + "/\(merchantID)"
        
        requestTool.getRequest(target: nil, url:urlParameters , params: nil, isShowWaiting: true, success: { (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            fialureAct()
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
    
    
    //MARK: 更新购物车
    func updatesShopcartRequest(targetVC:UIViewController,shopcartID:String,updateNum:Int,successAct:@escaping ()->Void,fialureAct:@escaping ()->Void){
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["ShopCartID"] = shopcartID
        paramsDict["Num"] = updateNum
        
        requestTool.postRequest(target: targetVC, url:updateShopcartUrl , params: paramsDict, isShowWaiting: true, success: { (sucessModel) in
            if let _ = sucessModel.response as? JSON{
                successAct()
            }
            
        }) {  (erroModel) in
            fialureAct()
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
