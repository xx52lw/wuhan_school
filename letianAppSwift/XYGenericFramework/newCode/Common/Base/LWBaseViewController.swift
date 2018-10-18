//
//  LWBaseViewController.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ================================================================================================================================
// MARK: - 基类视图控制器
class LWBaseViewController: UIViewController {

    /// 是否允许拖拽（默认允许）
    var allPopGestureRecognizer = true
    /// 导航栏背景图片
    var navBgImage : UIImage?
    
    //MARK: - 重写viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - 重写viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.colorFromHex(hex: LWAppConfigurationModel.sharedInstance().defaultControllerBgColor)
        // 使其从导航条下绘制
        navigationController?.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
//        self.automaticallyAdjustsScrollViewInsets = true;
        
        checkLeftBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNotifty()
        setnNav()
    }
    //MARK: - 重写viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotify()
    }
    deinit {
        removeNotify()
    }
   
    //MARK: 检查返回按钮
    private func checkLeftBar() {
       
        guard let leftBarButtonItems = navigationItem.leftBarButtonItems else {
            return
        }
        for item in leftBarButtonItems {
            if item.tag == 666 {
                guard let leftView = item.customView else {
                    return
                }
                if leftView.isKind(of: UIButton.self) {
                    let leftBtn = leftView as! UIButton
                    leftBtn .addTarget(self, action: #selector(backAction), for: UIControl.Event.touchUpInside)
                }
                break
            }
        }
        
    }
    //MARK: 返回按钮点击
    /// 返回按钮点击
    @objc func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    // MARK: 移除通知
    /// 移除通知
    func removeNotify() {
        LWRemoveNotification(self, NotificationName: LWListenNetworkNotification)
    }
    // MARK: 添加通知
    /// 添加通知
    func addNotifty() {
        removeNotify()
        LWAddNotification(self, selector: #selector(listenNetworkChangeFun(notify:)), NotificationName: LWListenNetworkNotification)
        
    }
    //MARK: 设置导航条
    func setnNav() {
        guard let bar = self.navigationController?.navigationBar else {
            return
        }
        bar.barStyle = UIBarStyle.black // 设置成白色
        //设置标题栏文字
        let navbgColor = LWAppConfigurationModel.sharedInstance().navbgColor
        if navbgColor.count > 0 {
            navBgImage = UIImage.imageMarginImage(size:  CGSize.init(width: LWAppScreenWidth, height: 64.0), origionImage: UIImage.imageDrawWithColor(color: UIColor.colorFromHex(hex: navbgColor), size: CGSize.init(width: 1.0, height: 1.0))!)
        }
        else {
            navBgImage = UIImage.imageMarginImage(size:  CGSize.init(width: LWAppScreenWidth, height: 64.0), origionImage: UIImage.init(named: "nav_bg")!)
        }
        // 这里导航栏透明，可以把navBgImage = UIImage(),和导航栏穿透效果改变
        bar.setBackgroundImage(navBgImage, for: UIBarMetrics.default)
        //设置标题栏文字
        var navTitleColor = LWAppConfigurationModel.sharedInstance().navTitleColor
        if navTitleColor.count <= 0 {
            navTitleColor = "#000000"
        }
        self.navigationController?.navigationBar.tintColor = UIColor.colorFromHex(hex: navTitleColor)
        var titleFont = LWAppConfigurationModel.sharedInstance().navTitleFont
        if titleFont.count <= 0 {
            titleFont = "18"
        }
         // 导航栏底线颜色
        let  navBottomLineColor = LWAppConfigurationModel.sharedInstance().navBottomLineColor
        if navBottomLineColor.count <= 0 {
            bar.shadowImage = UIImage.imageDrawWithColor(color: UIColor.clear, size: CGSize.init(width: 1.0, height: 1.0))
            
        }
        else {
            bar.shadowImage = UIImage.imageDrawWithColor(color: UIColor.colorFromHex(hex: navBottomLineColor), size: CGSize.init(width: 1.0, height: 1.0))
        }
        
        bar.setTitleVerticalPositionAdjustment(0, for: UIBarMetrics.default)
        let attributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: CGFloat(Double(titleFont)!)),NSAttributedString.Key.foregroundColor : UIColor.colorFromHex(hex: navTitleColor)]
        bar.titleTextAttributes = attributes
        
    }
   
    // MARK:  网络状态改变的方法
    ///
    @objc func listenNetworkChangeFun(notify : NSNotification) {
        
        guard let status = notify.object as? LWListenNetworkToolStatus else {
            return
        }
        switch status {
        case .beginListen: do {
               print("开始监听")
            }
        case .notReachable: do { //
            print("网络不可达")
            }
        case .unknown: do {//
            print("未知网络")
            }
        case .ethernetOrWiFi: do { //
            print("WiFi网络")
            }
        case .wwan: do{
            print("蜂窝网络")
            }
        case .stopListen: do {
            print("停止监听")
            }
        }
    }
     
}
// ================================================================================================================================
