//
//  MerchantCustomServiceOrderDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantCustomServiceOrderDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let leftTimeLabelHeight = cmSizeFloat(50)
    let textLineHeight = cmSizeFloat(40)
    let seperateLineHeight = cmSizeFloat(7)
    
    
    let toside = cmSizeFloat(20)
    let callPhoneImage = #imageLiteral(resourceName: "merchantOrderDetailCall")
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var sectionFooterView:UIView!
    var tableFooterView:UIView!
    var needPayAmountLabel:UILabel!
    var leftTimeLabel:UILabel!
    
    var orderStatusTextField:UITextField!
    //同意及拒绝按钮按钮
    var  btnView:UIView!
    var submitBtn:UIButton!

    
    var oderDetailModel:MerchantOrderDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatMainTabView()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))

            topView.titleLabel.text = "平台取证"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    
    

    
    
    //MARK: - 创建客服介入子View
    func createHeaderInfoSubviews(){
        
        leftTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: textLineHeight))
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.font = cmSystemFontWithSize(14)
        leftTimeLabel.textColor = MAIN_BLACK
        

        let  leftActTimeStr = "回复剩余时间: " +   String(oderDetailModel.leftLimitTime/60) + "分钟"
        
        let attributeStrRange:NSRange = NSMakeRange(7, leftActTimeStr.count - 7)
        let attributeStr = NSMutableAttributedString(string: leftActTimeStr)
        attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: MAIN_RED, range: attributeStrRange)
        leftTimeLabel.attributedText = attributeStr
        tableHeaderView.addSubview(leftTimeLabel)
        
        
        let orderStatusSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: leftTimeLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight)
        tableHeaderView.addSubview(orderStatusSeperateView)
        
        
        //送达状态View

           let orderStatusTitleStr  = "送达状态:"
        
        
        let orderStatusTitleStrWidth = orderStatusTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        let staffNameLabel = UILabel(frame: CGRect(x: toside, y: orderStatusSeperateView.bottom, width: orderStatusTitleStrWidth, height: textLineHeight))
        staffNameLabel.font = cmSystemFontWithSize(14)
        staffNameLabel.textColor = MAIN_BLACK
        staffNameLabel.textAlignment = .left
        staffNameLabel.text = orderStatusTitleStr
        tableHeaderView.addSubview(staffNameLabel)
        
        
        orderStatusTextField = UITextField(frame: CGRect(x: staffNameLabel.right + toside, y: staffNameLabel.frame.origin.y, width: SCREEN_WIDTH   - orderStatusTitleStrWidth - toside*2 , height: textLineHeight))
        orderStatusTextField.font = cmSystemFontWithSize(14)
        orderStatusTextField.textColor = MAIN_BLACK
        orderStatusTextField.textAlignment = .right
        orderStatusTextField.backgroundColor = .white
        
        let spaceView = UIView(frame: CGRect(x: orderStatusTextField.frame.size.width - toside, y: 0, width: toside, height: textLineHeight))
        orderStatusTextField.rightView = spaceView
        orderStatusTextField.rightViewMode = .always
        orderStatusTextField.isEnabled = false
        
        
        orderStatusTextField.text = oderDetailModel.ArriveStatus
        
        
        tableHeaderView.addSubview(orderStatusTextField)
        
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: orderStatusTextField.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        
        let textSpaceHeight = cmSizeFloat(10)
        //申请客服介入原因View
        let returnReasonTitleLabel = UILabel(frame: CGRect(x: toside, y: orderStatusTextField.bottom + seperateLineHeight + textSpaceHeight, width: SCREEN_WIDTH-toside*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
        returnReasonTitleLabel.font = cmBoldSystemFontWithSize(15)
        returnReasonTitleLabel.textColor = MAIN_BLACK
        returnReasonTitleLabel.textAlignment = .left
        returnReasonTitleLabel.text = "申请客服介入原因"
        
        
        tableHeaderView.addSubview(returnReasonTitleLabel)
        
        let reasonStr = "· " + oderDetailModel.UserReason
        let reasonStrHeight = reasonStr.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        let returnReasonLabel = UILabel(frame: CGRect(x: toside, y: returnReasonTitleLabel.bottom + textSpaceHeight, width: SCREEN_WIDTH - toside*2, height: reasonStrHeight))
        returnReasonLabel.font = cmSystemFontWithSize(14)
        returnReasonLabel.textColor = MAIN_BLACK2
        returnReasonLabel.textAlignment = .left
        returnReasonLabel.text = reasonStr
        returnReasonLabel.numberOfLines = 0
        tableHeaderView.addSubview(returnReasonLabel)
        
        //提交按钮
        let btnViewHeight = cmSizeFloat(60)
        let btnHeight = cmSizeFloat(36)
        
        btnView = UIView(frame: CGRect(x: 0, y: returnReasonLabel.bottom + textSpaceHeight, width: SCREEN_WIDTH, height: btnViewHeight))
        btnView.backgroundColor = seperateLineColor
        tableHeaderView.addSubview(btnView)
        
        submitBtn = UIButton(frame: CGRect(x: toside, y: (btnViewHeight - btnHeight)/2, width: SCREEN_WIDTH - toside*2, height: btnHeight))
        submitBtn.setTitle("提交证据", for: .normal)
        submitBtn.setTitleColor(MAIN_WHITE, for: .normal)
        submitBtn.titleLabel?.font = cmSystemFontWithSize(15)
        submitBtn.layer.cornerRadius = cmSizeFloat(4)
        submitBtn.clipsToBounds = true
        submitBtn.backgroundColor = MAIN_GREEN
        submitBtn.addTarget(self, action: #selector(submitBtnAct), for: .touchUpInside)
        btnView.addSubview(submitBtn)
        
    }
    
    
    //MARK: - 提交证据按钮响应
    @objc func submitBtnAct(){
        let arbitrationEvidenceVC = MerchantArbitrationEvidenceSubmitVC()
        arbitrationEvidenceVC.userOrderId = oderDetailModel.orderNumber
        arbitrationEvidenceVC.statusStr = oderDetailModel.OrderStatus
        self.navigationController?.pushViewController(arbitrationEvidenceVC, animated: true)
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

        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: .leastNonzeroMagnitude))
        tableHeaderView.backgroundColor = .white
        
        createHeaderInfoSubviews()
        
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
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT), style: .grouped)
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
        if textField ==  orderStatusTextField{
            let recieverVC = ChooseStaffVC()
            recieverVC.staffModelArr = oderDetailModel.staffListModelArr
            self.navigationController?.pushViewController(recieverVC, animated: true)
            return false
        }
        
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
