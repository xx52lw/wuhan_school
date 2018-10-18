//
//  MessageListService.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class MessageListService: NSObject {
    //网络请求工具
    private var requestTool = NetworkRequestTool()
    
    //MARK: - 请求消息列表
    func getMessageListRequest(target: UIViewController){
        if let messageListVC  = target as? MessagesListVC {
            
            let urlParameters = messageListUrl
            
            requestTool.getRequest(target: target, url:urlParameters , params: nil, isShowWaiting: true, success: { [ weak messageListVC] (sucessModel) in
                if let jsonResponse = sucessModel.response as? JSON{
                    
                    
                    if messageListVC?.messageListAbnormalView != nil {
                        messageListVC?.messageListAbnormalView.abnormalType = .none
                    }
                    
                    let resultModel =  MessageListModel.praseMessageListData(jsonData: jsonResponse)//MessageListModel.testdata()//
                    messageListVC?.messageListModel = resultModel
                    
                    
                    DispatchQueue.main.async {
                        if messageListVC?.mainTabView == nil {
                            messageListVC?.creatMainTabView()
                            
                        }else{
                            messageListVC?.mainTabView.reloadData()
                        }
                        
                        //无数据
                        if messageListVC?.messageListModel.cellModelArr.count == 0{
                            if messageListVC?.messageListNoDataView == nil{
                                messageListVC?.creatAbnormalView(isNetError: false)
                            }else{
                                messageListVC?.messageListNoDataView.abnormalType = .noData
                            }
                        }
                        
                        
                    }
                }
                
            }) { [ weak messageListVC] (erroModel) in
                //展示错误页
                if messageListVC?.messageListAbnormalView == nil{
                    messageListVC?.creatAbnormalView(isNetError: true)
                }else{
                    messageListVC?.messageListAbnormalView.abnormalType = .networkError
                }
                if netWorkIsReachable == true{
                    messageListVC?.messageListAbnormalView.abnormalType = .dataError
                }
            }
        }
    }
    
    //MARK: - 删除消息
    func deleteMessageRequest(messageID:String,successAct:@escaping ()->Void,failureAct:@escaping ()->Void) {
        let encodeId = messageID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlPrameters = deleteMessageUrl + "/" + encodeId!
        requestTool.deleteRequest(target: nil, url:urlPrameters, params: nil, isShowWaiting: true, success: {  (sucessModel) in
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
                cmShowHUDToWindow(message:"删除失败")
            }else{
                cmShowHUDToWindow(message:NET_WORK_ERROR_TIPS)
            }
        }
    }
    
    
    
}
