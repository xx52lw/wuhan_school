//
//  SearchResultModel.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/12.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class SearchResultModel: NSObject {

    var searchGoodsCellArr:[HotestDiscountCellModel] = Array()
    var searchSellerCellArr:[TakeFoodCellModel]  = Array()
    var hasNextPage:Bool!
    
    class func praseSearchResultData(jsonData:JSON) -> SearchResultModel{
        
        let model = SearchResultModel()
        model.hasNextPage =  jsonData["data"]["HasMore"].boolValue
        
        for sellerJson in jsonData["data"]["MerchantList"].arrayValue {            model.searchSellerCellArr.append(TakeFoodCellModel.praseTakeFoodCellData(jsonData: sellerJson))
        }
        
        for cellJson in jsonData["data"]["GoodsList"].arrayValue {
            model.searchGoodsCellArr.append(HotestDiscountCellModel.praseDiscountCellData(discountCellJson:cellJson))
        }
        
        return model
    }
    
    
}


