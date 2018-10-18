//
//  OrderDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/29.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let payLimitLabelHeight = cmSizeFloat(40)
    let textLineHeight = cmSizeFloat(40)
    let seperateLineHeight = cmSizeFloat(7)
    
    
    let toside = cmSizeFloat(20)
    let complaintImage = #imageLiteral(resourceName: "orderDetailComplaint")
    let callSellerImage = #imageLiteral(resourceName: "orderDetailTel")
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var sectionFooterView:UIView!
    var tableFooterView:UIView!
    var needPayAmountLabel:UILabel!
    var timerLimitLabel:UILabel!
    var callPhonePopView:XYCallPhonePopView!
    var deletePopView:XYNoDetailTipsAlertView!
    
    //倒计时Timer
    var limitTimer:Timer!
    var leftTime:Int = 0
    
    
    var oderDetailModel:OrderDetailModel!
    var service:OrderManageListService = OrderManageListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatMainTabView()
        //if oderDetailModel.payLimitTime > 0 {
            createTimeLeftLabel()
        //}
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: #selector(backBtnAction)))
            topView.titleLabel.text = oderDetailModel.sellerName
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    @objc func backBtnAction() {
        
        let navVCCount = self.navigationController!.viewControllers.count
        if let _ = self.navigationController?.viewControllers[navVCCount - 2] as? OrderPayVC {
            
            if let rootViewVC = self.navigationController?.viewControllers.first as? OrderManageVC {
                self.navigationController?.popToViewController(rootViewVC, animated: true)
                rootViewVC.mainTabView.mj_header.beginRefreshing()
            }else{
                self.navigationController?.popToRootViewController(animated: true)

            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        if self.limitTimer != nil {
            self.limitTimer.invalidate()
            self.limitTimer = nil
        }
    }
    
    //MARK: - 创建倒计时lable
    func createTimeLeftLabel(){
        
        var startMinStr:String =  String(Int(oderDetailModel.payLimitTime * 100) / 60 / 100)
        if oderDetailModel.payLimitTime/60 < 10 {
            startMinStr = "0" + startMinStr
        }
        var startSecondStr:String = String(Int(oderDetailModel.payLimitTime * 100)%6000/100)
        if oderDetailModel.payLimitTime%60 < 10 {
            startSecondStr = "0" +  startSecondStr
        }
        
        timerLimitLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH*3/8, y: topView.bottom, width: SCREEN_WIDTH/4, height: textLineHeight))
        timerLimitLabel.textAlignment = .center
        timerLimitLabel.font = cmBoldSystemFontWithSize(20)
        timerLimitLabel.backgroundColor = MAIN_BLUE
        timerLimitLabel.textColor = MAIN_WHITE
        
        //进行弧度设置
        let maskPath = UIBezierPath(roundedRect: timerLimitLabel.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.bottomRight.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue))), cornerRadii: CGSize(width: textLineHeight/3, height: textLineHeight/3))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = timerLimitLabel.bounds
        maskLayer.path = maskPath.cgPath
        timerLimitLabel.layer.mask = maskLayer
        
        timerLimitLabel.text = startMinStr + ":" + startSecondStr
        self.view.addSubview(timerLimitLabel)
        
        leftTime = oderDetailModel.payLimitTime
        
        if oderDetailModel.TimeShowType == .timeAdd ||  oderDetailModel.TimeShowType == .timeReduce {
            limitTimer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(limitTimer, forMode: .commonModes)
        }
        
        //如果是预约时间则显示方式不同
        if oderDetailModel.TimeShowType == .timeAppointment {
            timerLimitLabel.text =  "预约" + String(leftTime/3600) + ":" +  String(leftTime%3600/60)
            timerLimitLabel.font = cmBoldSystemFontWithSize(16)
        }
        
    }
    
    //MARK: - 倒计时响应
    @objc func timerAction() {
        
        if self.leftTime <= 0 {
            self.limitTimer.invalidate()
            self.limitTimer = nil
            return
        }
        if oderDetailModel.TimeShowType == .timeAdd {
            self.leftTime += 1
        }else if oderDetailModel.TimeShowType == .timeReduce {
            self.leftTime -= 1
        }
        var minStr:String =  String(Int(self.leftTime * 100) / 60 / 100)
        if self.leftTime/60 < 10 {
            minStr = "0" + minStr
        }
        var secondStr:String = String(Int(self.leftTime * 100)%6000/100)
        if self.leftTime%60 < 10 {
            secondStr = "0" +  secondStr
        }
        
        timerLimitLabel.text = minStr + ":" + secondStr
    }
    
    
    //MARK: - 创建tableHeader
    func creatTableHeaderView() {
        
        let receiverTitleStr = "收货人: "
        let receiverTitleStrWidth = receiverTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let receiverInfoHeight = oderDetailModel.recieverUserInfo.stringHeight(SCREEN_WIDTH - toside*2 - receiverTitleStrWidth, font: cmSystemFontWithSize(14))
        
        let orderGenerationTitleStr = "下单人: "
        let orderGenerationTitleStrWidth = orderGenerationTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let orderGenerationInfoHeight = oderDetailModel.orderGenerationUserInfo.stringHeight(SCREEN_WIDTH - toside*2 - orderGenerationTitleStrWidth, font: cmSystemFontWithSize(14))
        
        let orderTipsStr = oderDetailModel.firstStatusListModel.StatusDetail!
        let orderTipsHeight = orderTipsStr.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(13))
        let orderTipsToCallSellerBtnHeight = cmSizeFloat(25)
        
        let textToTopBottomHeight = cmSizeFloat(10)
        let tableHeaderViewHeight = textLineHeight*6 + receiverInfoHeight + orderGenerationInfoHeight + textToTopBottomHeight*4 + seperateLineHeight*3 + orderTipsHeight + orderTipsToCallSellerBtnHeight
        
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableHeaderViewHeight))
        tableHeaderView.backgroundColor = .white
        
        
        let orderStatusDesWidth = oderDetailModel.orderStatusDes.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)), font: cmBoldSystemFontWithSize(17))
        let showmoreImageToStatusWidht = cmSizeFloat(7)
        let textToLeft = (SCREEN_WIDTH - showmoreImageToStatusWidht - showMoreImage.size.width - orderStatusDesWidth)/2
        
        
        let orderStatusLabel = UILabel(frame: CGRect(x: textToLeft, y: payLimitLabelHeight, width: orderStatusDesWidth, height: textLineHeight))
        orderStatusLabel.textAlignment = .center
        orderStatusLabel.font = cmBoldSystemFontWithSize(17)
        orderStatusLabel.textColor = MAIN_BLUE
        orderStatusLabel.text = oderDetailModel.orderStatusDes
        tableHeaderView.addSubview(orderStatusLabel)
        
        let statusShowMoreImageView = UIImageView(frame: CGRect(x: orderStatusLabel.right + showmoreImageToStatusWidht, y: orderStatusLabel.top + textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width, height: showMoreImage.size.height))
        statusShowMoreImageView.image = showMoreImage
        tableHeaderView.addSubview(statusShowMoreImageView)
        
        let showStatusDetailBtn = UIButton(frame: CGRect(x: orderStatusLabel.left, y: orderStatusLabel.top, width: orderStatusLabel.frame.size.width + showmoreImageToStatusWidht*2 + showMoreImage.size.width, height: orderStatusLabel.frame.size.height))
        showStatusDetailBtn.addTarget(self, action: #selector(showStatusDetailAct), for: .touchUpInside)
        showStatusDetailBtn.backgroundColor = .clear
        //showStatusDetailBtn.backgroundColor = cmColorWithString(colorName: "123456")
        tableHeaderView.addSubview(showStatusDetailBtn)
        
        
        let orderTipsLabel = UILabel(frame: CGRect(x: toside, y: orderStatusLabel.bottom, width: SCREEN_WIDTH-toside*2, height: orderTipsHeight + orderTipsToCallSellerBtnHeight))
        if orderTipsHeight > cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) {
            orderTipsLabel.textAlignment = .center
        }else{
            orderTipsLabel.textAlignment = .center
        }
        orderTipsLabel.font = cmSystemFontWithSize(13)
        orderTipsLabel.textColor = MAIN_GRAY
        orderTipsLabel.numberOfLines = 0
        if oderDetailModel.firstStatusListModel != nil {
            orderTipsLabel.text =    oderDetailModel.firstStatusListModel.StatusDetail
        }
        tableHeaderView.addSubview(orderTipsLabel)
        
        //订单状态Act响应
        let btnsSpace = cmSizeFloat(25)
        var maxBtnWidth = cmSizeFloat(0)
        //获取最长字符串按钮
        for orderActModel in oderDetailModel.orderActModelArr {
           let btnStrWidth = orderActModel.orderActStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
            if btnStrWidth > maxBtnWidth {
               maxBtnWidth = btnStrWidth
            }
        }
        
        maxBtnWidth += cmSizeFloat(16)
        let tosideWidth = (SCREEN_WIDTH - maxBtnWidth*CGFloat(oderDetailModel.orderActModelArr.count) - btnsSpace*CGFloat(oderDetailModel.orderActModelArr.count - 1))/2
        
        for orderActIndex in 0..<oderDetailModel.orderActModelArr.count {
            
            let orderActBtn  = UIButton(frame: CGRect(x: tosideWidth + (maxBtnWidth + btnsSpace)*CGFloat(orderActIndex), y: orderTipsLabel.bottom + textLineHeight/8, width: maxBtnWidth, height: textLineHeight*3/4))
            orderActBtn.titleLabel?.font = cmSystemFontWithSize(13)
            orderActBtn.layer.cornerRadius = cmSizeFloat(3)
            orderActBtn.layer.borderWidth = CGFloat(1)
            orderActBtn.layer.borderColor = MAIN_BLUE.cgColor
            orderActBtn.setTitleColor(MAIN_BLACK, for: .normal)
            orderActBtn.setTitle(oderDetailModel.orderActModelArr[orderActIndex].orderActStr, for: .normal)
            orderActBtn.addTarget(self, action: #selector(orderStatusAct(sender:)), for: .touchUpInside)
            orderActBtn.tag = 200 + orderActIndex
            tableHeaderView.addSubview(orderActBtn)
            
        }
        
        
        //当没有任何操作响应时
        var complainBtnOriginY = orderTipsLabel.bottom + textLineHeight
        
        if oderDetailModel.orderActModelArr.count == 0 {
            complainBtnOriginY = orderTipsLabel.bottom
        }

        //投诉按钮
        let imageToTextWidth = cmSizeFloat(6)
        let complaintToCallSellerWidth = cmSizeFloat(40)
        let complaintStr = "投诉"
        let complaintStrWidth = complaintStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        let callSellerStr = "商家"
        let callSellerStrWidth = callSellerStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        
        
        let complaintBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - (complaintStrWidth + imageToTextWidth + complaintImage.size.width + callSellerStrWidth + imageToTextWidth + callSellerImage.size.width + complaintToCallSellerWidth))/2, y: complainBtnOriginY, width:complaintStrWidth + imageToTextWidth + complaintImage.size.width, height: textLineHeight))
        complaintBtn.addTarget(self, action: #selector(complaintBtnAct), for: .touchUpInside)
        
        
        let complaintImageView = UIImageView(frame: CGRect(x: 0, y: textLineHeight/2 - complaintImage.size.height/2 , width: complaintImage.size.width, height: complaintImage.size.height))
        complaintImageView.image = complaintImage
        complaintBtn.addSubview(complaintImageView)
        
        let complaintLabel = UILabel(frame: CGRect(x: complaintImageView.right + imageToTextWidth, y: 0, width: complaintStrWidth, height: textLineHeight))
        complaintLabel.textAlignment = .left
        complaintLabel.font = cmSystemFontWithSize(13)
        complaintLabel.textColor = MAIN_BLUE
        complaintLabel.text = complaintStr
        complaintBtn.addSubview(complaintLabel)
        tableHeaderView.addSubview(complaintBtn)
        
        //联系商家按钮
        
        let callSellerBtn = UIButton(frame: CGRect(x: complaintBtn.right + complaintToCallSellerWidth, y: complaintBtn.top, width:callSellerStrWidth + imageToTextWidth + callSellerImage.size.width, height: textLineHeight))
        callSellerBtn.addTarget(self, action: #selector(callSellerBtnAct), for: .touchUpInside)
        
        let callSellerImageView = UIImageView(frame: CGRect(x: 0, y: textLineHeight/2 - callSellerImage.size.height/2 , width: callSellerImage.size.width, height: callSellerImage.size.height))
        callSellerImageView.image = callSellerImage
        callSellerBtn.addSubview(callSellerImageView)
        
        let callSellerLabel = UILabel(frame: CGRect(x: callSellerImageView.right + imageToTextWidth, y: 0, width: callSellerStrWidth, height: textLineHeight))
        callSellerLabel.textAlignment = .left
        callSellerLabel.font = cmSystemFontWithSize(13)
        callSellerLabel.textColor = MAIN_BLUE
        callSellerLabel.text = callSellerStr
        callSellerBtn.addSubview(callSellerLabel)
        tableHeaderView.addSubview(callSellerBtn)
        
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: callSellerBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        //配送时间要求
        let DeliveryTypeStrWidth = oderDetailModel.DeliveryType.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let deliveryTypeLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - (toside*2 + DeliveryTypeStrWidth), y: callSellerBtn.bottom + seperateLineHeight, width: toside*2 + DeliveryTypeStrWidth, height: textLineHeight))
        deliveryTypeLabel.textAlignment = .center
        deliveryTypeLabel.font = cmSystemFontWithSize(14)
        deliveryTypeLabel.textColor = MAIN_BLUE
        deliveryTypeLabel.text = oderDetailModel.DeliveryType
        tableHeaderView.addSubview(deliveryTypeLabel)
        
        //下单时间
        let orderGenerationTimeLabel = UILabel(frame: CGRect(x: toside, y: callSellerBtn.bottom + seperateLineHeight, width: SCREEN_WIDTH - toside*3 - DeliveryTypeStrWidth, height: textLineHeight))
        orderGenerationTimeLabel.textAlignment = .left
        orderGenerationTimeLabel.font = cmSystemFontWithSize(14)
        orderGenerationTimeLabel.textColor = MAIN_BLACK2
        orderGenerationTimeLabel.text = oderDetailModel.orderGenerationTime
        tableHeaderView.addSubview(orderGenerationTimeLabel)
        
        tableHeaderView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: orderGenerationTimeLabel.bottom - cmSizeFloat(1)))
        
        //订单单号
        let orderNumStr =  "订单单号: " + oderDetailModel.orderNumber
        let orderNumberLabel = UILabel(frame: CGRect(x: toside, y: orderGenerationTimeLabel.bottom, width: SCREEN_WIDTH - toside*2, height: textLineHeight))
        orderNumberLabel.textAlignment = .left
        orderNumberLabel.font = cmSystemFontWithSize(14)
        orderNumberLabel.textColor = MAIN_BLACK2
        orderNumberLabel.text = orderNumStr
        tableHeaderView.addSubview(orderNumberLabel)
        
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: orderNumberLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        //收货人
        
        let receiverTitleLabel = UILabel(frame: CGRect(x: toside, y: orderNumberLabel.bottom + textToTopBottomHeight + seperateLineHeight, width: receiverTitleStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
        receiverTitleLabel.textAlignment = .left
        receiverTitleLabel.font = cmSystemFontWithSize(14)
        receiverTitleLabel.textColor = MAIN_BLACK2
        receiverTitleLabel.text = receiverTitleStr
        tableHeaderView.addSubview(receiverTitleLabel)
        
        
        let receiverInfoLabel = UILabel(frame: CGRect(x: receiverTitleLabel.right, y: receiverTitleLabel.top, width: SCREEN_WIDTH - toside*2 - receiverTitleStrWidth, height: receiverInfoHeight))
        receiverInfoLabel.textAlignment = .left
        receiverInfoLabel.font = cmSystemFontWithSize(14)
        receiverInfoLabel.textColor = MAIN_BLACK2
        receiverInfoLabel.text = oderDetailModel.recieverUserInfo
        receiverInfoLabel.numberOfLines = 0
        tableHeaderView.addSubview(receiverInfoLabel)
        
        let receiverInfoSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: receiverInfoLabel.bottom + textToTopBottomHeight - cmSizeFloat(1))
        tableHeaderView.addSubview(receiverInfoSeperateLine)
        //下单人
        
        let orderGenerationTitleLabel = UILabel(frame: CGRect(x: toside, y: receiverInfoSeperateLine.bottom + textToTopBottomHeight, width: orderGenerationTitleStrWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
        orderGenerationTitleLabel.textAlignment = .left
        orderGenerationTitleLabel.font = cmSystemFontWithSize(14)
        orderGenerationTitleLabel.textColor = MAIN_BLACK2
        orderGenerationTitleLabel.text = orderGenerationTitleStr
        tableHeaderView.addSubview(orderGenerationTitleLabel)
        
        
        let orderGenerationInfoLabel = UILabel(frame: CGRect(x: orderGenerationTitleLabel.right, y: orderGenerationTitleLabel.top, width: SCREEN_WIDTH - toside*2 - orderGenerationTitleStrWidth, height: orderGenerationInfoHeight))
        orderGenerationInfoLabel.textAlignment = .left
        orderGenerationInfoLabel.font = cmSystemFontWithSize(14)
        orderGenerationInfoLabel.textColor = MAIN_BLACK2
        orderGenerationInfoLabel.text = oderDetailModel.orderGenerationUserInfo
        orderGenerationInfoLabel.numberOfLines = 0
        tableHeaderView.addSubview(orderGenerationInfoLabel)
        
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY:orderGenerationInfoLabel.bottom + textToTopBottomHeight , lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        tableHeaderView.frame.size.height = orderGenerationInfoLabel.bottom + textToTopBottomHeight + seperateLineHeight
        
    }
    
    //MARK: - 查看订单详细状态
    @objc func showStatusDetailAct() {
        let orderStatusDetailVC = OderStatusDetailVC()
        orderStatusDetailVC.statusModelArr = oderDetailModel.statusListModelArr
        self.navigationController?.pushViewController(orderStatusDetailVC, animated: true)
    }
    
    
    //MARK: - 订单操作响应
    @objc func orderStatusAct(sender:UIButton){
        
        switch oderDetailModel.orderActModelArr[sender.tag - 200].orderActStatus {
        case .cancel:
            self.service.cancelOrderRequest(orderId: self.oderDetailModel.orderNumber, successAct: { [weak self] in
                DispatchQueue.main.async {
                    cmShowHUDToWindow(message: "取消成功")
                    self?.navigationController?.popViewController(animated: true)
                }
            }, failureAct: {
                
            })
            break
        case .delete:
            deletePopView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "确定删除该订单吗？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
                
            }, certainClosure: { [weak self] in
                //删除订单
                self?.service.deleteOrderRequest(orderId: self!.oderDetailModel.orderNumber, successAct: {
                    cmShowHUDToWindow(message: "删除成功")
                    DispatchQueue.main.async {
                        let navVCCount = self!.navigationController!.viewControllers.count
                        if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? OrderManageVC {
                            lastVC.mainTabView.mj_header.beginRefreshing()
                        }
                        self?.navigationController?.popViewController(animated: true)
                    }
                }, failureAct: {
                    
                })
            })
            deletePopView.showInView(view: self.view)

            break
        case .applyReturn:
            let cancelOrderVC = OrderCancelVC()
            cancelOrderVC.orderID = self.oderDetailModel.orderNumber
            if !self.oderDetailModel.merchantTelOne.isEmpty {
                cancelOrderVC.phoneNumArr.append(self.oderDetailModel.merchantTelOne)
            }
            if !self.oderDetailModel.merchantTelTwo.isEmpty {
                cancelOrderVC.phoneNumArr.append(self.oderDetailModel.merchantTelTwo)
            }
            self.navigationController?.pushViewController(cancelOrderVC, animated: true)
            break
        case .applyCustomerService:
            let applyServiceVC =  ApplyCustomServiceVC()
            applyServiceVC.orderID = self.oderDetailModel.orderNumber
            self.navigationController?.pushViewController(applyServiceVC, animated: true)
            break
        case .applyRefund:
            let orderRefundVC = OrderRefundVC()
            orderRefundVC.orderID = self.oderDetailModel.orderNumber
            if !self.oderDetailModel.merchantTelOne.isEmpty {
                orderRefundVC.phoneNumArr.append(self.oderDetailModel.merchantTelOne)
            }
            if !self.oderDetailModel.merchantTelTwo.isEmpty {
                orderRefundVC.phoneNumArr.append(self.oderDetailModel.merchantTelTwo)
            }
            self.navigationController?.pushViewController(orderRefundVC, animated: true)
            break
        case .pay:
            let payOrderVC = OrderPayVC()
            let orderPayModel = OrderSubmitResultModel()
            orderPayModel.userOrderID = oderDetailModel.orderNumber
            orderPayModel.totalPayMoney = oderDetailModel.needPayAmount
            orderPayModel.merchantName = oderDetailModel.sellerName
            orderPayModel.effectTime = self.leftTime
            payOrderVC.orderPayModel = orderPayModel
            self.navigationController?.pushViewController(payOrderVC, animated: true)
            break
        default:
            break
        }
        
        
    }
    
    
    //MARK: - 投诉按钮响应
    @objc func complaintBtnAct(){
        
        let complaintVC = ComplainSellerVC()
        complaintVC.merchantID =  oderDetailModel.MerchantID
        self.navigationController?.pushViewController(complaintVC, animated: true)
        
 /*
       let applyServiceVC =  ApplyCustomServiceVC()
        applyServiceVC.orderID = self.oderDetailModel.orderNumber
        self.navigationController?.pushViewController(applyServiceVC, animated: true)
 */
        /*
       let cancelOrderVC = OrderCancelVC()
        cancelOrderVC.orderID = self.oderDetailModel.orderNumber
        if !self.oderDetailModel.merchantTelOne.isEmpty {
            cancelOrderVC.phoneNumArr.append(self.oderDetailModel.merchantTelOne)
        }
        if !self.oderDetailModel.merchantTelTwo.isEmpty {
            cancelOrderVC.phoneNumArr.append(self.oderDetailModel.merchantTelTwo)
        }
        self.navigationController?.pushViewController(cancelOrderVC, animated: true)
        */
        /*
        let orderEvaluateVC = OrderEvaluateVC()
        orderEvaluateVC.orderId = oderDetailModel.orderNumber
        self.navigationController?.pushViewController(orderEvaluateVC, animated: true)
         */
    }
    
    //MARK: - 致电按钮响应
    @objc func callSellerBtnAct(){
        var callNumArr:[String] = Array()
        if !self.oderDetailModel.merchantTelOne.isEmpty {
            callNumArr.append(self.oderDetailModel.merchantTelOne)
        }
        if !self.oderDetailModel.merchantTelTwo.isEmpty {
            callNumArr.append(self.oderDetailModel.merchantTelTwo)
        }
        if callNumArr.count == 0 {
            cmShowHUDToWindow(message: "暂无商家联系方式")
            return
        }else if callNumArr.count == 1 {
            cmMakePhoneCall(phoneStr: callNumArr.first!)
        }else{
            callPhonePopView = XYCallPhonePopView(frame: .zero, phoneNumArr: callNumArr)
            callPhonePopView.showInView(view: self.view)
        }
        
        /*
        let orderRefundVC = OrderRefundVC()
        orderRefundVC.orderID = self.oderDetailModel.orderNumber
        if !self.oderDetailModel.merchantTelOne.isEmpty {
            orderRefundVC.phoneNumArr.append(self.oderDetailModel.merchantTelOne)
        }
        if !self.oderDetailModel.merchantTelTwo.isEmpty {
            orderRefundVC.phoneNumArr.append(self.oderDetailModel.merchantTelTwo)
        }
        self.navigationController?.pushViewController(orderRefundVC, animated: true)
        */
    }
    
    
    
    
    
    //MARK: - sectionFooter
    func createSectionFooterView() {
        let sectionFooterViewHeight = textLineHeight + seperateLineHeight*3 +  textLineHeight * CGFloat(oderDetailModel.userDiscountArr.count)
        sectionFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionFooterViewHeight))
        sectionFooterView.backgroundColor = .white
        
        sectionFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        let deliveryTitleLabel = UILabel(frame: CGRect(x: toside, y: seperateLineHeight, width: (SCREEN_WIDTH - toside*2)*5/6, height: textLineHeight))
        deliveryTitleLabel.textAlignment = .left
        deliveryTitleLabel.font = cmSystemFontWithSize(14)
        deliveryTitleLabel.textColor = MAIN_BLACK
        deliveryTitleLabel.text = "配送费"
        sectionFooterView.addSubview(deliveryTitleLabel)
        
        
        let deliveryAmountLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH - toside) - (SCREEN_WIDTH - toside*2)/6, y: seperateLineHeight, width: (SCREEN_WIDTH - toside*2)/6, height: textLineHeight))
        deliveryAmountLabel.textAlignment = .right
        deliveryAmountLabel.font = cmSystemFontWithSize(14)
        deliveryAmountLabel.textColor = MAIN_BLACK
        if oderDetailModel.isDeliveryFree {
            let attributes = [NSAttributedStringKey.font:cmSystemFontWithSize(14),NSAttributedStringKey.foregroundColor:MAIN_BLACK,NSAttributedStringKey.strikethroughStyle:NSNumber.init(value:1)]
            deliveryAmountLabel.attributedText = NSAttributedString.init(string: oderDetailModel.deliveryMoney, attributes: attributes)
        }else{
            deliveryAmountLabel.text = oderDetailModel.deliveryMoney
        }
        sectionFooterView.addSubview(deliveryAmountLabel)
        
        sectionFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: deliveryAmountLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        //折扣信息View
        let promotionLabelSize = "积".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        
        for index in 0..<oderDetailModel.userDiscountArr.count {
            
            let discountStatusLabel = UILabel(frame: CGRect(x: toside, y:deliveryAmountLabel.bottom + seperateLineHeight + textLineHeight*CGFloat(index) + textLineHeight/2 - promotionLabelSize/2, width: promotionLabelSize, height: promotionLabelSize))
            discountStatusLabel.textColor = MAIN_WHITE
            discountStatusLabel.font = cmSystemFontWithSize(11)
            discountStatusLabel.textAlignment = .center
            discountStatusLabel.layer.cornerRadius = 2
            discountStatusLabel.clipsToBounds = true
            sectionFooterView.addSubview(discountStatusLabel)
            
            let discountAmountLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH - toside) - (SCREEN_WIDTH - toside*2)/6, y: deliveryAmountLabel.bottom + seperateLineHeight +  textLineHeight*CGFloat(index), width: (SCREEN_WIDTH - toside*2)/6, height: textLineHeight))
            discountAmountLabel.textColor = MAIN_RED
            discountAmountLabel.font = cmSystemFontWithSize(14)
            discountAmountLabel.textAlignment = .right
            discountAmountLabel.text = "-¥" + moneyExchangeToString(moneyAmount: oderDetailModel.userDiscountArr[index].reduceMoney)
            sectionFooterView.addSubview(discountAmountLabel)
            
            let discountTitleLabel = UILabel(frame: CGRect(x: discountStatusLabel.right  + cmSizeFloat(7), y: discountAmountLabel.top, width: SCREEN_WIDTH - (SCREEN_WIDTH - toside*2)/6 - discountStatusLabel.right - cmSizeFloat(7), height: textLineHeight))
            discountTitleLabel.textColor = MAIN_BLACK
            discountTitleLabel.font = cmSystemFontWithSize(14)
            discountTitleLabel.textAlignment = .left
            discountTitleLabel.text = oderDetailModel.userDiscountArr[index].discountStatus.rawValue
            sectionFooterView.addSubview(discountTitleLabel)
            
            if index == oderDetailModel.userDiscountArr.count - 1 {
                sectionFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: discountTitleLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
            }
            
            switch oderDetailModel.userDiscountArr[index].discountStatus {
            case .newUser:
                discountStatusLabel.text = "减"
                discountStatusLabel.backgroundColor = .red
                break
            case .enoughReduce:
                discountStatusLabel.text = "折"
                discountStatusLabel.backgroundColor = .green
                break
            default:
                break
            }
            
        }
        
    }
    
    
    //MARK: - createTableFootView
    func createTableFootView() {
        let tableFooterViewHeight = textLineHeight*4
        let mechantDiscountStrArr:[String] = ["商家积分","商家代金券"]
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableFooterViewHeight))
        tableFooterView.backgroundColor = .white
        for index in 0..<mechantDiscountStrArr.count {
            
            let discountTexfield = UITextField(frame: CGRect(x: 0, y: textLineHeight*CGFloat(index), width: SCREEN_WIDTH , height: textLineHeight))
            discountTexfield.font = cmSystemFontWithSize(14)
            discountTexfield.textColor = MAIN_GRAY
            discountTexfield.textAlignment = .right
            discountTexfield.text = "无"
            discountTexfield.isEnabled = false
            
            
            let showMoreImageView = UIImageView(frame: CGRect(x: discountTexfield.frame.size.width - toside*2 - showMoreImage.size.width, y: textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            showMoreImageView.contentMode = .scaleAspectFit
            discountTexfield.rightView = showMoreImageView
            discountTexfield.rightViewMode = .always
            
            let titleStrWidth = mechantDiscountStrArr[index].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + toside*2
            let discountTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleStrWidth, height: textLineHeight))
            discountTitleLabel.textColor = MAIN_BLACK
            discountTitleLabel.font = cmSystemFontWithSize(14)
            discountTitleLabel.textAlignment = .center
            discountTitleLabel.text = mechantDiscountStrArr[index]
            discountTexfield.leftView = discountTitleLabel
            discountTexfield.leftViewMode = .always
            
            
            discountTexfield.delegate = self
            tableFooterView.addSubview(discountTexfield)
            
            
            if index == 0 {
                if oderDetailModel.IfJFExchange == true  && oderDetailModel.JFReduce > 0 {
                    discountTexfield.text = "-¥" + moneyExchangeToString(moneyAmount: oderDetailModel.JFReduce)
                    discountTexfield.textColor = MAIN_RED
                }
            }else if  index == 1 {
                if oderDetailModel.IfUseCC == true && oderDetailModel.CCAmount > 0 {
                    discountTexfield.text = "-¥" + moneyExchangeToString(moneyAmount: oderDetailModel.CCAmount)
                    discountTexfield.textColor = MAIN_RED
                }
            }
            discountTexfield.tag = 400 + index
            
        }
        
        let seprerateLine = XYCommonViews.creatCommonSeperateLine(pointY: textLineHeight*2 -  cmSizeFloat(1))
        tableFooterView.addSubview(seprerateLine)
        
        let textToTopBottom = (textLineHeight - seperateLineHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))/2
        let totalMoneyStr = "总计: " + "¥" + moneyExchangeToString(moneyAmount:oderDetailModel.totalMoney)
        let totalMoneyLabel =  UILabel(frame: CGRect(x: toside, y: seprerateLine.bottom +  textToTopBottom, width: totalMoneyStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
        totalMoneyLabel.textColor = MAIN_GRAY
        totalMoneyLabel.font = cmSystemFontWithSize(13)
        totalMoneyLabel.textAlignment = .left
        totalMoneyLabel.text = totalMoneyStr
        tableFooterView.addSubview(totalMoneyLabel)
        
        let discountMoneyStr = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount:oderDetailModel.discountAmount)
        let discountMoneyLabel = UILabel(frame: CGRect(x: totalMoneyLabel.right + cmSizeFloat(15), y: totalMoneyLabel.top, width:discountMoneyStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)), height: totalMoneyLabel.frame.size.height))
        discountMoneyLabel.textColor = MAIN_GRAY
        discountMoneyLabel.font = cmSystemFontWithSize(13)
        discountMoneyLabel.textAlignment = .left
        discountMoneyLabel.text = discountMoneyStr
        tableFooterView.addSubview(discountMoneyLabel)
        
        let needPayAmountStr = "实际金额: " + "¥" + moneyExchangeToString(moneyAmount:oderDetailModel.needPayAmount)
        let needPayAmountStrWidth = needPayAmountStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        needPayAmountLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - toside - needPayAmountStrWidth, y: totalMoneyLabel.top, width:needPayAmountStrWidth, height: totalMoneyLabel.frame.size.height))
        needPayAmountLabel.textColor = MAIN_RED
        needPayAmountLabel.font = cmSystemFontWithSize(13)
        needPayAmountLabel.textAlignment = .left
        needPayAmountLabel.text = needPayAmountStr
        tableFooterView.addSubview(needPayAmountLabel)
        
        tableFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: needPayAmountLabel.bottom + textToTopBottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        //备注
        let otherInfoLabel = UILabel(frame: CGRect(x: toside, y: needPayAmountLabel.bottom + textToTopBottom + seperateLineHeight, width:SCREEN_WIDTH - toside*2, height: textLineHeight))
        otherInfoLabel.textColor = MAIN_BLACK
        otherInfoLabel.font = cmSystemFontWithSize(14)
        otherInfoLabel.textAlignment = .left
        if oderDetailModel.otherInfo.trimmingCharacters(in: .whitespaces).isEmpty {
            otherInfoLabel.text = "无"
        }else{
            otherInfoLabel.text = oderDetailModel.otherInfo
            
        }
        tableFooterView.addSubview(otherInfoLabel)
        
    }
    /*
     //MARK: - chooseDiscountBtnAct
     func chooseDiscountBtnAct(sender:UIButton) {
     
     let selecDiscountView = self.view.viewWithTag(sender.tag - 300 + 400)
     if let  selecDiscountLabel = selecDiscountView as? UILabel {
     selecDiscountLabel.textColor = MAIN_RED
     }
     
     }
     */
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        creatTableHeaderView()
        createTableFootView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT), style: .grouped)
        
        
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.tableFooterView = self.tableFooterView
        mainTabView.register(OrderDetailGoodsCell.self, forCellReuseIdentifier: "OrderDetailGoodsCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oderDetailModel.goodsCellArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderDetailGoodsCell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailGoodsCell")
        if cell == nil {
            cell = OrderDetailGoodsCell(style: UITableViewCellStyle.default, reuseIdentifier: "OrderDetailGoodsCell")
        }
        if let targetCell = cell as? OrderDetailGoodsCell{
            targetCell.selectionStyle = .none
            
            targetCell.setModel(model: oderDetailModel.goodsCellArr[indexPath.row])
            
            
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return textLineHeight + seperateLineHeight*3 +  textLineHeight * CGFloat(oderDetailModel.userDiscountArr.count)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        createSectionFooterView()
        return sectionFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        
        return cmSizeFloat(40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(40)))
        sectionView.backgroundColor = .white
        
        
        let sectionLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        sectionLabel.textAlignment = .left
        sectionLabel.font = cmBoldSystemFontWithSize(15)
        sectionLabel.textColor = MAIN_BLACK2
        sectionLabel.text = oderDetailModel.sellerName
        sectionView.addSubview(sectionLabel)
        
        sectionView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: cmSizeFloat(40 - 1)))
        
        return sectionView
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
