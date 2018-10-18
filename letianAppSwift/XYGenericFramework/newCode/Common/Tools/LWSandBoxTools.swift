//
//  LWSandBoxTools.swift
//  LoterSwift
//
//  Created by liwei on 2018/7/2.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ==================================================================================================================
/// 沙盒工具方法
class LWSandBoxTools: NSObject {

    /// 获得主目录(程序主目录，可见子目录(3个):Documents、Library、tmp)
    class func getHomePath() -> String {
        return NSHomeDirectory()
    }
    /// 获得document目录(文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据)
    class func getDocPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    /// 获得library目录(配置目录，配置文件存这里)
    class func getLibraryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    /// 获得caches目录(缓存目录，系统永远不会删除这里的文件，ITUNES会删除)
    class func getCachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    /// 获得temp目录(临时缓存目录，APP退出后，系统可能会删除这里的内容)
    class func getTempPath() -> String {
        return NSTemporaryDirectory()
    }
    
    
    /// 向沙盒写入文件(NS类型)
    class func writeDataToSandBox(_ pathString : String , name: String, data : AnyObject, dataType:NSString) {
        if String.stringIsEmpty(pathString) || String.stringIsEmpty(name) {
            return
        }
        let path : String = pathString + "/" + name
        
        if dataType.isEqual(to: "NSString") {
            let str : String = data as! String
            try! str.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        }
        else if dataType.isEqual(to: "NSArray") {
            let arr : NSArray = data as! NSArray
            try! arr.write(toFile: path, atomically: true)
        }
        else if dataType.isEqual(to: "NSDictionary") {
            let dict : NSDictionary = data as! NSDictionary
            try! dict.write(toFile: path, atomically: true)
        }
        else if dataType.isEqual(to: "NSData") {
            let da : NSData = data as! NSData
            try! da.write(toFile: path, atomically: true)
        }

    }
    /// 读取沙河文件(NS类型)
    class func readDataFromSandBox(_ pathString : String , name: String , dataType:NSString) ->  AnyObject {
        if String.stringIsEmpty(pathString) || String.stringIsEmpty(name) {
            return NSNull()
        }
        let path : String = pathString + "/" + name
        if dataType.isEqual(to: "NSString") {
            return try! NSString.init(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
        }
        else if dataType.isEqual(to: "NSArray") {
            return try! NSArray.init(contentsOfFile: path)!
        }
        else if dataType.isEqual(to: "NSDictionary") {
            return try! NSDictionary.init(contentsOfFile: path)!
        }
        else if dataType.isEqual(to: "NSData") {
            return try! NSData.init(contentsOfFile: path)!
        }
        else {
            return NSNull()
        }
    }
    
}
// ==================================================================================================================
