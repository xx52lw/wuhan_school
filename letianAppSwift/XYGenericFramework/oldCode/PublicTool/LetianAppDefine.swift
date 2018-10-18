//
//  LetianAppDefine.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit


let MAIN_BLACK = cmColorWithString(colorName: "333333")
let MAIN_WHITE = cmColorWithString(colorName: "FFFFFF")
let MAIN_BLACK2 = cmColorWithString(colorName: "666666")
let MAIN_GRAY = cmColorWithString(colorName: "999999")
let MAIN_RED = cmColorWithString(colorName: "FF0000")
let MAIN_ORANGE = cmColorWithString(colorName: "FF8C00")
let MAIN_BLUE = cmColorWithString(colorName: "1D88DA")
let MAIN_GREEN = cmColorWithString(colorName: "339900")
let MAIN_BLUE_STR = "1D88DA"

//MARK: - key
let baiduKey = "uk97N94NjQrXPVzhlgwc7oAaKGxiNrCL" 
let weixinApiKey = "wx32803b2a65b89be3"



//MARK: - URL



//接口请求URL
//外卖首页
let takeFoodOutHomepageUrl = "api/Stu/AppHome"
//获取用户juese
let getUserRoleUrl = "api/role"
//获取用户信息(get)
//let getUserInfoUrl = "api/Stu/Register"
//获取所有支持城市信息
let getCitiesUrl = "api/stu/city"
//获取区域信息
let getAreaInfoUrl = "api/stu/area"
//注册个人信息(post)
let userRegisterUrl = "api/Stu/Register"
//用户是否已经注册
let userHasRegisterUrl = "api/Stu/IfRegister"
//更新用户设置信息(post)
let updateUserInfoUrl = "api/stuhome/stuinf"
//获取用户完整设置信息
let getUserAllInfoUrl = "api/stuhome/stuinf"
//登录并获取token
let loginGetTokenUrl = "Token"
//绑定微信
let bindingWechatUrl = "api/Stu/bdWechat"
//更新昵称
let nickNameModifyUrl = "api/stuhome/nickname"
//更新账户信息
let accountInfoModifyUrl = "api/stuhome/stuinf"
//重新设置密码
let resetPasswordUrl = "api/stuhome/password"
//重新设置区域
let resetAreaUrl = "api/stuhome/areainf"

//一级分类商家URL
let firstTypeSellerUrl = "api/Stu/fcatmerchant"
//二级分类商家URL
let secondTypeSellerUrl = "api/Stu/scatmerchant"
//搜索历史记录
let searchHistoryUrl = "api/Stu/searchword"
//删除历史记录
let deleteHistoryUrl = "api/Stu/searchword"
//关键字搜索商家信息
let  searchSellerUrl  = "api/Stu/searchMerchant"
//关键字搜索商品
let searchGoodsUrl = "api/Stu/searchgoods"

//首页天天打折
let  hotestDiscountUrl = "api/YX/ttdz"
//经济实惠
let hotestEconomicalUrl = "api/YX/jjshc"
//优质精品餐
let  hotestSelectedUrl =  "api/YX/yzjpc"
//热销排行搜索条件
let  hotestRankSearchTypeUrl = "api/YX/rxph"
//热销排行
let hotestRankUrl = "api/YX/rxphs"


//获取商家详情
let sellerDetailUrl = "api/stum/home"
//获取商家评论信息
let sellerEvaluateHomeUrl = "api/stum/comments"
//商家活动信息
let sellerPromotionUrl = "api/stum/hd"
//商家详细信息
let sellerDetailInfoUrl = "api/stum/detail"
//获取商家优惠
let getSellerPromotionUrl = "api/stum/djj"
//收藏商家
let collectMerchantUrl = "api/stum/sc"

//增加购物车
let shopCartAddGoodsUrl = "api/stum/addShopCart"
//清空购物车
let removeShopcartAllGoodsUrl = "api/stum/clearshopcart"
//更新购物车
let updateShopcartUrl = "api/stum/editShopCart"


//准备提交订单数据获取
let orderSubmitPrepareUrl = "api/stum/order"
//新增收货人
let addRecieverUrl = "api/stuhome/address"
//提交订单
let submitOrderUrl = "api/stum/order"
//订单支付
let orderPayUrl = "api/stuorder/pay"
//订单支付简洁信息
let orderPayInfoUrl = "api/stuorder/payinf"

//商品详情
let goodsDetailUrl = "api/stum/goodsDetail"
//商品评论分页获取
let goodsCommentsUrl = "api/stum/goodsComment"



//订单列表
let allOrdersListUrl = "api/stuorder/orderlist"
let waitPayListUrl = "api/stuorder/payOrderlist"
let waitRecieveGoodsUrl = "api/stuorder/receiveOrderlist"
let waiteEvaluateUrl = "api/stuorder/commentorderlist"
let refundListUrl = "api/stuorder/returnorderlist"

//待支付订单详情接口
let waitePayOrderDetailUrl = "api/stuorder/payorder"
//其他订单详情接口
let otherOrderDetailUrl = "api/stuorder/order"


//取消订单
let cancelOrderUrl = "api/stuorder/cancel"
//删除订单
let deleteOrderUrl = "api/stuorder/delete"
//申请退单
let applicationForReturn = "api/stuorder/return"
//申请退款
let applicationForRefund = "api/stuorder/refund"
//申请客服介入
let applicationForService = "api/stuorder/service"
//申请投诉
let applicationForComplain  = "api/stuorder/complain"
//订单评价
let orderEvaluateUrl = "api/stuorder/commentorder"
//待评价订单页内容
let waitForEvaluatePageUrl = "api/stuorder/commentorder"


//收货地址列表
let deliveryAdressManagerUrl = "api/stuhome/addresslist"
//新增收货地址
let addNewDeliveryAdressUrl = "api/stuhome/address"
//更新用户收货地址
let updateDeliveryAdressUrl = "api/stuhome/address"
//删除用户收货地址
let deleteDeliveryAdressUrl = "api/stuhome/address"

//已领取优惠券
let userPromotionListUrl = "api/stuhome/djj"
//商家收藏
let collectionMerchantListUrl = "api/stuhome/sclist"
//删除收藏的商家
let deleteCollectionUrl = "api/stuhome/sc"
//用户积分
let userJFListUrl = "api/stuhome/jf"
//消息列表
let messageListUrl = "api/stuhome/messagelist"
//删除消息
let deleteMessageUrl = "api/stuhome/message"


//更新当前定位地址
let updateCurrentLocationUrl = "api/stu/location"



//MARK: - 提示语
let NET_WORK_ERROR_TIPS = "网络连接错误，请检查网络连接"
let DATA_ERROR_TIPS = "系统错误，请稍后再试"




//全局变量
var currentSelectedCity:String = ""
var currentSelectedAdress:String = ""
var curretnAreaCode:Int!


//营销模块当中，推荐的四个模块枚举
enum HotestMMIDEnum:Int {
    case discountEveryDay = 1
    case hotestRank = 2
    case economical = 3
    case selectedFood = 4
}


class LetianAppDefine: NSObject {

}
