//
//  NetRequestTool.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

//请求数据成功码
let requestSuccessCode = "200"
let requestCodeAuthFailed = "401" //认证失败，请登录
let requestCodeServiceFailed = "500" //服务器异常
let requestCode0 = "0" //系统忙，请稍后再试
let requestCode1 = "1" //请检查参数
let requestCode2 = "2" //请先注册到一个区域
let requestCode3 = "3" //找不到数据，请刷新重试
let requestCode4 = "4" //数据过期，请刷新重试
let requestCode5 = "5" //无需重复操作
let requestCode6 = "6" //地址不在区域范围内
let requestCode7 = "7" //当前为商家休息时间
let requestCode8 = "8" //商家暂停营业了
let requestCode9 = "9" //超过限制购买数量
let requestCode10 = "10" //没有达到起送额度
let requestCode11 = "11" //营业暂停和开启至少间隔30分钟
let requestCode12 = "12" //上传失败
let requestCode13 = "13" //商品停售或下架了
let requestCode17 = "17" //不能选择尽快送达
let requestCode20 = "20" //登录名已经存在
let passwordErroCode22 = "22" //原始密码错误
let wechatHasBeBinded21 = "21" //微信已经被绑定
let requestCode400 = "400" //用户名或密码不正确
let requestCode401 = "401" //认证失败，请登录
let requestCode403 = "403" //用户尚未注册


var netManager = NetworkingSessionManager()
let noTokenNetManager  = noTokenNetWorkingSessionManager()

//MARK: - 登录角色变更时需要重新设置Token
func resetNetManagerToken(){
    netManager = NetworkingSessionManager()
}

func NetworkingSessionManager() -> AFHTTPSessionManager {
    let sessionManager = AFHTTPSessionManager()
    sessionManager.requestSerializer.timeoutInterval = 30
    getToken()
    //MARK: - 在请求头当中添加Token
    if commonTokenStr != nil {
    sessionManager.requestSerializer.setValue("Bearer " + commonTokenStr!, forHTTPHeaderField: "Authorization")
    }
    sessionManager.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/html"]
    return sessionManager
}

func noTokenNetWorkingSessionManager() -> AFHTTPSessionManager {
    let sessionManager = AFHTTPSessionManager()
    sessionManager.requestSerializer.timeoutInterval = 30
    sessionManager.responseSerializer.acceptableContentTypes = ["application/json", "text/json", "text/html"]
    return sessionManager
}


func LoadingAnimationView() -> XYLoadingAnimationView {
    let loadingView = XYLoadingAnimationView(frame: CGRect(x: UIScreen.main.bounds.size.width/2-25, y: UIScreen.main.bounds.size.height/2 - 5 - STATUS_NAV_HEIGHT, width: 50, height: 10))
    return loadingView
}

class NetworkRequestTool: NSObject {
    
    
    
    
    typealias RequestSuccessReback = (CommandSuccessModel) -> ()
    
    typealias RequestFailReback = (CommandErrorModel) -> ()
    
    typealias UploadProgressReback = (Float) -> ()
    
    typealias UploadResultParseReback = (JSON,Int) -> (Dictionary<String,Any>)
    //网络超时时长
    let netOutTime:TimeInterval = 20
    //网络请求manager
    //网络加载动画
    
    //如果需要设置加载时遮罩的区域，请设置loadingAnimationView.loadMaskView的frame
    
    //MARK: - POST请求
    func postRequest(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {
        //Token验证，如果不存在token，不进行验证
        if !tokenIsValid() {
            cmShowHUDToWindow(message: "验证失败")
            return
        }
        
        let loadingAnimationView = LoadingAnimationView()
        //如果有加载动画
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        //网络请求
        netManager.post(EnvironmentConfig.currentDomainUrl + url, parameters: params, progress: nil, success: { (task, response) in
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                cmDebugPrint(json)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }, failure: { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        })
    }
    

    
    
    
    //MARK: - POST请求(无token)
    func postRequestNoToken(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {

        
        let loadingAnimationView = LoadingAnimationView()
        //如果有加载动画
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        //网络请求
        noTokenNetManager.post(EnvironmentConfig.currentDomainUrl + url, parameters: params, progress: nil, success: { (task, response) in
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                cmDebugPrint(json)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }, failure: { (task, error) in
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        })
    }
    
    //MARK: - 无token验证，无code验证Post请求

    func postRequstNoTokenAndCode(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {
        
        
        //如果有加载动画
        let loadingAnimationView = LoadingAnimationView()
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        noTokenNetManager.post(EnvironmentConfig.currentDomainUrl + url, parameters: params, progress: nil, success: { (task, response) in
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }) { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }
    }
    
    
    
    //MARK: - 无token验证get请求
    func getRequstNoToken(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {

        
        //如果有加载动画
        let loadingAnimationView = LoadingAnimationView()
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        noTokenNetManager.get(EnvironmentConfig.currentDomainUrl + url, parameters: params, progress: nil, success: { (task, response) in
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }) { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }
    }
    
    
    
    
    
    //MARK: - GET请求
    
    func getRequest(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {
        
        //Token验证，如果不存在token，不进行验证
        if !tokenIsValid() {
            return
        }
        
        //如果有加载动画
        let loadingAnimationView = LoadingAnimationView()
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        netManager.get(EnvironmentConfig.currentDomainUrl + url, parameters: params, progress: nil, success: { (task, response) in
            cmDebugPrint(response)
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }) { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }
    }
    
    
    
    
    //MARK: - Put请求
    func putRequest(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {
        //Token验证，如果不存在token，不进行验证
        if !tokenIsValid() {
            cmShowHUDToWindow(message: "验证失败")
            return
        }
        
        let loadingAnimationView = LoadingAnimationView()
        //如果有加载动画
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        //网络请求
        netManager.put(EnvironmentConfig.currentDomainUrl + url, parameters: params, success: { (task, response) in
            
            //cmDebugPrint(response)
            
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                cmDebugPrint(json)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }) { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }

    }
    
    //MARK: - Delete请求
    func deleteRequest(target: UIViewController?, url: String, params: [String: Any]?, isShowWaiting: Bool, success: @escaping RequestSuccessReback, faile: @escaping RequestFailReback) {
        //Token验证，如果不存在token，不进行验证
        if !tokenIsValid() {
            cmShowHUDToWindow(message: "验证失败")
            return
        }
        
        let loadingAnimationView = LoadingAnimationView()
        //如果有加载动画
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        //网络请求
        netManager.delete(EnvironmentConfig.currentDomainUrl + url, parameters: params, success: { (task, response) in
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                cmDebugPrint(json)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: params, response: json)
                    success(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faile(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        }, failure: { (task, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: params, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faile(commandError)
            
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
        })
    }
    
    
    
    //MARK: - 同步上传多张图片
    func uploadPicsSync(target: UIViewController?,url: String,isShowWaiting: Bool,chooseImageArr:[UIImage], successAct:@escaping RequestSuccessReback ,faileAct: @escaping RequestFailReback,parameters: [String: Any]?){
        //Token验证，如果不存在token，不进行验证
        if !tokenIsValid() {
            cmShowHUDToWindow(message: "验证失败")
            return
        }
        //如果有加载动画
        let loadingAnimationView = LoadingAnimationView()
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        netManager.post(EnvironmentConfig.currentDomainUrl + url, parameters: nil, constructingBodyWith: { (data) in
            
            
            if let dataStr = (parameters!["UserOrderID"] as? String)?.data(using: .utf8) {
                data.appendPart(withForm:dataStr , name: "UserOrderID")
                
            }
            
            
            for i in 0..<chooseImageArr.count
            {
                let images = chooseImageArr[i]
                let imagedata:Data = UIImageJPEGRepresentation(images, 0.6)!
                data.appendPart(withFileData: imagedata as Data, name: "file"+"\(i)", fileName: "fileName.png", mimeType: "img/png")
            }
        }, progress: { (progress) in
            //cmDebugPrint("已经上传图片进度--->\(progress.completedUnitCount * 100/progress.totalUnitCount)%" )
            
        }, success: { (operation, response) in
            cmDebugPrint(response)
            if let dict = (response as? [String: Any]) {
                let json = JSON(dict)
                if json["code"].stringValue == requestSuccessCode{
                    let commandSuccess = CommandSuccessModel(url, params: nil, response: json)
                    successAct(commandSuccess)
                }else{
                    let commandError = CommandErrorModel(url, params: nil, errorMessage: ErrorMessage(.ReponseDataError)!, errorCode: .ReponseDataError, response: json)
                    faileAct(commandError)
                }
            }
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
            
        }, failure: { (operation, error) in
            cmDebugPrint(error)
            let commandError = CommandErrorModel(url, params: nil, errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: "")
            faileAct(commandError)
            
            if isShowWaiting {
                loadingAnimationView.startAnimation = false
            }
            //print("请求错误",error)
        })
        
    }
    
    
    //MARK: - 异步上传多张图片
    func uploadPicsAsync(target: UIViewController?,url: String,isShowWaiting: Bool,imageArr:[UIImage], success:@escaping RequestSuccessReback ,faile: @escaping RequestFailReback,parseResposeReback:@escaping UploadResultParseReback){
        
        //如果有加载动画
        let loadingAnimationView = LoadingAnimationView()
        if isShowWaiting == true {
            loadingAnimationView.startAnimationAction()
            target?.view.addSubview(loadingAnimationView)
            target?.view.addSubview(loadingAnimationView.loadMaskView)
        }
        
        let sema:DispatchSemaphore = DispatchSemaphore.init(value: 0)
        //通过count计数，只有当获得所有的图片路径后算是上传成功，发送信号，否则线程一直等待
        var count = 0
        var  chooseImageUrlArray:[String] = Array()
        var  asynChooseImageUrlArray:[Dictionary<String,Any>] = Array()
        
        DispatchQueue.global().async {
            
            for index in 0..<imageArr.count
            {
                netManager.post(url, parameters: nil, constructingBodyWith: { (data) in
                    let images = imageArr[index]
                    let imagedata:Data = UIImagePNGRepresentation(images)! as Data
                    data.appendPart(withFileData: imagedata as Data, name: "file"+"\(index)", fileName: "fileName.png", mimeType: "img/png")
                    
                }, progress: { (progress) in
                    
                }, success: { (operation, response) in
                    print("image.index---->",index)
                    if let dict = (response as? [String: Any]) {
                        let json = JSON(dict)
                        if json["code"].stringValue == requestSuccessCode {
                            //将上传成功的数据丢出去进行解析，此处解析必须将解析出来的URL与Index进行绑定
                            asynChooseImageUrlArray.append(parseResposeReback(json, index))
                            count += 1
                            if count == imageArr.count{
                                sema.signal()
                            }
                        }
                    }
                    
                    
                }, failure: { (operation, error) in
                    //netManager.operationQueue.cancelAllOperations()
                    //只要有一张上传失败则立即提示上传失败
                    sema.signal()
                })
            }
            //只有当收到信号signal时才会继续执行下面的代码，否则会一直等待
            sema.wait()
            //只有当待上传图片与已上传图片获取的URL数量一致时才证明上传图片已经成功，将异步获得的URL按选择的图片顺序排序
            if imageArr.count == asynChooseImageUrlArray.count{
            for indexOfUrl in 0..<asynChooseImageUrlArray.count{
                for index in 0..<imageArr.count{
                    let tempDic = asynChooseImageUrlArray[index]
                    if tempDic["index"] as! Int == indexOfUrl{
                        chooseImageUrlArray.append(tempDic["url"] as! String)
                        break
                    }
                }
            }
            
            let commandSuccess = CommandSuccessModel(url, params: Dictionary(), response: JSON(chooseImageUrlArray))
                success(commandSuccess)
            }else{
                let commandError = CommandErrorModel(url, params: Dictionary(), errorMessage: ErrorMessage(.NetworkRequestFail)!, errorCode: .NetworkRequestFail, response: JSON(chooseImageUrlArray))
                faile(commandError)
            }
            DispatchQueue.main.async {
                if isShowWaiting {
                    loadingAnimationView.startAnimation = false
                }
                
            }
            
        }
        
    }


    

    
}









