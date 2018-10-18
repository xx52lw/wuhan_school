//
//  EnvironmentConfig.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/7.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import Foundation

let REQUEST_URL = ""

//图片域名
let PIC_DOMAIN_URL = "https://xy.ltedu.net/"

class EnvironmentConfig: NSObject {
    
    enum Environment {
        case TEST_ENV               //测试环境
        case PRE_RELEASE_ENV        //预发布环境
        case RELEASE_ENV            //生产环境
    }
    
    //MARK: - 请求域名
    //测试环境
    private static let TEST_DOMAIN_URL = "https://xy.ltedu.net/"
    //预发布环境
    private static let PRE_RELEASE_DOMAIN_URL = "https://xy.ltedu.net/"
    //生产环境
    private static let RELEASE_DOMAIN_URL = "https://118.31.10.222/"
    
    //MARK: - 分享域名
    //测试环境
    private static let TEST_SHARE_DOMAIN_URL = "https://xy.ltedu.net/"
    //预发布环境
    private static let PRE_RELEASE_SHARE_DOMAIN_URL = "https://xy.ltedu.net/"
    //生产环境
    private static let RELEASE_SHARE_DOMAIN_URL = "https://118.31.10.222/"
    
    //MARK: - 当前环境
    static let currentEnvironment: Environment = Environment.TEST_ENV
    
    //MARK: - 根据当前环境得到的域名及链接
    class var currentDomainUrl: String {
        switch currentEnvironment {
        case .TEST_ENV:             return TEST_DOMAIN_URL
        case .PRE_RELEASE_ENV:      return PRE_RELEASE_DOMAIN_URL
        case .RELEASE_ENV:          return RELEASE_DOMAIN_URL
        }
    }
    
    class var currentShareDomainUrl: String {
        switch currentEnvironment {
        case .TEST_ENV:             return TEST_SHARE_DOMAIN_URL
        case .PRE_RELEASE_ENV:      return PRE_RELEASE_SHARE_DOMAIN_URL
        case .RELEASE_ENV:          return RELEASE_SHARE_DOMAIN_URL
        }
    }
    
    override init() {
        super.init()
    }
}










struct FileConfig {
    
    var fileData: Data          //文件数据
    
    var name: String            //服务器接受参数名
    
    var fileName: String        //文件名
    
    var fileType: String        //文件类型
    
    init(_ fileData: Data, _ name: String, _ fileName: String, _ fileType: String) {
        
        self.fileData = fileData
        
        self.name = name
        
        self.fileName = fileName
        
        self.fileType = fileType
        
        descirption()
    }
    
    func descirption() {
        cmDebugPrint("FileConfig: fileData: \(fileData), name: \(name), fileName: \(fileName), fileType: \(fileType)")
    }
}

struct CommandSuccessModel {
    
    var url: String
    
    var params: [String: Any]?
    
    var response: Any
    
    init(_ url: String, params: [String: Any]?, response: Any) {
        
        self.url = url
        
        self.params = params
        
        self.response = response
        
        showRequestInfo()
    }
    
    func showRequestInfo() {
        if params == nil {
        cmDebugPrint("CommandSuccess: url:\(url), params:nil, reponse: \(response)")
        }else{
         cmDebugPrint("CommandSuccess: url:\(url), params: \(params!), reponse: \(response)")
        }
    }
}

struct CommandErrorModel {
    
    var url: String
    
    var params: [String: Any]?
    
    var errorMessage: String?
    
    var errorCode: CommandErrorOptions
    
    var response: Any

    
    init(_ url: String, params: [String: Any]?, errorMessage: String?, errorCode: CommandErrorOptions,response:Any) {
        self.url = url
        
        self.params = params
        
        self.errorMessage = errorMessage
        
        self.errorCode = errorCode
        
        self.response = response

        
        showRequestErroInfo()
    }
    
    func showRequestErroInfo() {
        if params == nil {
        cmDebugPrint("CommandError: url:\(url), params: nil, errorCode:\(errorCode), errorMessage:\(String(describing: errorMessage))")
        }else{
         cmDebugPrint("CommandError: url:\(url), params: \(params!), errorCode:\(errorCode), errorMessage:\(String(describing: errorMessage))")
        }
    }
}

struct CommandErrorOptions: OptionSet {
    var rawValue: Int64
    
    init(rawValue: Int64) {
        self.rawValue = rawValue
    }
    static var UnknowError = CommandErrorOptions(rawValue:1<<1)
    static var JSONFromatterSupportError = CommandErrorOptions (rawValue: 1<<2)
    static var NetworkRequestFail = CommandErrorOptions(rawValue: 1<<3)
    static var ReponseDataError = CommandErrorOptions(rawValue: 1<<4)
    static var JSONSerializationError = CommandErrorOptions (rawValue: 1<<5)
}

func ErrorMessage(_ errorCode: CommandErrorOptions) -> String? {
    
    var errorMessage: String? = nil
    
    switch errorCode.rawValue {
    case CommandErrorOptions.UnknowError.rawValue:
        errorMessage = "未知错误"
    case CommandErrorOptions.JSONFromatterSupportError.rawValue:
        errorMessage = "JSON格式不正确"
    case CommandErrorOptions.NetworkRequestFail.rawValue:
        errorMessage = "网络请求失败"
    case CommandErrorOptions.ReponseDataError.rawValue:
        errorMessage = "响应数据错误"
    case CommandErrorOptions.JSONSerializationError.rawValue:
        errorMessage = "JSON解析失败"
    default:
        errorMessage = nil
    }
    
    return errorMessage
}
