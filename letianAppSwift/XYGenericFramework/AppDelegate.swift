//
//  AppDelegate.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

//后台下载完成后处理闭包
typealias HanderCompletion = () -> Void


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {
    
    var window: UIWindow?
    var handler:HanderCompletion!
    var mapManager:BMKMapManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        self.CreatTabbarItem()
        cmCurrentNetWorkReach()
        creatWeixinKey()
        creatBaiduMap()
        
        self.window?.makeKeyAndVisible()
        
        createGuideView()
        
        return true
    }

    //MARK: - 引导页
    func createGuideView(){
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        if isFristOpen == nil {
        let scrollView = APPGuideScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.window?.addSubview(scrollView)
        }
    }
    
    
    //MARK: - 创建微信授权
    func creatWeixinKey() {
        //向微信注册
        WXApi.registerApp(weixinApiKey)
        
    }
    
    //MARK: -创建根视图
    func CreatTabbarItem(){
        let takeoutFood_nav = UINavigationController(rootViewController: TakeOutFoodVC())
        let foodTypes_nav = UINavigationController(rootViewController: FoodTypesViewController())
        let orderManageVC = OrderManageVC()
        orderManageVC.isOrderListHomePage = true
        let orders_nav = UINavigationController(rootViewController: orderManageVC)
        let userCenter_nav = UINavigationController(rootViewController: UserCenterViewController())
        
        
        let barCtr:UITabBarController = UITabBarController.init()
        barCtr.view.backgroundColor = UIColor.clear
        
        takeoutFood_nav.tabBarItem.image = #imageLiteral(resourceName: "tabTakeOutFoodUnselected").withRenderingMode(.alwaysOriginal)
        foodTypes_nav.tabBarItem.image = #imageLiteral(resourceName: "tabTypesUnselected").withRenderingMode(.alwaysOriginal)
        orders_nav.tabBarItem.image = #imageLiteral(resourceName: "tabOrdersUnselected").withRenderingMode(.alwaysOriginal)
        userCenter_nav.tabBarItem.image = #imageLiteral(resourceName: "tabMineUnselected").withRenderingMode(.alwaysOriginal)
        
        takeoutFood_nav.tabBarItem.selectedImage = #imageLiteral(resourceName: "tabTakeOutFood").withRenderingMode(.alwaysOriginal)
        foodTypes_nav.tabBarItem.selectedImage = #imageLiteral(resourceName: "tabTypes").withRenderingMode(.alwaysOriginal)
        orders_nav.tabBarItem.selectedImage = #imageLiteral(resourceName: "tabOrders").withRenderingMode(.alwaysOriginal)
        userCenter_nav.tabBarItem.selectedImage = #imageLiteral(resourceName: "tabMine").withRenderingMode(.alwaysOriginal)
        
        
        takeoutFood_nav.tabBarItem.title = "外卖"
        foodTypes_nav.tabBarItem.title = "分类"
        orders_nav.tabBarItem.title = "订单"
        userCenter_nav.tabBarItem.title = "我的"
        
        let VCS = [takeoutFood_nav,foodTypes_nav,orders_nav,userCenter_nav]
        barCtr.viewControllers = VCS
        self.window?.rootViewController = barCtr
  

        
        let  tabbars = barCtr.tabBar
        
        for item in tabbars.items! as [UITabBarItem]{
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: MAIN_BLACK2],for:.normal)
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: MAIN_BLUE], for:UIControlState.selected)
            
        }
        
    }

    
    func creatBaiduMap(){
        mapManager = BMKMapManager()
        let ret = mapManager?.start(baiduKey, generalDelegate: nil)
        if ret == false{
            print("百度地图开始失败")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//MARK: - 后台下载上传完成处理
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
        cmDebugPrint("下载结束啦") 
        self.handler = completionHandler
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        //登录授权返回
        if let authResp = resp as? SendAuthResp {
            cmDebugPrint(authResp.code)
            
            if clickWechatIsBinding == true {
                if authResp.code != nil {
                    LoginRegisterService().bindingWeixinRequest(code: authResp.code)
                }
                clickWechatIsBinding = false
            }else {
                if authResp.code != nil {
                    LoginRegisterService().getTokenDataFromWxLogin(code: authResp.code)
                }
            }
        }
    }
    
}

