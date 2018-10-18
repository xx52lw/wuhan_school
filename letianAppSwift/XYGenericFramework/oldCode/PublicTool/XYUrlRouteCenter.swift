//
//  XYUrlRouteCenter.swift
//  commonProject
//
//  Created by 103 on 2017/2/25.
//  Copyright © 2017年 test. All rights reserved.
//

import UIKit


let  xyUrlRouteCenter = XYUrlRouteCenter()
class XYUrlRouteCenter: NSObject {

    //MARK: - 通过类名返回VC
    func findVCWithUrlKey(key:String,extraParams:Dictionary<String,Any>?) -> UIViewController?{
        
        if key.isEmpty {
            return nil
        }
        
        guard  let resultClass = xyClassFromSring(classStr: key) else {
            return nil
        }
        
         cmDebugPrint("\(resultClass)")
        //如果为VC类型，则转为VC类型
        if resultClass is UIViewController.Type{
            
            guard let classType = resultClass as? UIViewController.Type else{
                cmDebugPrint( "无法转成目标类型")
                return nil
            }
            
            //如果子类重写了该方法，可在该子类里面创建一个该类，并返回出来，同时将参数传过去，实现解耦
            return classType.createdRouteVCWithParams(dicParams: extraParams)
        }else{
            return nil
        }

        
        
    }
    
    
    //MARK: - 通过类名找到类
    func xyClassFromSring(classStr:String) -> AnyClass?{
        
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            cmDebugPrint("--->命名空间不存在")
            return nil
        }
        
        let classResult:AnyClass? = NSClassFromString((nameSpace as! String) + "." + classStr)
        
        return classResult
        
    }
    
    
    //MARK: - 重新设置类的属性
    func  xySetClassFromString(classStr:String,dicParams:Dictionary<String,Any>?,targetVC:UIViewController) -> UIViewController? {
        
        
        guard  let resultClass = xyClassFromSring(classStr: classStr) else {
            return nil
        }
        
        if resultClass is UIViewController.Type{
            
            guard let classType = resultClass as? UIViewController.Type else{
                cmDebugPrint("无法转成目标类型")
                return nil
            }

            if targetVC.classForCoder == resultClass{
                return classType.setRouteVCWithParams(dicParams: dicParams, targetVC: targetVC)
            }else{
                return nil
            }
        
        
        }else{
            return nil
        }
        
    }
    
    
}



extension UIViewController{
    
    class func createdRouteVCWithParams(dicParams:Dictionary<String,Any>?) -> UIViewController?{
        return nil
    }
    
    class func setRouteVCWithParams(dicParams:Dictionary<String,Any>?,targetVC:UIViewController) -> UIViewController? {
        return nil
    }
    
}

