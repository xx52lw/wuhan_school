//
//  LWListenNetworkTool.swift
//  LoterSwift
//
//  Created by liwei on 2018/9/28.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
import Alamofire
// ===============================================================================================================================================
// MARK: - 检测网络工具状态枚举
@objc enum LWListenNetworkToolStatus : Int {
    /// 开始监听
    case beginListen
    /// 网络不可达
    case notReachable
    /// 未知网络
    case unknown
    /// WiFi网络
    case ethernetOrWiFi
    /// 蜂窝网络
    case wwan
    /// 暂停监听
    case stopListen
}

// ===============================================================================================================================================
// MARK: - 检测网络工具
class LWListenNetworkTool: NSObject {

   private let networkReachabilityManager = Alamofire.NetworkReachabilityManager()
   private static let instance = LWListenNetworkTool()
    // MARK: 共享单例
    /// 共享单例
    class func sharedInstance() -> LWListenNetworkTool {
        return instance
    }
    
    // MARK: 开始监听网络变化
    /// 开始监听网络变化
    func beginListenNetworkChange() {
        networkReachabilityManager?.listener = { status in
            
            switch status {
                case .notReachable: do { //print("网络不可达")
                    LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.notReachable)
                    break
                }
                case .unknown: do {//print("未知网络")
                    LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.unknown)
                }
                case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi): do { //print("WiFi网络")
                    LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.ethernetOrWiFi)
                    break
                }
                case .reachable(NetworkReachabilityManager.ConnectionType.wwan): do{ //print("蜂窝网络")
                    LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.wwan)
                    break
                }
            }
        }
        networkReachabilityManager?.startListening()
        LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.beginListen)
    }
    // MARK: 关闭网络监听
    /// 关闭网络监听
    func stopListenNetwork() {
        networkReachabilityManager?.stopListening()
        LWPOSTNotification(NotificationName: LWListenNetworkNotification, object: LWListenNetworkToolStatus.stopListen)
    }
    
}
// ===============================================================================================================================================
