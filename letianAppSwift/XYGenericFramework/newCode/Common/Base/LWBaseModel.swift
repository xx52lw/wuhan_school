//
//  LWBaseModel.swift
//  Loter-swift
//
//  Created by 张星星 on 2018/3/30.
//  Copyright © 2018年 LW. All rights reserved.
//

import UIKit
import HandyJSON
class LWBaseModel: HandyJSON {
    var httpCode : Int?
    var code : Int?
    var message : String?
    var dataString : Any?
    required init() {
        
    }
}
