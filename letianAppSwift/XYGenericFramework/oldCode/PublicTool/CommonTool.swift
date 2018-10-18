//
//  CommonTool.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/11.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD
import SwiftyJSON
import SDWebImage
//MARK: - 是否模拟器
func cmIsSimulator() -> Bool {
    var isSim = false
    #if arch(i386) || arch(x86_64)
        isSim = true
    #endif
    return isSim
}

//MARK: - 信息打印
func cmDebugPrint<T>(_ message: T, file: String = #file, method: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent): \(method): (\(lineNumber))---> \(message)")
    #endif
}

func cmFollowDebugPrint(file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent): \(method): (\(line))")
    #endif
}

//MARK: - 获取用户ID
func cmGetUserID() -> String?{
    return UserDefaults.standard.object(forKey: "UserId") as? String
}

//MARK: - 设置屏幕适配比
func cmSizeFloat(_ a: CGFloat) -> CGFloat {
    return a * SCALE
}

func cmSizeFloatHeight(_ a: CGFloat) -> CGFloat {
    return a * SCALE_HEIGHT
}


//MARK: - 拨打电话
 func cmMakePhoneCall(phoneStr:String){
    if let url = URL(string: "tel://" + phoneStr) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

//MARK: - 调起其它应用
 func cmOpenUrl(str:String){
    
    if let url = URL(string: str) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
}


//MARK: - 网络监听
var netWorkReachManager:AFNetworkReachabilityManager!
//当前网络是否已连接
var netWorkIsReachable:Bool?
func cmCurrentNetWorkReach(){
    netWorkReachManager = AFNetworkReachabilityManager.shared()
    netWorkReachManager.startMonitoring()
    
    netWorkReachManager.setReachabilityStatusChange { (status) in
        
        if status == .notReachable ||  status == .unknown{
            netWorkIsReachable = false
        }else{
            //连接了网络
            netWorkIsReachable = true
        }
    }
}



//时间戳转换枚举
enum  TimeStampDateFormatter:String {
    case MDHMS = "MM-dd HH:mm:ss"
    case YearMonth = "YYYY年MM月"
    case FullTime = "YYYY-MM-dd HH:mm:ss"
    case DateEnum = "YYYY/MM/dd"
    case DateType1 = "YYYY-MM-dd"
}

// MARK: - 时间戳转换
// - resultFormate: 例："MM-dd HH:mm:ss"，"YYYY年MM月"，"YYYY-MM-dd HH:mm:ss"
// - timeStampIsMillisecond: 时间戳是true是毫秒，如果是flase则为秒
func cmTimeStampToString(timeStamp:String,resultFormate:TimeStampDateFormatter,timeStampIsMillisecond:Bool)->String{
    
    if !timeStamp.isEmpty{
        let interval:TimeInterval = Double(timeStamp)! / (timeStampIsMillisecond ? 1:1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = resultFormate.rawValue
        let date = NSDate.init(timeIntervalSince1970: interval)
        dateFormatter.string(from: date as Date)
        return dateFormatter.string(from: date as Date)
    }else{
        return ""
    }
    
}

//MARK: - 直接获取当前控制器
func GetCurrentViewController() -> UIViewController? {
    var result: UIViewController?
    var window = UIApplication.shared.keyWindow
    
    if window?.windowLevel != UIWindowLevelNormal {
        let windows = UIApplication.shared.windows
        for tmpWindow in windows {
            if tmpWindow.windowLevel == UIWindowLevelNormal {
                window = tmpWindow
                break
            }
        }
    }
    
    let frontView = window?.subviews.first
    let nextResponder = frontView?.next
    
    if nextResponder is UIViewController {
        result = nextResponder as? UIViewController
    } else {
        result = window?.rootViewController
    }
    
    var topVC: UIViewController?
    if result is UITabBarController {
        let tabBarVC = result as? UITabBarController
        let navVC = tabBarVC?.selectedViewController as? UINavigationController
        topVC = navVC?.topViewController
    } else if result is UINavigationController {
        let navVC = result as? UINavigationController
        topVC = navVC?.topViewController
    } else {
        topVC = result
    }
    
    let vc = topVC?.presentedViewController
    if let _ = vc {
        if vc is UINavigationController {
            let navVC = vc as? UINavigationController
            return navVC?.topViewController
        }
        return vc
    }
    
    return topVC
}


//MARK: - 自定义toast,显示时长为2S
 func cmShowHUDToWindow(message:String)
{
    let hud:MBProgressHUD=MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
    hud.mode = MBProgressHUDMode.text
    hud.detailsLabel.textColor = UIColor.black
    hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
    hud.detailsLabel.text=message as String
    hud.label.backgroundColor = cmColorWithString(colorName: "000831", alpha: 0.6)
    hud.margin=15
    hud.layer.cornerRadius = 10.0
    hud.removeFromSuperViewOnHide=true
    hud.hide(animated: true, afterDelay: 2)
}


enum CacheType:String {
    case TakeFoodOutCache = "TakeFoodOut"
}

//MARK: - 保存缓存
func cmSaveCache(cacheType:CacheType,content:JSON){
    
    if let jsonData = try? content.rawData() {
        
        let jsonStr =  String(data: jsonData, encoding: .utf8)
        
        UserDefaults.standard.set(jsonStr, forKey: cacheType.rawValue)
        
        
    }
}


//MARK: - 读取缓存
func cmGetCache(cacheType:CacheType) -> JSON?{
    
    if let jsonStr =  UserDefaults.standard.value(forKey: cacheType.rawValue) as? String {
        
        if let jsonData = jsonStr.data(using: .utf8){
            cmDebugPrint("content------>\(JSON(data: jsonData))")
            return JSON(data: jsonData)
        }
        return nil
    }else{
        return nil
    }
    
}




//MARK: - 价格分转元
func moneyExchangeToString(moneyAmount:Int) -> String{
    
    var moneyStr = ""
    let absMoneyAmount = abs(moneyAmount)
    
    moneyStr += String(absMoneyAmount/100) + "."
    
    if absMoneyAmount%100 == 0 {
        moneyStr += "0"
    }else if absMoneyAmount%100%10 == 0 {
        moneyStr += String(absMoneyAmount%100/10)
    }else if absMoneyAmount%100 < 10 {
        moneyStr = moneyStr + "0" + String(absMoneyAmount%100)
    }else{
       moneyStr = moneyStr + String(absMoneyAmount%100)
    }
    
    if moneyAmount < 0 {
        moneyStr = "-" + moneyStr
    }
    
    return moneyStr
    
}

//MARK: - 价格分转元如果为整数元则不带小数
func moneyExchangeToStringTwo(moneyAmount:Int) -> String{
    
    var moneyStr = ""
    let absMoneyAmount = abs(moneyAmount)
    moneyStr += String(absMoneyAmount/100)
    
    if absMoneyAmount%100 == 0 {
        return moneyStr
    }else if absMoneyAmount%100%10 == 0 {
        moneyStr = moneyStr + "." +  String(absMoneyAmount%100/10)
    }else if absMoneyAmount%100 < 10 {
        moneyStr = moneyStr + ".0" + String(absMoneyAmount%100)
    }else{
        moneyStr = moneyStr + ".0" + String(absMoneyAmount%100)
    }
    if moneyAmount < 0 {
        moneyStr = "-" + moneyStr
    }
    return moneyStr
    
}


//MARK: - 用户角色相关
enum UserRoleEnum {
    case ExpressManager  //众包管理员
    case Merchant        //商家
    case MerchantDeliver //商家配送员
    case User            //用户
    case UserDeliver     //众包配送员
    case Guest           //游客
    case none            //未登录
}
//MARK: - 全局角色设置
func saveUserRoleInfo(roleStr:String) {

    UserDefaults.standard.set(roleStr, forKey: "userRole")
}
//MARK: - 获取用户角色
func getUserRole() -> UserRoleEnum {
    if let roleSTR = UserDefaults.standard.value(forKey: "userRole") as? String {
        switch roleSTR {
        case "ExpressManager":
            return .ExpressManager
        case "Merchant":
            return .Merchant
        case "MerchantDeliver":
            return .MerchantDeliver
        case "User":
            return .User
        case "UserDeliver":
            return .UserDeliver
        case "Guest":
            return .Guest
        default:
            return .none
        }
    }else{
        return .none
    }
}

//MARK: - 登录信息保存
func saveLoginInfo(model:UserInfoSettingModel) {
    UserDefaults.standard.set(model.nickName, forKey: "loginName")
    UserDefaults.standard.set(model.userName, forKey: "userName")
    UserDefaults.standard.set(model.avatarUrl, forKey: "avatarUrl")
    UserDefaults.standard.set(model.userTel, forKey: "userTel")
    UserDefaults.standard.set(model.selectedAreaModel.areaCode, forKey: "areaCode")
    UserDefaults.standard.set(model.selectedCityModel.cityName, forKey: "selectedCity")
    UserDefaults.standard.set(model.selectedAreaModel.expressPoints, forKey: "areaGeoHashStr")
    
}



//MARK: - 获取登录信息
func getLoginInfo() -> UserInfoModel {
    let userInfoModel = UserInfoModel()
    userInfoModel.loginName = UserDefaults.standard.value(forKey: "loginName") as? String
    userInfoModel.userName = UserDefaults.standard.value(forKey: "userName") as? String
    userInfoModel.avatarUrl = UserDefaults.standard.value(forKey: "avatarUrl") as? String
    userInfoModel.userTel =  UserDefaults.standard.value(forKey: "userTel") as? String
    userInfoModel.areaCode =  UserDefaults.standard.value(forKey: "areaCode") as? Int
    userInfoModel.selectedCity = UserDefaults.standard.value(forKey: "selectedCity") as? String
    userInfoModel.areaGeoHashStr = UserDefaults.standard.value(forKey: "areaGeoHashStr") as? String
    return userInfoModel
}

//MARK: - 清除登录信息
func removeLoginInfo() {
    UserDefaults.standard.removeObject(forKey: "loginName")
    UserDefaults.standard.removeObject(forKey: "userName")
    UserDefaults.standard.removeObject(forKey: "avatarUrl")
    UserDefaults.standard.removeObject(forKey: "userTel")
    UserDefaults.standard.removeObject(forKey: "areaCode")
    UserDefaults.standard.removeObject(forKey: "selectedCity")
    UserDefaults.standard.removeObject(forKey: "areaGeoHashStr")
    //退出登录时将角色信息一并清除
     UserDefaults.standard.removeObject(forKey: "userRole")
}

//MARK: - 退出登录
func loginOutApp(){
    
    removeLoginInfo()
    removeTokenInfo()
    let loginVC = LoginViewController()
    //上一个界面是配送员系统设置页，则close游客模式
    let navVCCount = GetCurrentViewController()!.navigationController!.viewControllers.count
    if  let _ = GetCurrentViewController()?.navigationController?.viewControllers[navVCCount - 1] as? StaffSystemSettingHomePageVC {
        loginVC.isCloseVister = true
    }
    
    if  let _ = GetCurrentViewController()?.navigationController?.viewControllers[navVCCount - 1] as? MerchantSystemSettingHomeVC {
        loginVC.isCloseVister = true
    }
    GetCurrentViewController()?.navigationController?.pushViewController(loginVC, animated: true)
    
}

//MARK: - 是否登录
func isLogined() -> Bool{
    if getLoginInfo().loginName != nil || getUserRole() != .none {
        
        if getUserRole() == .Guest {
            return false
        }else{
            return true
        }
    }else{
        return false
    }
}


//MARK: - 检查是否登录，没有登录跳转登录界面
func checkLoginStatusAndAct(){
    if isLogined() == false {
        removeLoginInfo()
        removeTokenInfo()
        let loginVC = LoginViewController()
        loginVC.loginSucessClosure = {
            GetCurrentViewController()?.navigationController?.popViewController(animated: true)
        }
        GetCurrentViewController()?.navigationController?.pushViewController(loginVC, animated: true)
    }
}


//MARK: - 网络请求错误统一处理
func netWorkRequestAct(_ erroJson:JSON) {
    switch erroJson["code"].stringValue {
    case requestCode2:
        cmShowHUDToWindow(message:"请先注册到一个区域")
        break
    case requestCode4:
        cmShowHUDToWindow(message:"数据过期，请刷新重试")
        break
    case requestCode6:
        cmShowHUDToWindow(message:"地址不在区域范围内")
        break
    case requestCode7:
        cmShowHUDToWindow(message:"当前为商家休息时间")
        break
    case requestCode8:
        cmShowHUDToWindow(message:"商家暂停营业了")
        break
    case requestCode9:
        cmShowHUDToWindow(message:"超过限制购买数量")
        break
    case requestCode10:
        cmShowHUDToWindow(message:"没有达到起送额度")
        break
    case requestCode11:
        cmShowHUDToWindow(message:"营业暂停和开启至少间隔30分钟")
        break
    case requestCode12:
        //cmShowHUDToWindow(message:"上传失败")
        break
    case requestCode17:
        cmShowHUDToWindow(message:"不能选择尽快送达")
        break
    case requestCode13:
        cmShowHUDToWindow(message:"商品停售或下架了")
        break
    case requestCode20:
        cmShowHUDToWindow(message:"登录名已经存在")
        break
    case requestCode401:
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        //cmShowHUDToWindow(message:"认证失败，请登录")
        break
    case requestCode400:
        cmShowHUDToWindow(message:"用户名或密码不正确")
        break
    case requestCode403:
        cmShowHUDToWindow(message:"用户尚未注册")
        break
    default:
        cmShowHUDToWindow(message:DATA_ERROR_TIPS)
        break
    }
}


//MARK: - 性别字符串返回
func cmGetGenderStr(gender:Int) -> String {
    var genderStr = ""
    if gender == 1 {
        genderStr = "先生"
    }else{
        genderStr = "女士"
    }
    return genderStr
}

//MARK: - 清理所有缓存
func CleanCache(completion: @escaping () -> () ) {
    CleanImageCache {
        CleanLibraryCache(completion: completion)
    }
}

//MARK: - 清理SDWebImage缓存
func CleanImageCache(completion: @escaping SDWebImageNoParamsBlock) {
    SDImageCache.shared().clearDisk(onCompletion: completion)
}
//MARK: - 清理系统缓存
func CleanLibraryCache(completion: @escaping () -> ()) {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: path) {
        completion()
    }
    
    let childFiles = fileManager.subpaths(atPath: path)
    guard let files = childFiles else {
        completion()
        return
    }
    
    DispatchQueue.global().async {
        for file in files {
            let filePath = path.appending("/\(file)")
            if fileManager.fileExists(atPath: filePath) {
                try? fileManager.removeItem(atPath: filePath)
            }
        }
        DispatchQueue.main.async {
            completion()
        }
    }
}


//获取SDWebImage缓存大小
func GetImageCacheSize() -> UInt {
    return SDImageCache.shared().getSize()
}

//MARK: - 获取系统资源缓存大小
func GetLibraryCacheSize() -> UInt {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: path) {
        return 0
    }
    
    let childFiles = fileManager.subpaths(atPath: path)
    guard let files = childFiles else {
        return 0
    }
    
    var folderSize: UInt = 0
    for file in files {
        let filePath = path.appending("/\(file)")
        if fileManager.fileExists(atPath: filePath) {
            do {
                let size = try fileManager.attributesOfItem(atPath: filePath)[.size]
                if let fileSize = size as? UInt {
                    folderSize += fileSize
                }
            } catch {
                folderSize += 0
            }
        } else {
            folderSize += 0
        }
    }
    
    return folderSize
}
//MARK: - 获取系统与SDWebImage缓存大小
func GetCacheSize(cacheSize: @escaping (UInt) -> ()) {
    DispatchQueue.global().async {
        let size = GetImageCacheSize() + GetLibraryCacheSize()
        DispatchQueue.main.async {
            cacheSize(size)
        }
    }
}


class UserInfoModel: NSObject {
    
    var loginName:String?
     var userName:String?
    var avatarUrl:String?
    var userTel:String?
    var areaCode:Int?
    var selectedCity:String?
    var areaGeoHashStr:String?
}


//MARK: - APP 完整时间格式处理
func timeStrFormate(timeStr:String) -> String{
    if timeStr.count >= 19 {
       return timeStr[0..<19].replacingOccurrences(of: "T", with: " ")
    }else{
        return ""
    }
}

//MARK: - APP 日期时间处理
func dateStrFormate(timeStr:String) -> String{
    if timeStr.count >= 11 {
        return timeStr[0..<11]
    }else{
        return ""
    }
}


class CommonTool: NSObject {

}
