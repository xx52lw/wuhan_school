//
//  CommonDefine.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

let IS_IPHONEX = (UIScreen.main.bounds.width == 375.0 && UIScreen.main.bounds.height == 812.0)
//屏幕适配
let SCREEN_FRAME = UIScreen.main.bounds

let SCREEN_WIDTH = UIScreen.main.bounds.width

let SCREEN_HEIGHT = UIScreen.main.bounds.height

let SCALE = SCREEN_WIDTH / 375.0

let SCALE_HEIGHT = SCREEN_HEIGHT / 667.0

let STATUSBAR_HEIGHT: CGFloat = IS_IPHONEX ? 44.0 : 20.0

let NAVBAR_HEIGHT: CGFloat = 44.0

let STATUS_NAV_HEIGHT: CGFloat =  IS_IPHONEX ? 88.0 : 64.0

let TABBAR_HEIGHT: CGFloat = IS_IPHONEX ? (49.0+34.0) : 49.0

let BOTTOM_SAFE_AREA_HEIGHT = IS_IPHONEX ? 34.0 : 0.0

//系统
let IS_IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0

let IS_IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0

let IS_IOS10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0

//是否高清屏
let isRetina = UIScreen.main.scale > 1.0

//是否iPad
let isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

//是否iPhone
let isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone

//path
let DOCUMENT_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

let CACHES_PATH = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]




class CommonDefine: NSObject {

}
