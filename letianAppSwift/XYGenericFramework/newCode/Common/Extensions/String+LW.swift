//
//  String+LW.swift
//  LoterSwift
//
//  Created by liwei on 2018/7/2.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
// ==================================================================================================================
/// string拓展方法
extension String {

    
    /// string 是否有内容
    static func stringIsEmpty(_ string : String) -> Bool{

        if string.count <= 0 {
            return true
        }
        else {
            return false
        }

    }
}
// ==================================================================================================================
