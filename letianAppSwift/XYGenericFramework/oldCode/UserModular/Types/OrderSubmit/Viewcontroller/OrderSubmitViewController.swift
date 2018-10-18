//
//  OrderSubmitViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/17.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderSubmitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    let textLineHeight = cmSizeFloat(40)
    let seperateLineHeight = cmSizeFloat(7)
    let toside = cmSizeFloat(20)
    let bottomViewHeight = TABBAR_HEIGHT
    let locationImage = #imageLiteral(resourceName: "selectedAdress")
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    let deliveryTimeImage = #imageLiteral(resourceName: "orderSubmitDeliveryTime")
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var sectionFooterView:UIView!
    var tableFooterView:UIView!
    var actionSheetView:OrderAdressSelectedView!
    var appointTimeSheetView:OrderDeliveryTimeSelectedView!
    //bottomview
    var  bottomView:UIView!
    var selectedReciverTF:UITextField!
    var selectedReciverAdressTF:UITextField!
    var selectedDeliveryTimeTF:UITextField!
    //备注
    var otherInfoTF:UITextField!
    //网络异常空白页
    public var orderSubmitAbnormalView:XYAbnormalViewManager!
    
    //bottom实际待支付
    var forPayAmountLable:UILabel!
    //bottom实际优惠
    var discountAmountLable:UILabel!
    
    //tablefooter
    var totalMoneyLabel:UILabel!
    //已优惠
    var discountMoneyLabel:UILabel!
    //待支付
    var needPayAmountLabel:UILabel!
    //提交按钮
    var submitBtn:UIButton!
    
    //获取页面数据Model
    var submiteModel:OrderSubmitModel!
    //提交参数Model
    var submitPrametersModel:OrderSubmitParametersModel = OrderSubmitParametersModel()
    var merchantID:String!
    var deliveryFee:Int!
    var sellerName:String!
    var service:orderSubmitService =  orderSubmitService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        submitPrametersModel.merchantID = self.merchantID
        self.service.orderPrepareDataGetRequest(target: self, merchantID: self.merchantID)
        // Do any additional setup after loading the view.
    }

    //MARK: - 刷新UI
    func refreshUI(){
        
        if self.submitPrametersModel.selectedRecieverModel != nil {
            let spaceText = " "
            var sexStr = "女士"
            if submitPrametersModel.selectedRecieverModel.Sex == 1 {
                sexStr = "先生"
            }
            selectedReciverTF.text = submitPrametersModel.selectedRecieverModel.UserName + spaceText + sexStr + spaceText + submitPrametersModel.selectedRecieverModel.PhoneNumber
        }
        
        if self.submitPrametersModel.selectedAdressModel != nil && self.submitPrametersModel.selectedSchoolBuildingModel != nil {
            
            selectedReciverAdressTF.text = submitPrametersModel.selectedAdressModel.FAreaName + " " + submitPrametersModel.selectedSchoolBuildingModel.SAreaName
            
        }
        
        if self.submitPrametersModel.selectedDeliveryTimeModel != nil  {
            if submitPrametersModel.selectedDeliveryTimeModel.isDeliverySoon == false {
            selectedDeliveryTimeTF.text =  "预约 " + submitPrametersModel.selectedDeliveryTimeModel.ExpressTime
            }else{
                selectedDeliveryTimeTF.text = submitPrametersModel.selectedDeliveryTimeModel.ExpressTime
            }
        }
        
        
        //待支付金额UI刷新
        if self.submitPrametersModel.selectedPromotionModel != nil && self.submitPrametersModel.isUseJF == true {
            
            discountMoneyLabel.text = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount+submitPrametersModel.selectedPromotionModel.CCAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            
            
            needPayAmountLabel.text  = "待支付: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.needPayAmount - (submitPrametersModel.selectedPromotionModel.CCAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100))
            
            forPayAmountLable.text = "待支付 ¥" +  moneyExchangeToString(moneyAmount: submiteModel.needPayAmount - (submitPrametersModel.selectedPromotionModel.CCAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100))
            discountAmountLable.text = "优惠 ¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount+submitPrametersModel.selectedPromotionModel.CCAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            
            submitPrametersModel.needPayAmount = submiteModel.needPayAmount - (submitPrametersModel.selectedPromotionModel.CCAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            
            
        }else  if self.submitPrametersModel.selectedPromotionModel != nil {
            
            discountMoneyLabel.text = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount+submitPrametersModel.selectedPromotionModel.CCAmount)
            needPayAmountLabel.text  = "待支付: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.needPayAmount - submitPrametersModel.selectedPromotionModel.CCAmount)
            
            forPayAmountLable.text = "待支付 ¥" +  moneyExchangeToString(moneyAmount: submiteModel.needPayAmount - submitPrametersModel.selectedPromotionModel.CCAmount)
            discountAmountLable.text = "优惠 ¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount+submitPrametersModel.selectedPromotionModel.CCAmount)
            
            submitPrametersModel.needPayAmount = submiteModel.needPayAmount - submitPrametersModel.selectedPromotionModel.CCAmount
            
        } else  if self.submitPrametersModel.isUseJF == true {
            discountMoneyLabel.text = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            needPayAmountLabel.text  = "待支付: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.needPayAmount -  self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            
            forPayAmountLable.text = "待支付 ¥" +  moneyExchangeToString(moneyAmount: submiteModel.needPayAmount -  self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            discountAmountLable.text = "优惠 ¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount + self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100)
            submitPrametersModel.needPayAmount = submiteModel.needPayAmount -  self.submitPrametersModel.useJFAmount/self.submiteModel.JFExchangeAmount*100
        }else{
            discountMoneyLabel.text = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount)
            needPayAmountLabel.text  = "待支付: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.needPayAmount)
            
            forPayAmountLable.text = "待支付 ¥" +  moneyExchangeToString(moneyAmount: submiteModel.needPayAmount)
            discountAmountLable.text = "优惠 ¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount)
            submitPrametersModel.needPayAmount = submiteModel.needPayAmount
        }
        
        discountMoneyLabel.frame.size.width = discountMoneyLabel.text!.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        
        let needPayAmountStrWidth = needPayAmountLabel.text!.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        needPayAmountLabel.frame.origin.x  = SCREEN_WIDTH - toside - needPayAmountStrWidth
        needPayAmountLabel.frame.size.width = needPayAmountStrWidth
        
        forPayAmountLable.frame.size.width =  forPayAmountLable.text!.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(17)), font: cmSystemFontWithSize(17))
        
        discountAmountLable.frame.origin.x = forPayAmountLable.right + cmSizeFloat(7)
        discountAmountLable.frame.size.width = discountAmountLable.text!.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "配置订单"
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: topView.bottom , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT - topView.bottom), in: self.view)
        
        if isNetError == true{
            orderSubmitAbnormalView = abnormalView
            orderSubmitAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            orderSubmitAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.orderPrepareDataGetRequest(target: self!, merchantID: self!.merchantID)
            }
        }
    }
    
    //MARK: - 创建bottomView
    func createBottomView() {
        
        bottomView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - bottomViewHeight, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = cmColorWithString(colorName: "565555")
        
        let forPayAmountStr = "待支付 ¥" +  moneyExchangeToString(moneyAmount: submiteModel.needPayAmount)
       forPayAmountLable = UILabel(frame: CGRect(x: toside, y: 0, width: forPayAmountStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(17)), font: cmSystemFontWithSize(17)), height: bottomViewHeight))
        forPayAmountLable.textColor = MAIN_WHITE
        forPayAmountLable.font = cmSystemFontWithSize(17)
        forPayAmountLable.textAlignment = .left
        forPayAmountLable.text = forPayAmountStr
        bottomView.addSubview(forPayAmountLable)
        
       let discountAmoutStr = "优惠 ¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount)
         discountAmountLable = UILabel(frame: CGRect(x: forPayAmountLable.right + cmSizeFloat(7), y: 0, width: discountAmoutStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)), height: bottomViewHeight))
        discountAmountLable.textColor = MAIN_WHITE
        discountAmountLable.font = cmSystemFontWithSize(14)
        discountAmountLable.textAlignment = .left
        discountAmountLable.text = discountAmoutStr
        bottomView.addSubview(discountAmountLable)
        
        
        submitBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH*2/3, y: 0, width: SCREEN_WIDTH*1/3, height: bottomViewHeight))
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = cmColorWithString(colorName: "0ED390")
        submitBtn.setTitle("提交订单", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnAct), for: .touchUpInside)
        bottomView.addSubview(submitBtn)
        
        self.view.addSubview(bottomView)
    }
    
    //MARK: - 提交按钮响应
    @objc func submitBtnAct(){
        
        if self.submitPrametersModel.selectedRecieverModel == nil {
            cmShowHUDToWindow(message: "请选择收货人")
            return
        }
        if self.submitPrametersModel.selectedAdressModel == nil || self.submitPrametersModel.selectedSchoolBuildingModel == nil {
            cmShowHUDToWindow(message: "请选择收货地址")
            return
        }
        
        if self.submitPrametersModel.selectedDeliveryTimeModel == nil {
            cmShowHUDToWindow(message: "请选择配送时间")
            return
        }
        
        if !otherInfoTF.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.submitPrametersModel.remarksInfo = otherInfoTF.text!
        }
        
        submitBtn.isEnabled = false
        service.submitOrderRequest(model: submitPrametersModel, successAct: { [weak self] (resultModel) in
            DispatchQueue.main.async {
                let payOrderVC = OrderPayVC()
                payOrderVC.orderPayModel = resultModel
                self?.navigationController?.pushViewController(payOrderVC, animated: true)
            }
        }) { [weak self ] in
            DispatchQueue.main.async {
                self?.submitBtn.isEnabled = true
            }
        }
        
        
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        creatTableHeaderView()
        createTableFootView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT-bottomViewHeight), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.tableFooterView = self.tableFooterView
        mainTabView.register(OrderDetailGoodsCell.self, forCellReuseIdentifier: "OrderDetailGoodsCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - 创建tableHeader
    func creatTableHeaderView() {
        
        let toside = cmSizeFloat(5)
        
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(7*3) + textLineHeight*3))
        tableHeaderView.backgroundColor = MAIN_BLUE
        
        
        //收货人
        let imageToAdressViewSide = cmSizeFloat(15)
        let adressView = UIView(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height: textLineHeight))
        adressView.backgroundColor = .white
        tableHeaderView.addSubview(adressView)
        
        let locationImageView = UIImageView(frame: CGRect(x: imageToAdressViewSide, y: 0, width: locationImage.size.width, height: textLineHeight))
        locationImageView.backgroundColor = .white
        locationImageView.image = locationImage
        locationImageView.contentMode = .scaleAspectFit
        adressView.addSubview(locationImageView)
        
        let selectedAdressTitleStr = "收货人地址: "
        let selectedAdressTitleStrWidth = selectedAdressTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)), font: cmBoldSystemFontWithSize(15))
        let selectedAdressLabel = UILabel(frame: CGRect(x: locationImageView.right + cmSizeFloat(7), y: 0, width: selectedAdressTitleStrWidth + cmSizeFloat(7), height: textLineHeight))
            selectedAdressLabel.textColor = MAIN_BLACK
        selectedAdressLabel.font = cmBoldSystemFontWithSize(14)
        selectedAdressLabel.textAlignment = .left
        selectedAdressLabel.backgroundColor = .white

        selectedAdressLabel.text = selectedAdressTitleStr
        adressView.addSubview(selectedAdressLabel)
        
        
        selectedReciverTF = UITextField(frame: CGRect(x: selectedAdressLabel.right, y: 0, width: adressView.frame.size.width   - selectedAdressLabel.right , height: textLineHeight))
        selectedReciverTF.font = cmSystemFontWithSize(15)
        selectedReciverTF.textColor = MAIN_BLUE
        selectedReciverTF.textAlignment = .right
        selectedReciverTF.backgroundColor = .white
        selectedReciverTF.placeholder = "请选择收货人"
        let showMoreImageView = UIImageView(frame: CGRect(x: selectedReciverTF.frame.size.width - toside*2 - showMoreImage.size.width, y: textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        selectedReciverTF.rightView = showMoreImageView
        selectedReciverTF.rightViewMode = .always
        selectedReciverTF.delegate = self
        adressView.addSubview(selectedReciverTF)
        
        if submiteModel.defaultRecieverModel != nil {
            let spaceText = " "
            var sexStr = "女士"
            if submiteModel.defaultRecieverModel.Sex == 1 {
                sexStr = "先生"
            }
            selectedReciverTF.text = submiteModel.defaultRecieverModel.UserName + spaceText + sexStr + spaceText + submiteModel.defaultRecieverModel.PhoneNumber
            submitPrametersModel.selectedRecieverModel = submiteModel.defaultRecieverModel
        }
        
        
        //收货地址
        selectedReciverAdressTF = UITextField(frame: CGRect(x: toside, y: adressView.bottom, width: SCREEN_WIDTH   - toside*2 , height: textLineHeight))
        selectedReciverAdressTF.font = cmSystemFontWithSize(15)
        selectedReciverAdressTF.textColor = MAIN_BLUE
        selectedReciverAdressTF.textAlignment = .right
        selectedReciverAdressTF.backgroundColor = .white
        selectedReciverAdressTF.placeholder = "请选择一个收货地址"
        let adressShowMoreImageView = UIImageView(frame: CGRect(x: selectedReciverAdressTF.frame.size.width - toside*2 - showMoreImage.size.width, y: textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        adressShowMoreImageView.image = showMoreImage
        adressShowMoreImageView.contentMode = .scaleAspectFit
        selectedReciverAdressTF.rightView = adressShowMoreImageView
        selectedReciverAdressTF.rightViewMode = .always
        selectedReciverAdressTF.delegate = self
        tableHeaderView.addSubview(selectedReciverAdressTF)
        
        
        //送达时间
        let deliveryTimeView = UIView(frame: CGRect(x: toside, y: selectedReciverAdressTF.bottom + cmSizeFloat(7), width: SCREEN_WIDTH - toside*2, height: textLineHeight))
        deliveryTimeView.backgroundColor = .white
        tableHeaderView.addSubview(deliveryTimeView)
        
        let deliveryImageView = UIImageView(frame: CGRect(x: imageToAdressViewSide, y: 0, width: deliveryTimeImage.size.width, height: textLineHeight))
        deliveryImageView.backgroundColor = .white
        deliveryImageView.image = deliveryTimeImage
        deliveryImageView.contentMode = .scaleAspectFit
        deliveryTimeView.addSubview(deliveryImageView)
        
        let deleveryTimeTitleStr = "配送时间: "
        let deleveryTimeLabel = UILabel(frame: CGRect(x: deliveryImageView.right + cmSizeFloat(7), y: 0, width: selectedAdressTitleStrWidth + cmSizeFloat(7), height: textLineHeight))
        deleveryTimeLabel.textColor = MAIN_BLACK
        deleveryTimeLabel.font = cmBoldSystemFontWithSize(14)
        deleveryTimeLabel.textAlignment = .left
        deleveryTimeLabel.backgroundColor = .white
        
        
        deleveryTimeLabel.text = deleveryTimeTitleStr
        deliveryTimeView.addSubview(deleveryTimeLabel)
        
        
        selectedDeliveryTimeTF = UITextField(frame: CGRect(x: deleveryTimeLabel.right, y: 0, width: deliveryTimeView.frame.size.width   - deleveryTimeLabel.right , height: textLineHeight))
        selectedDeliveryTimeTF.font = cmSystemFontWithSize(15)
        selectedDeliveryTimeTF.textColor = MAIN_BLUE
        selectedDeliveryTimeTF.textAlignment = .right
        selectedDeliveryTimeTF.backgroundColor = .white
        selectedDeliveryTimeTF.placeholder = "请选择"
        //selectedDeliveryTimeTF.text = "尽快送达"

        
        let deliveryShowMoreImageView = UIImageView(frame: CGRect(x: selectedDeliveryTimeTF.frame.size.width - toside*2 - showMoreImage.size.width, y: textLineHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        deliveryShowMoreImageView.image = showMoreImage
        deliveryShowMoreImageView.contentMode = .scaleAspectFit
        selectedDeliveryTimeTF.rightView = deliveryShowMoreImageView
        selectedDeliveryTimeTF.rightViewMode = .always
        selectedDeliveryTimeTF.delegate = self
        deliveryTimeView.addSubview(selectedDeliveryTimeTF)
        
        //分割线
        tableHeaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: deliveryTimeView.bottom + cmSizeFloat(7), lineWidth:SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
        
    }
    //MARK: - createTableFootView
    func createTableFootView() {
        let tableFooterViewHeight = textLineHeight*4
        let showMoreBtnSize = textLineHeight
        let mechantDiscountStrArr:[String] = ["商家积分","商家代金券"]
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableFooterViewHeight))
        tableFooterView.backgroundColor = .white
        for index in 0..<mechantDiscountStrArr.count {
            //进入选择商家优惠按钮
            let chooseDiscountBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - showMoreBtnSize, y: textLineHeight*CGFloat(index), width: showMoreBtnSize, height: showMoreBtnSize))
            chooseDiscountBtn.setImage(#imageLiteral(resourceName: "sellerDetailShowMore"), for: .normal)
            chooseDiscountBtn.tag = 300 + index
            chooseDiscountBtn.addTarget(self, action: #selector(chooseDiscountBtnAct(sender:)), for: .touchUpInside)
            tableFooterView.addSubview(chooseDiscountBtn)
            
            let placeHolderStr = "请选择"
            let chooseDiscountResultLabel = UILabel(frame: CGRect(x:chooseDiscountBtn.left -  placeHolderStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)), y: textLineHeight*CGFloat(index), width: placeHolderStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)), height: textLineHeight))
            chooseDiscountResultLabel.textColor = MAIN_GRAY
            chooseDiscountResultLabel.font = cmSystemFontWithSize(14)
            chooseDiscountResultLabel.textAlignment = .left
            chooseDiscountResultLabel.text = placeHolderStr
            chooseDiscountResultLabel.tag = 400 + index
            tableFooterView.addSubview(chooseDiscountResultLabel)
            
            
            let discountTitleLabel = UILabel(frame: CGRect(x: toside, y: chooseDiscountResultLabel.top, width: SCREEN_WIDTH/2, height: showMoreBtnSize))
            discountTitleLabel.textColor = MAIN_BLACK
            discountTitleLabel.font = cmSystemFontWithSize(14)
            discountTitleLabel.textAlignment = .left
            discountTitleLabel.text = mechantDiscountStrArr[index]
            tableFooterView.addSubview(discountTitleLabel)
        }
        
        let seprerateLine = XYCommonViews.creatCommonSeperateLine(pointY: textLineHeight*2 -  cmSizeFloat(1))
        tableFooterView.addSubview(seprerateLine)
        
        let textToTopBottom = (textLineHeight - seperateLineHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))/2
        let totalMoneyStr = "总计: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.totalMoney + submiteModel.discountAmount)
         totalMoneyLabel =  UILabel(frame: CGRect(x: toside, y: seprerateLine.bottom +  textToTopBottom, width: totalMoneyStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
        totalMoneyLabel.textColor = MAIN_GRAY
        totalMoneyLabel.font = cmSystemFontWithSize(13)
        totalMoneyLabel.textAlignment = .left
        totalMoneyLabel.text = totalMoneyStr
        tableFooterView.addSubview(totalMoneyLabel)
        
        let discountMoneyStr = "已优惠: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.discountAmount)
         discountMoneyLabel = UILabel(frame: CGRect(x: totalMoneyLabel.right + cmSizeFloat(15), y: totalMoneyLabel.top, width:discountMoneyStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)), height: totalMoneyLabel.frame.size.height))
        discountMoneyLabel.textColor = MAIN_GRAY
        discountMoneyLabel.font = cmSystemFontWithSize(13)
        discountMoneyLabel.textAlignment = .left
        discountMoneyLabel.text = discountMoneyStr
        tableFooterView.addSubview(discountMoneyLabel)
        
        let needPayAmountStr = "待支付: " + "¥" + moneyExchangeToString(moneyAmount: submiteModel.needPayAmount)
        let needPayAmountStrWidth = needPayAmountStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        needPayAmountLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - toside - needPayAmountStrWidth, y: totalMoneyLabel.top, width:needPayAmountStrWidth, height: totalMoneyLabel.frame.size.height))
        needPayAmountLabel.textColor = MAIN_RED
        needPayAmountLabel.font = cmSystemFontWithSize(13)
        needPayAmountLabel.textAlignment = .left
        needPayAmountLabel.text = needPayAmountStr
        tableFooterView.addSubview(needPayAmountLabel)
        
        tableFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: needPayAmountLabel.bottom + textToTopBottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        //备注
         otherInfoTF = UITextField(frame: CGRect(x: toside, y: needPayAmountLabel.bottom + textToTopBottom + seperateLineHeight, width:SCREEN_WIDTH - toside*2, height: textLineHeight))
        otherInfoTF.textColor = MAIN_BLACK
        otherInfoTF.font = cmSystemFontWithSize(14)
        otherInfoTF.textAlignment = .left
        otherInfoTF.placeholder = "请输入备注信息"
        
        let otherInfoStr = "备注: "
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: otherInfoStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + cmSizeFloat(7), height: textLineHeight))
        leftView.textColor = MAIN_BLACK
        leftView.font = cmSystemFontWithSize(14)
        leftView.textAlignment = .left
        leftView.text = otherInfoStr
        otherInfoTF.leftView = leftView
        otherInfoTF.leftViewMode = .always
        otherInfoTF.delegate = self
        otherInfoTF.returnKeyType = .done
        
        tableFooterView.addSubview(otherInfoTF)

        
    }
    
    
    //MARK: - 选择优惠
    @objc func chooseDiscountBtnAct(sender:UIButton) {
        if sender.tag == 301 {
            let selectedPromotionVC = OrderChoosePromotionVC()
            selectedPromotionVC.promotionModelArr = submiteModel.promotionArr
            selectedPromotionVC.selectedFinishAct = { [weak self] in
                    let selecDiscountView = self!.view.viewWithTag(sender.tag - 300 + 400)
                    if let  selecDiscountLabel = selecDiscountView as? UILabel {
                        if self?.submitPrametersModel.selectedPromotionModel != nil {
                            selecDiscountLabel.text = "-¥" + moneyExchangeToStringTwo(moneyAmount: self!.submitPrametersModel.selectedPromotionModel.CCAmount)
                            selecDiscountLabel.textColor = MAIN_RED
                        }else{
                            selecDiscountLabel.text = "请选择"
                            selecDiscountLabel.textColor = MAIN_GRAY
                        }
                    }
                }
            self.navigationController?.pushViewController(selectedPromotionVC, animated: true)
        }else{
            
            if submiteModel.IfJFExchange == false{
                cmShowHUDToWindow(message: "商家暂不支持或你的积分不够")
                return
            }
            
            let selectedJFExchangeVC = OrderChooseJFExchangeVC()
            selectedJFExchangeVC.jfAmount = submiteModel.JFAmount
            selectedJFExchangeVC.jfExchangeAmount = submiteModel.JFExchangeAmount
            selectedJFExchangeVC.selectedFinishAct = { [weak self] in
                let selecDiscountView = self!.view.viewWithTag(sender.tag - 300 + 400)
                if let  selecDiscountLabel = selecDiscountView as? UILabel {
                    if self?.submitPrametersModel.isUseJF == true {
                        selecDiscountLabel.text = "-¥" +  String(self!.submitPrametersModel.useJFAmount/100)
                        selecDiscountLabel.textColor = MAIN_RED
                    }else{
                        selecDiscountLabel.text = "请选择"
                        selecDiscountLabel.textColor = MAIN_GRAY
                    }
                }
            }
            self.navigationController?.pushViewController(selectedJFExchangeVC, animated: true)
        }
        
        
        
        
    }
    
    //MARK: - sectionFooter
    func createSectionFooterView() {
        let sectionFooterViewHeight = textLineHeight + seperateLineHeight*3 +  textLineHeight * CGFloat(submiteModel.userDiscountArr.count)
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
        if submiteModel.isDeliveryFree {
            let attributes = [NSAttributedStringKey.font:cmSystemFontWithSize(14),NSAttributedStringKey.foregroundColor:MAIN_BLACK,NSAttributedStringKey.strikethroughStyle:NSNumber.init(value:1)]
            deliveryAmountLabel.attributedText = NSAttributedString.init(string: "¥" + moneyExchangeToString(moneyAmount: submiteModel.deliveryMoney) , attributes: attributes)
        }else{
            deliveryAmountLabel.text = "¥" + moneyExchangeToString(moneyAmount: submiteModel.deliveryMoney)
        }
        sectionFooterView.addSubview(deliveryAmountLabel)
        
        sectionFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: deliveryAmountLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
        
        //折扣信息View
        let promotionLabelSize = "积".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        
        
        for index in 0..<submiteModel.userDiscountArr.count {
            
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
            discountAmountLabel.text = "-¥" +  moneyExchangeToString(moneyAmount: submiteModel.userDiscountArr[index].reduceMoney)
            sectionFooterView.addSubview(discountAmountLabel)
            
            let discountTitleLabel = UILabel(frame: CGRect(x: discountStatusLabel.right  + cmSizeFloat(7), y: discountAmountLabel.top, width: SCREEN_WIDTH - (SCREEN_WIDTH - toside*2)/6 - discountStatusLabel.right - cmSizeFloat(7), height: textLineHeight))
            discountTitleLabel.textColor = MAIN_BLACK
            discountTitleLabel.font = cmSystemFontWithSize(14)
            discountTitleLabel.textAlignment = .left
            discountTitleLabel.text = submiteModel.userDiscountArr[index].discountStatus.rawValue
            sectionFooterView.addSubview(discountTitleLabel)
            
            if index == submiteModel.userDiscountArr.count - 1 {
                sectionFooterView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: discountTitleLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight))
            }
            
            switch submiteModel.userDiscountArr[index].discountStatus {
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
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submiteModel.goodsCellArr.count
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
            
            targetCell.setModel(model: submiteModel.goodsCellArr[indexPath.row])
            
            if submiteModel.goodsCellArr[indexPath.row].goodsIsAttach == true {
                targetCell.goodsPriceLabel.text = "¥" + moneyExchangeToString(moneyAmount: submiteModel.goodsCellArr[indexPath.row].goodsPrice)
            }else{
                targetCell.goodsPriceLabel.text = "¥" + moneyExchangeToString(moneyAmount: submiteModel.goodsCellArr[indexPath.row].goodsPrice * submiteModel.goodsCellArr[indexPath.row].goodsCount)
            }
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return textLineHeight + seperateLineHeight*3 +  textLineHeight * CGFloat(submiteModel.userDiscountArr.count)
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
        sectionLabel.text = submiteModel.sellerName
        sectionView.addSubview(sectionLabel)
        
        sectionView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: cmSizeFloat(40 - 1)))
        
        return sectionView
    }
    
    
    //MARK: - 创建弹框配送地址View
    func creatActionSheetView(){
        actionSheetView = OrderAdressSelectedView(frame:CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2))
        self.view.addSubview(actionSheetView)
    }
    
    //MARK: - 创建弹框预约时间
    func creatAppointTimeSheetView(){
        appointTimeSheetView =  OrderDeliveryTimeSelectedView(frame:CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/2))
        self.view.addSubview(appointTimeSheetView)
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectedReciverTF {
            let recieverVC = OrderReciverSetVC()
            recieverVC.recieverArr = submiteModel.recieverArr
            self.navigationController?.pushViewController(recieverVC, animated: true)
            return false
        }else if textField ==  selectedReciverAdressTF{
            if actionSheetView == nil {
                self.creatActionSheetView()
            }
            actionSheetView.showInView(view: self.view)
            return false
        }else if textField ==  selectedDeliveryTimeTF{
            if appointTimeSheetView == nil {
                creatAppointTimeSheetView()
            }
            appointTimeSheetView.showInView(view: self.view)
            return false
        }
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
