//
//  MerchantOrderDeliveringDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderDeliveringDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let leftTimeLabelHeight = cmSizeFloat(50)
    let textLineHeight = cmSizeFloat(40)
    let seperateLineHeight = cmSizeFloat(7)
    
    
    let toside = cmSizeFloat(20)
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    let callPhoneImage = #imageLiteral(resourceName: "merchantOrderDetailCall")
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var sectionFooterView:UIView!
    var tableFooterView:UIView!
    var needPayAmountLabel:UILabel!
    var leftTimeLabel:UILabel!
    
    var chooseStaffTextField:UITextField!
    //确认/更换按钮
    var  btnView:UIView!
    var changeOrOkBtn:UIButton!
    
    var returnOrderPopView:XYNoDetailTipsAlertView!
    
    var bottomView:UIView!
    var cancelOrderBtn:UIButton!
    
    //网络异常空白页
    public var merchantOrderAbnormalView:XYAbnormalViewManager!
    
    
    var orderId:String!
    var oderDetailModel:MerchantOrderDetailModel!
    var service:MerchantOrderDetailService = MerchantOrderDetailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createBottomView()
        if orderId != nil {
            self.service.merchantDeliveringOrderDetailRequest(target: self, orderID: orderId)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "订单详情"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建bottomview
    func createBottomView(){
        
        bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: TABBAR_HEIGHT))
        cancelOrderBtn = UIButton(frame: CGRect(x: toside, y: (TABBAR_HEIGHT - cmSizeFloat(40))/2, width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        cancelOrderBtn.setTitle("商家退单", for: .normal)
        cancelOrderBtn.setTitleColor(MAIN_WHITE, for: .normal)
        cancelOrderBtn.titleLabel?.font = cmSystemFontWithSize(15)
        cancelOrderBtn.layer.cornerRadius = cmSizeFloat(4)
        cancelOrderBtn.clipsToBounds = true
        cancelOrderBtn.backgroundColor = MAIN_BLUE
        cancelOrderBtn.addTarget(self, action: #selector(cancelOrderBtnAct), for: .touchUpInside)
        bottomView.addSubview(cancelOrderBtn)
        self.view.addSubview(bottomView)
    }
    
    //MARK: - 退单操作
    @objc func cancelOrderBtnAct(){
        returnOrderPopView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "你确定要取消订单吗？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
            
        }, certainClosure: { [weak self] in
            self?.cancelOrderBtn.isEnabled = false
            
            self?.service.merchantReturnOrderRequest(userOrderID: self!.oderDetailModel.orderNumber, successAct: {
                cmShowHUDToWindow(message: "订单已取消")
                self?.navigationController?.popViewController(animated: true)
            }, failureAct: {
                self?.cancelOrderBtn.isEnabled = true
            })
        })
        returnOrderPopView.showInView(view: self.view)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: topView.bottom , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT - topView.bottom), in: self.view)
        
        if isNetError == true{
            merchantOrderAbnormalView = abnormalView
            merchantOrderAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            merchantOrderAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.merchantDeliveringOrderDetailRequest(target: self!, orderID: self!.orderId)
            }
        }
    }
    
    
    //MARK: - 刷新UI
    func refreshSubviewUI(){
        if oderDetailModel.chooseStaffModel != nil {
            chooseStaffTextField.text = oderDetailModel.chooseStaffModel.StaffName
            changeOrOkBtn.setTitleColor(MAIN_WHITE, for: .normal)
            changeOrOkBtn.backgroundColor = MAIN_GREEN
        }else{
            chooseStaffTextField.text = ""
            changeOrOkBtn.setTitleColor(MAIN_WHITE, for: .normal)
            changeOrOkBtn.backgroundColor = .gray
        }
    }
    
    
    //MARK: - 创建配送设置子View
    func createStaffSubviewsLabel(){
        
        leftTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: textLineHeight))
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.font = cmSystemFontWithSize(14)
        leftTimeLabel.textColor = MAIN_BLACK
        
        var showTimeType = ""
        if oderDetailModel.TimeShowType == 1 {
            showTimeType = "距预约还剩 "
        }else if oderDetailModel.TimeShowType == 2 {
            showTimeType = "距超时还剩 "
        }
        let leftActTimeStr = showTimeType +   String(oderDetailModel.leftLimitTime/60) + "分钟"
        let attributeStrRange:NSRange = NSMakeRange(6, leftActTimeStr.count - 6)
        let attributeStr = NSMutableAttributedString(string: leftActTimeStr)
        attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: MAIN_RED, range: attributeStrRange)
        leftTimeLabel.attributedText = attributeStr
        tableHeaderView.addSubview(leftTimeLabel)
        
        
        let staffSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: leftTimeLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight)
        tableHeaderView.addSubview(staffSeperateView)
        
        
        //配送设置创建
        let staffSetTitleLabel = UILabel(frame: CGRect(x: toside, y: staffSeperateView.bottom, width: SCREEN_WIDTH-toside*2, height: textLineHeight))
        staffSetTitleLabel.font = cmBoldSystemFontWithSize(15)
        staffSetTitleLabel.textColor = MAIN_BLACK
        staffSetTitleLabel.textAlignment = .left
        staffSetTitleLabel.text = "配送设置"
        tableHeaderView.addSubview(staffSetTitleLabel)
        
        let staffNameTitleStr = "配送人员:"
        let staffNameTitleStrWidth = staffNameTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        let staffNameLabel = UILabel(frame: CGRect(x: toside, y: staffSetTitleLabel.bottom, width: staffNameTitleStrWidth, height: textLineHeight))
        staffNameLabel.font = cmSystemFontWithSize(14)
        staffNameLabel.textColor = MAIN_BLACK
        staffNameLabel.textAlignment = .left
        staffNameLabel.text = staffNameTitleStr
        tableHeaderView.addSubview(staffNameLabel)
        
        
        chooseStaffTextField = UITextField(frame: CGRect(x: staffNameLabel.right + toside, y: staffNameLabel.frame.origin.y, width: SCREEN_WIDTH   - staffNameTitleStrWidth - toside*2 , height: textLineHeight))
        chooseStaffTextField.font = cmSystemFontWithSize(14)
        chooseStaffTextField.textColor = MAIN_BLACK
        chooseStaffTextField.textAlignment = .right
        chooseStaffTextField.backgroundColor = .white
        chooseStaffTextField.placeholder = "未选择"
        
        let showMoreImageView = UIImageView(frame: CGRect(x: chooseStaffTextField.frame.size.width - toside*2 - showMoreImage.size.width, y: textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        //showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        chooseStaffTextField.rightView = showMoreImageView
        chooseStaffTextField.rightViewMode = .always
        //chooseStaffTextField.delegate = self
        chooseStaffTextField.isEnabled = false
        tableHeaderView.addSubview(chooseStaffTextField)
        
        //确定按钮
        let btnViewHeight = cmSizeFloat(60)
        
        btnView = UIView(frame: CGRect(x: 0, y: chooseStaffTextField.bottom, width: SCREEN_WIDTH, height: btnViewHeight))
        btnView.backgroundColor = seperateLineColor
        tableHeaderView.addSubview(btnView)
        
        changeOrOkBtn = UIButton(frame: CGRect(x: toside, y: cmSizeFloat(10), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        changeOrOkBtn.setTitle("更换配送员", for: .normal)
        changeOrOkBtn.setTitleColor(MAIN_WHITE, for: .normal)
        changeOrOkBtn.titleLabel?.font = cmSystemFontWithSize(15)
        changeOrOkBtn.layer.cornerRadius = cmSizeFloat(4)
        changeOrOkBtn.clipsToBounds = true
        changeOrOkBtn.backgroundColor = MAIN_GREEN
        if oderDetailModel.chooseStaffModel != nil {
            chooseStaffTextField.text = oderDetailModel.chooseStaffModel.StaffName
        }
        changeOrOkBtn.addTarget(self, action: #selector(changeOrOkBtnAct), for: .touchUpInside)
        btnView.addSubview(changeOrOkBtn)
    }
    
    
    //MARK: - 配送员更换按钮响应
    @objc func changeOrOkBtnAct(){
        self.service.clearOrderStaffRequest(userOrderID: oderDetailModel.orderNumber, successAct: { [weak self] in
            cmShowHUDToWindow(message: "操作成功")
            DispatchQueue.main.async {
                let navVCCount = self!.navigationController!.viewControllers.count
                if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? MerchantOrderManageVC {
                    lastVC.mainTabView.mj_header.beginRefreshing()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }) {
            
        }
        
    }
    
    //MARK: - 创建tableHeader
    func creatTableHeaderView() {
        
        let callBtnWidth = callPhoneImage.size.width + toside*2
        
        
        let receiverTitleStr = "收货人: "
        let receiverTitleStrWidth = receiverTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let receiverInfoHeight = oderDetailModel.recieverUserInfo.stringHeight(SCREEN_WIDTH - toside - receiverTitleStrWidth - callBtnWidth, font: cmSystemFontWithSize(14))
        
        let orderGenerationTitleStr = "下单人: "
        let orderGenerationTitleStrWidth = orderGenerationTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let orderGenerationInfoHeight = oderDetailModel.orderGenerationUserInfo.stringHeight(SCREEN_WIDTH - toside - orderGenerationTitleStrWidth - callBtnWidth, font: cmSystemFontWithSize(14))
        
        
        
        let textToTopBottomHeight = cmSizeFloat(10)
        let tableHeaderViewHeight = textLineHeight*4 + receiverInfoHeight + orderGenerationInfoHeight + textToTopBottomHeight*4 + seperateLineHeight*3 + leftTimeLabelHeight + cmSizeFloat(60)
        
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableHeaderViewHeight))
        tableHeaderView.backgroundColor = .white
        
        createStaffSubviewsLabel()
        
        //配送时间要求
        let DeliveryTypeStrWidth = oderDetailModel.DeliveryType.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        let deliveryTypeLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - (toside*2 + DeliveryTypeStrWidth), y: btnView.bottom, width: toside*2 + DeliveryTypeStrWidth, height: textLineHeight))
        deliveryTypeLabel.textAlignment = .center
        deliveryTypeLabel.font = cmSystemFontWithSize(14)
        deliveryTypeLabel.textColor = MAIN_BLUE
        deliveryTypeLabel.text = oderDetailModel.DeliveryType
        tableHeaderView.addSubview(deliveryTypeLabel)
        
        //下单时间
        let orderGenerationTimeLabel = UILabel(frame: CGRect(x: toside, y: btnView.bottom, width: SCREEN_WIDTH - toside*3 - DeliveryTypeStrWidth, height: textLineHeight))
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
        
        //致电收货人按钮
        let callReciverBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - callBtnWidth, y: orderNumberLabel.bottom  + seperateLineHeight + (textToTopBottomHeight*2 + receiverInfoHeight - callPhoneImage.size.height)/2, width: callBtnWidth, height: callPhoneImage.size.height))
        callReciverBtn.setImage(callPhoneImage, for: .normal)
        callReciverBtn.addTarget(self, action: #selector(callReciverBtnAct), for: .touchUpInside)
        tableHeaderView.addSubview(callReciverBtn)
        
        
        let receiverInfoLabel = UILabel(frame: CGRect(x: receiverTitleLabel.right, y: receiverTitleLabel.top, width: SCREEN_WIDTH - toside - receiverTitleStrWidth - callBtnWidth, height: receiverInfoHeight))
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
        
        //致电收货人按钮
        let callGenerationBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - callBtnWidth, y: receiverInfoSeperateLine.bottom + (textToTopBottomHeight*2 + orderGenerationInfoHeight - callPhoneImage.size.height)/2, width: callBtnWidth, height: callPhoneImage.size.height))
        callGenerationBtn.setImage(callPhoneImage, for: .normal)
        callGenerationBtn.addTarget(self, action: #selector(callGenerationBtnAct), for: .touchUpInside)
        tableHeaderView.addSubview(callGenerationBtn)
        
        
        let orderGenerationInfoLabel = UILabel(frame: CGRect(x: orderGenerationTitleLabel.right, y: orderGenerationTitleLabel.top, width: SCREEN_WIDTH - toside - orderGenerationTitleStrWidth - callBtnWidth, height: orderGenerationInfoHeight))
        orderGenerationInfoLabel.textAlignment = .left
        orderGenerationInfoLabel.font = cmSystemFontWithSize(14)
        orderGenerationInfoLabel.textColor = MAIN_BLACK2
        orderGenerationInfoLabel.text = oderDetailModel.orderGenerationUserInfo
        orderGenerationInfoLabel.numberOfLines = 0
        tableHeaderView.addSubview(orderGenerationInfoLabel)
        
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY:orderGenerationInfoLabel.bottom + textToTopBottomHeight , lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        tableHeaderView.frame.size.height = orderGenerationInfoLabel.bottom + textToTopBottomHeight + seperateLineHeight
    }
    
    
    
    
    //MARK: - 致电收货人
    @objc func callReciverBtnAct(){
        cmMakePhoneCall(phoneStr: oderDetailModel.recieverTel)
    }
    
    //MARK: - 致电下单人
    @objc func callGenerationBtnAct(){
        cmMakePhoneCall(phoneStr: oderDetailModel.generationUserTel)
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
            
            
            let spaceView = UIView(frame: CGRect(x: discountTexfield.frame.size.width - toside, y: 0, width: toside, height: textLineHeight))
            discountTexfield.rightView = spaceView
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
    
    
    
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        creatTableHeaderView()
        createTableFootView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT-TABBAR_HEIGHT), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.tableFooterView = self.tableFooterView
        mainTabView.register(MerchantOrderDetailTabcell.self, forCellReuseIdentifier: "MerchantOrderDetailTabcell")
        
        
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
        return MerchantOrderDetailTabcell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOrderDetailTabcell")
        if cell == nil {
            cell = MerchantOrderDetailTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantOrderDetailTabcell")
        }
        if let targetCell = cell as? MerchantOrderDetailTabcell{
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
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField ==  chooseStaffTextField{
//            let recieverVC = ChooseStaffVC()
//            recieverVC.staffModelArr = oderDetailModel.staffListModelArr
//            self.navigationController?.pushViewController(recieverVC, animated: true)
//            return false
//        }
        
        return true
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
