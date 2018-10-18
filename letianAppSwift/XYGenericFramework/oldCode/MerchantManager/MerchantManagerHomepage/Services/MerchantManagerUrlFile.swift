//
//  MerchantManagerUrlFile.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

//商家管理首页
let merchantManagerHompageUrl = "api/merchant/home"
//开始营业
let startBusinerssUrl = "api/merchant/open"
//暂停营业
let closeBusinnessUrl = "api/merchant/close"



//商家实时订单列表
let merchantCurrentOrderListUrl = "api/morder/ss"
//配送中
let merchantDeliveringOrderListUrl = "api/morder/psorderlist"
//已送达
let merchantDeliveriedOrderListUrl = "api/morder/sdorderlist"
//退单
let merchantNeedReturnOrderListUrl = "api/morder/returnorderlist"
//已退单
let merchantHasreturnOrderListUrl = "api/morder/returnedorderlist"


//当前订单详情
let currentMerchantOrderDetailUrl = "api/morder/ss"
//设置配送员
let setStaffUrl = "api/morder/setstaff"
//商家取消订单
let merchantReturnOrder = "api/morder/return"

//配送中订单详情
let merchantDeliveringOrderDetailUrl = "api/morder/psorder"
//清除配送员
let clearOrderStaffUrl = "api/morder/clearstaff"

//已送达订单详情
let merchantDeliveriedDetailUrl = "api/morder/sdorder"
//已退单订单详情
let hasReturnedOrderDetailUrl = "api/morder/returnedorder"
//正退单订单详情
let returnOrderDetailUrl = "api/morder/returnorder"
//对于申请退单或退款的商家回复
let returnOrderMerchantActUrl  = "api/morder/returnorder"
//上传图片证据
let uploadMerchantServicePicUrl = "FileUpload/UploadMEvidence"


//配送员列表
let staffManageListUrl = "api/staff/list"
//新增配送员
let addNewStaffUrl = "api/staff/add"
//更新配送员
let updateStaffUrl = "api/staff/update"
//删除配送员
let deleteStaffUrl = "api/staff/delete"


//用户评价
let userOrderEvaluateListUrl = "api/mcomment/list"
//订单评价详情
let orderEvaluateDetailUrl = "api/mcomment/comment"

//订单周期结算列表
let finishWeekSettlementUrl = "api/morder/finishweek"
//订单日结算列表
let finishDaySettlementUrl = "api/morder/finishday"
//日结算详细订单列表
let finishDayOrderListUrl = "api/morder/finishorder"


//回复对商家的评价
let ansewerMerchantEvaluationUrl = "api/mcomment/replym"
//回复对商品的评价
let ansewerGoodsEvaluationUrl = "api/mcomment/replyg"
//屏蔽评价
let shieldEvaluationUrl = "api/mcomment/hide"
//删除评价
let deleteEvaluarionUrl = "api/mcomment/comment"

//更新商家密码
let updateMerchantPassWord = "api/merchant/pw"

//商家消息列表
let merchantMessageUrl = "api/mms"
//删除消息
let deleteMerchantMessageUrl = "api/mms"

class MerchantManagerUrlFile: NSObject {

    
    
}
