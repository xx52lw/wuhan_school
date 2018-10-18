//
//  ShopcartVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/25.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ShopcartVC: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    

    let bottomViewHeight = TABBAR_HEIGHT
    let bottomViewToside = cmSizeFloat(15)
    let scrollViewHeihgt = cmSizeFloat( (IS_IPHONEX ? 180 : 140)+40)
    let sellerInfoViewHeight = IS_IPHONEX ? cmSizeFloat(180) : cmSizeFloat(140)
    let segmentBtnsViewHeight = cmSizeFloat(40)
    let typesBtnWidth = cmSizeFloat(75)
    let typesBtnHeight = cmSizeFloat(60)
    let discountInfoHeight = cmSizeFloat(30)
    let goodsTabToTypeScrollWidth = cmSizeFloat(10)
    let goodsTableHeaderHeihgt = cmSizeFloat(25)
    
    let shopcartUnableImage = #imageLiteral(resourceName: "shopcartImageUnable")
    let shopcartEnableImage = #imageLiteral(resourceName: "shopcartImageEnable")
    
    var typesScrollView:UIScrollView!
    
    var shopCartBtn:UIButton!
    var settlementBtn:UIButton!
    var priceLabel:UILabel!
    var deliveryInfoLabel:UILabel!
    var discountInfoLabel:UILabel!

    //品类指示器
    var typeSideBar:UILabel!
    //商品tableVeiw
    var goodsTableView:UITableView!
    //显示当前品类的header
    var goodsTableHeaderLabel:UILabel!
    
    //maskview
    var shopcartMaskView:MaskView!
    //shopcartView
    var shopcartView:ShopcartView!
    //bottomview
    var  bottomView:UIView!
    
    var typeLabelsArr:[UIView] = Array()
    
    var canScroll:Bool! = false
    var isShowShopcart:Bool = false
    var sellerModel:SellerHomePageModel!
    
    var shopcartService:ShopCartService =  ShopCartService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       sellerModel = SellerDetailPageVC.shopVCSellerHomeCommonModel
        
        creatTypesScrollView()
        creatTableHeader()
        creatGoodsTabView()
        createDiscountInfoView()
        creatBottomView()
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Go_Top"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Leave_Top"), object: nil)
        // Do any additional setup after loading the view.
    }

    
    @objc  func acceptMsg(notification:Notification) {
        let notificationName = notification.name
        if notificationName.rawValue == "Home_Go_Top"  {
            let userInfo = notification.userInfo
            let canscroll = userInfo!["canScroll"] as! String
            if canscroll == "1" {
                self.canScroll = true
                
            }
        }else if notificationName.rawValue == "Home_Leave_Top"  {
            self.goodsTableView.contentOffset = CGPoint.zero
            self.canScroll = false;
        }
    }
    
    
    
    
    
    //MARK: - 创建底部结算栏
    func creatBottomView(){
        
        bottomView = UIView(frame: CGRect(x: 0, y: discountInfoLabel.bottom, width: SCREEN_WIDTH, height: bottomViewHeight))
        bottomView.backgroundColor = cmColorWithString(colorName: "565555")
        
        settlementBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH*2/3, y: 0, width: SCREEN_WIDTH*1/3, height: bottomViewHeight))
        let btnStr = "¥" + moneyExchangeToStringTwo(moneyAmount: sellerModel.deliveryLimit) +  "起送"
        settlementBtn.setTitle(btnStr, for: .normal)
        settlementBtn.setTitleColor(.white, for: .normal)
        settlementBtn.backgroundColor = cmColorWithString(colorName: "757474")
        settlementBtn.setTitle("去结算", for: .selected)
        settlementBtn.setTitleColor(.white, for: .normal)
        settlementBtn.addTarget(self, action: #selector(settlementBtnAct), for: .touchUpInside)
        settlementBtn.isEnabled = false
        bottomView.addSubview(settlementBtn)
        
        
        let priceLabelHeight = cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(20))
        let deliveryInfoLabelHeight  = cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))
        let wordSpaceHeight = cmSizeFloat(2)
        
        priceLabel = UILabel(frame: CGRect(x: bottomViewToside*2 + shopcartUnableImage.size.width, y: (bottomViewHeight - priceLabelHeight - deliveryInfoLabelHeight - wordSpaceHeight)/2 , width: SCREEN_WIDTH*2/3 - (bottomViewToside*2 + shopcartUnableImage.size.width), height: priceLabelHeight))
        priceLabel.font = cmBoldSystemFontWithSize(20)
        priceLabel.textColor = cmColorWithString(colorName: "ffffff")
        priceLabel.text = "¥0.0"
        bottomView.addSubview(priceLabel)
        
        deliveryInfoLabel = UILabel(frame: CGRect(x: priceLabel.left, y: priceLabel.bottom + wordSpaceHeight, width: priceLabel.size.width, height: deliveryInfoLabelHeight))
        deliveryInfoLabel.font = cmSystemFontWithSize(12)
        deliveryInfoLabel.textColor = cmColorWithString(colorName: "ffffff")
        var deliveryInfoStr = "配送费: ¥" + moneyExchangeToStringTwo(moneyAmount: sellerModel.deliveryFee)
        if sellerModel.EnoughFreeDelivery == true {
            deliveryInfoStr += "  满¥" + moneyExchangeToStringTwo(moneyAmount: sellerModel.EFDeliveryAmount) + "免配送费"
        }
        deliveryInfoLabel.text = deliveryInfoStr
        bottomView.addSubview(deliveryInfoLabel)
        
        shopCartBtn = UIButton(frame: CGRect(x: bottomViewToside, y: cmSizeFloat(-15), width: shopcartUnableImage.size.width, height: shopcartUnableImage.size.height))
        shopCartBtn.setImage(shopcartUnableImage, for: .normal)
        shopCartBtn.setImage(shopcartEnableImage, for: .selected)
        shopCartBtn.addTarget(self, action: #selector(shopcartAct), for: .touchUpInside)
        bottomView.addSubview(shopCartBtn)
        
        self.view.addSubview(bottomView)
        
        refreshBottomView()
    }
    
    //MARK: - 创建优惠信息View
    func createDiscountInfoView(){
        discountInfoLabel = UILabel(frame: CGRect(x: 0, y: SCREEN_HEIGHT-scrollViewHeihgt - bottomViewHeight-discountInfoHeight, width: SCREEN_WIDTH, height: discountInfoHeight))
        discountInfoLabel.backgroundColor = cmColorWithString(colorName: "ffffcc")
        discountInfoLabel.font = cmSystemFontWithSize(13)
        discountInfoLabel.textColor = MAIN_BLACK2
        discountInfoLabel.textAlignment = .center
        discountInfoLabel.text = discountInfoDataMake()
        if discountInfoDataMake().isEmpty {
            discountInfoLabel.backgroundColor = .clear
        }
        self.view.addSubview(discountInfoLabel)
    }
    
    //MARK: - 优惠信息处理
    func discountInfoDataMake() ->String {
        var discountInfo = ""

        if sellerModel.EnoughReduceOne == true {
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: sellerModel.OneEnough))元减\(moneyExchangeToStringTwo(moneyAmount: sellerModel.OneReduce))元"
        }
        
        
        if sellerModel.EnoughReduceTwo == true {
            if !discountInfo.isEmpty {
                discountInfo += "、"
            }
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: sellerModel.TwoEnough))元减\(moneyExchangeToStringTwo(moneyAmount: sellerModel.TwoReduce))元"
        }
        
        
        if sellerModel.EnoughReduceThree == true {
            if !discountInfo.isEmpty {
                discountInfo += "、"
            }
            discountInfo  = discountInfo + "满\(moneyExchangeToStringTwo(moneyAmount: sellerModel.ThreeEnough))元减\(moneyExchangeToStringTwo(moneyAmount: sellerModel.ThreeReduce))元"
        }
        
        //没有满减显示时间
        if discountInfo.isEmpty {
            discountInfo = "营业时间: " + String(sellerModel.openOneStart) + ":00" + " - " + String(sellerModel.openOneEnd) + ":00"
            if sellerModel.hasOpenTwo == true {
                discountInfo = discountInfo + "、" + String(sellerModel.openTwoStart) + ":00" + " - " + String(sellerModel.openTwoEnd) + ":00"
            }
        }
        
        
        return discountInfo
        
    }
    
    
    
    //MARK: - 查看购物车按钮响应
    @objc func shopcartAct() {
        
        var shopcartCount = sellerModel.shopcartModelArr.count
        if shopcartCount > 4 {
            shopcartCount = 4
        }
        
        //如果购物车没有数据则提示
        if sellerModel.shopcartModelArr.count == 0{
            cmShowHUDToWindow(message: "购物车还是空的")
            return
        }
        
        if isShowShopcart == false {
            
            shopcartMaskView = MaskView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - (ShopcartView.headerViewHeihgt + CGFloat(shopcartCount) * ShopCartTableViewCell.ShopCartCellHeight) - bottomViewHeight - discountInfoHeight))
            UIApplication.shared.keyWindow?.addSubview(shopcartMaskView)
            
            shopcartView = ShopcartView(frame: CGRect(x: 0, y: shopcartMaskView.bottom, width: SCREEN_WIDTH, height: ShopcartView.headerViewHeihgt + CGFloat(shopcartCount) * ShopCartTableViewCell.ShopCartCellHeight))
            UIApplication.shared.keyWindow?.addSubview(shopcartView)
            isShowShopcart = !isShowShopcart
            
        }else{
            //收起购物车
            self.shopcartMaskView.removeMaskViewAct()
        }
        
        
    }
    //MARK: - 结算@objc 按钮响应
    @objc func settlementBtnAct() {
        
        if isShowShopcart == true {
            //收起购物车
            self.shopcartView.removeFromSuperview()
            self.shopcartMaskView.removeMaskViewAct()
            isShowShopcart = false
        }
        
        
        let  submitOrderVC = OrderSubmitViewController()
        submitOrderVC.merchantID = SellerDetailPageVC.commonMerchantID
        submitOrderVC.deliveryFee = SellerDetailPageVC.shopVCSellerHomeCommonModel.deliveryFee
        submitOrderVC.sellerName = SellerDetailPageVC.shopVCSellerHomeCommonModel.merchantName
        GetCurrentViewController()?.navigationController?.pushViewController(submitOrderVC, animated: true)
    }
    
    
    //MARK: - 刷新购物车和bottomView
    func refreshBottomView(){
        if sellerModel.shopcartModelArr.count > 0{
            
            shopCartBtn.isSelected = true
            settlementBtn.isSelected = true
            settlementBtn.isEnabled = true
            settlementBtn.backgroundColor = cmColorWithString(colorName: "0ed390")
            
        }else{
            self.shopCartBtn.isSelected = false
            settlementBtn.isEnabled = false
            settlementBtn.isSelected = false
            settlementBtn.backgroundColor = cmColorWithString(colorName: "757474")
            
        }
        totalMoneyCount()
        //暂停营业
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == false {
            settlementBtn.setTitle("已暂停营业", for: .normal)
            settlementBtn.isEnabled = false
        }
    }
    
    
    //MARK: - 购物车总金额计算和显示
    func totalMoneyCount(){
        var totalMoney = 0
        for index in 0..<sellerModel.shopcartModelArr.count{
            
            totalMoney += sellerModel.shopcartModelArr[index].selectedCount *  sellerModel.shopcartModelArr[index].goodsPriceStr
            
        }
        self.priceLabel.text = "¥" + moneyExchangeToString(moneyAmount: totalMoney)
    }
    
    
    
    //MARK: - 同步购物车当中的数据
    func updateShopcartGoodsData(_ currentIndex:Int) {
        
        if sellerModel.shopcartModelArr.count == 0 {
            let model = ShopcartModel()
            model.goodsID = sellerModel.goodsCellModelArr[currentIndex].goodsID
            model.selectedCount = sellerModel.goodsCellModelArr[currentIndex].selectedCount
            model.goodsNameStr = sellerModel.goodsCellModelArr[currentIndex].goodsName
            if !sellerModel.goodsCellModelArr[currentIndex].discountDetailStr.isEmpty {
                model.goodsPriceStr = sellerModel.goodsCellModelArr[currentIndex].discountPriceStr
            }else{
                model.goodsPriceStr = sellerModel.goodsCellModelArr[currentIndex].costPriceStr
            }
            model.otherInfoStr = "饭盒1个"
            sellerModel.shopcartModelArr.append(model)
            
            return
        }
        
        for modelIndex in 0..<sellerModel.shopcartModelArr.count {
            
            if sellerModel.shopcartModelArr[modelIndex].goodsID == sellerModel.goodsCellModelArr[currentIndex].goodsID {
                sellerModel.shopcartModelArr[modelIndex].selectedCount =  sellerModel.goodsCellModelArr[currentIndex].selectedCount
                //sellerModel.shopcartModelArr[modelIndex].otherInfoStr = "123"
                if sellerModel.shopcartModelArr[modelIndex].selectedCount == 0 {
                    sellerModel.shopcartModelArr.remove(at: modelIndex)
                }
                break
            }
            
            if modelIndex == sellerModel.shopcartModelArr.count - 1 {
                let model = ShopcartModel()
                model.goodsID = sellerModel.goodsCellModelArr[currentIndex].goodsID
                model.selectedCount = sellerModel.goodsCellModelArr[currentIndex].selectedCount
                model.goodsNameStr = sellerModel.goodsCellModelArr[currentIndex].goodsName
                //model.goodsPriceStr = sellerModel.goodsCellModelArr[currentIndex].discountPriceStr
                if !sellerModel.goodsCellModelArr[currentIndex].discountDetailStr.isEmpty {
                    model.goodsPriceStr = sellerModel.goodsCellModelArr[currentIndex].discountPriceStr
                }else{
                    model.goodsPriceStr = sellerModel.goodsCellModelArr[currentIndex].costPriceStr
                }
                model.otherInfoStr = ""
                sellerModel.shopcartModelArr.append(model)
            }
            
        }
        
        cmDebugPrint(sellerModel.shopcartModelArr.count)
        
    }
    
    
    //MARK: - 创建菜品分类scrollview
    func creatTypesScrollView(){
        typesScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: typesBtnWidth, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT - bottomViewHeight - segmentBtnsViewHeight - discountInfoHeight))
        if #available(iOS 11, *) {
            typesScrollView.contentInsetAdjustmentBehavior = .never
        }
        typesScrollView.contentSize = CGSize(width: typesBtnWidth, height: CGFloat(sellerModel.goodsCatArr.count) * typesBtnHeight)
        //typesScrollView.isScrollEnabled = false
        typesScrollView.alwaysBounceVertical = true
        typesScrollView.alwaysBounceHorizontal = false
        typesScrollView.showsVerticalScrollIndicator = false
        typesScrollView.showsHorizontalScrollIndicator = false
        typesScrollView.delegate = self
        typesScrollView.backgroundColor = cmColorWithString(colorName: "eeecec")
        self.createGoodsCatBtns(bntsNameArr: sellerModel.goodsCatArr)
        
        typeSideBar = UILabel(frame: CGRect(x: 0, y: 0, width: cmSizeFloat(2.5), height: typesBtnHeight))
        typeSideBar.backgroundColor = MAIN_BLUE
        typesScrollView.addSubview(typeSideBar)
        self.view.addSubview(typesScrollView)
    }
    
    
    
    
    //MARK: - 根据菜品分类数量创建btns
    func createGoodsCatBtns(bntsNameArr:[String]){
        
        for typeIndex in 0..<bntsNameArr.count {
            

            
            let typeLabelView = UIView(frame: CGRect(x: 0, y: typesBtnHeight * CGFloat(typeIndex), width: typesBtnWidth, height: typesBtnHeight))
            typeLabelView.tag = 300 + typeIndex
            typeLabelView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseTypeAct(sender:)))
            typeLabelView.addGestureRecognizer(tapGesture)
            typeLabelsArr.append(typeLabelView)
            if typeIndex == 0{
                typeLabelView.backgroundColor = cmColorWithString(colorName: "ffffff")
            }else{
                typeLabelView.backgroundColor = cmColorWithString(colorName: "eeecec")
            }
            
            let maxWidth = "测试文字".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
            var labelStrWidth = bntsNameArr[typeIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
            if labelStrWidth > maxWidth {
                labelStrWidth = maxWidth
            }
            let typeNameLabel = UILabel(frame: CGRect(x: (typesBtnWidth - labelStrWidth)/2, y: 0, width: labelStrWidth, height: typesBtnHeight))
            typeNameLabel.numberOfLines = 2
            typeNameLabel.text = bntsNameArr[typeIndex]
            typeNameLabel.font = cmSystemFontWithSize(12)
            typeNameLabel.textColor = MAIN_BLACK2
            typeNameLabel.textAlignment = .center
            typeLabelView.addSubview(typeNameLabel)

            typesScrollView.addSubview(typeLabelView)
            
            let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: typeNameLabel.bottom - cmSizeFloat(1))
            seperateLine.backgroundColor = cmColorWithString(colorName: "cccccc")
            typesScrollView.addSubview(seperateLine)
            
        }
        
    }
    
    
    
    //MARK: - 选择品类分类响应
    @objc func chooseTypeAct(sender:UITapGestureRecognizer){
        for typeLabel in typeLabelsArr {
            typeLabel.backgroundColor = cmColorWithString(colorName: "eeecec")
        }
        sender.view?.backgroundColor = cmColorWithString(colorName:"ffffff" )
        typeSideBar.frame.origin.y = typesBtnHeight * CGFloat((sender.view?.tag)! - 300)
        goodsTableHeaderLabel.text = sellerModel.goodsCatArr[sender.view!.tag - 300]
        
        //根据品类刷新当前品类下的数据
        cmDebugPrint(sellerModel.typeAndGoodsModelDicArr)
        sellerModel.goodsCellModelArr = sellerModel.typeAndGoodsModelDicArr[sender.view!.tag - 300].values.first!
        self.goodsTableView.reloadData()
        
    }
    
    
    
    //MARK: - 创建商品tableviewheader
    func creatTableHeader(){
        
        
        
        let goodsTableHeader = UIView(frame: CGRect(x: typesBtnWidth, y: 0, width: SCREEN_WIDTH - typesBtnWidth, height: goodsTableHeaderHeihgt))
        goodsTableHeader.backgroundColor = cmColorWithString(colorName: "eeecec")
        
        let sideBar = UILabel(frame: CGRect(x: 0, y: 0, width: cmSizeFloat(4), height: goodsTableHeaderHeihgt))
        sideBar.backgroundColor = cmColorWithString(colorName: "cccccc")
        goodsTableHeader.addSubview(sideBar)
        
        
        goodsTableHeaderLabel = UILabel(frame: CGRect(x: sideBar.right +  cmSizeFloat(10), y: 0, width: SCREEN_WIDTH - typesBtnWidth - cmSizeFloat(4) - cmSizeFloat(10), height: goodsTableHeaderHeihgt))
        goodsTableHeaderLabel.backgroundColor = cmColorWithString(colorName: "eeecec")
        goodsTableHeaderLabel.textColor = MAIN_BLACK2
        goodsTableHeaderLabel.textAlignment = .left
        goodsTableHeaderLabel.font = cmSystemFontWithSize(12)
        if sellerModel.goodsCatArr.count > 0{
            goodsTableHeaderLabel.text = sellerModel.goodsCatArr.first!
        }
        goodsTableHeader.addSubview(goodsTableHeaderLabel)
        self.view.addSubview(goodsTableHeader)
        
    }
    
    
    // MARK: - 创建主tableview
    func creatGoodsTabView(){
        
        goodsTableView = UITableView(frame: CGRect(x:typesBtnWidth + goodsTabToTypeScrollWidth ,y:goodsTableHeaderHeihgt, width:SCREEN_WIDTH-typesBtnWidth - goodsTabToTypeScrollWidth, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT - segmentBtnsViewHeight - bottomViewHeight-discountInfoHeight-goodsTableHeaderHeihgt), style: .plain)
        if #available(iOS 11, *) {
            goodsTableView.contentInsetAdjustmentBehavior = .never
            goodsTableView.estimatedRowHeight = 0
        }
        
        goodsTableView.showsVerticalScrollIndicator = false
        goodsTableView.showsHorizontalScrollIndicator = false
        
        goodsTableView.separatorStyle = .none
        goodsTableView.register(SellerDiscountGoodsTabCell.self, forCellReuseIdentifier: "SellerDiscountGoodsTabCell")
        goodsTableView.register(SellerNoDiscountTabCell.self, forCellReuseIdentifier: "SellerNoDiscountTabCell")
        
        
        
        goodsTableView.delegate = self
        goodsTableView.dataSource = self
        
        self.view.addSubview(goodsTableView)
        
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerModel.goodsCellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sellerModel.goodsCellModelArr[indexPath.row].discountDetailStr.isEmpty {
            return SellerNoDiscountTabCell.noDiscountCellHeight
        }else{
            return  SellerDiscountGoodsTabCell.discountCellHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sellerModel.goodsCellModelArr[indexPath.row].discountDetailStr.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "SellerNoDiscountTabCell")
            if cell == nil {
                cell = SellerNoDiscountTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "SellerNoDiscountTabCell")
            }
            if let targetCell = cell as? SellerNoDiscountTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: sellerModel.goodsCellModelArr[indexPath.row], index: indexPath.row)
                
                
                return targetCell
            }else{
                return cell!
            }
        }else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "SellerDiscountGoodsTabCell")
            if cell == nil {
                cell = SellerDiscountGoodsTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "SellerDiscountGoodsTabCell")
            }
            if let targetCell = cell as? SellerDiscountGoodsTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: sellerModel.goodsCellModelArr[indexPath.row], index: indexPath.row)
                
                
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goodsDetailVC = ShowGoodsDetailVC()
        goodsDetailVC.foodNameStr = sellerModel.goodsCellModelArr[indexPath.row].goodsName
        goodsDetailVC.goodsID = sellerModel.goodsCellModelArr[indexPath.row].goodsID
        goodsDetailVC.currentGoodsSelectedNum = sellerModel.goodsCellModelArr[indexPath.row].selectedCount
        goodsDetailVC.shopVCSelectedCellIndex = indexPath.row
        GetCurrentViewController()?.navigationController?.pushViewController(goodsDetailVC, animated: true)
    }

    
    //MARK: - Scrollview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.canScroll == false {
            scrollView.contentOffset = .zero
        }

        let offsetY = scrollView.contentOffset.y
        if (offsetY < 0) {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Home_Leave_Top") , object: nil, userInfo: ["canScroll":"1"])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBottomViewFrame()
    }
    

    
    
    //MARK: - 刷新结算栏位置
    func refreshBottomViewFrame() {
        if self.discountInfoLabel == nil {
            return
        }
        if let targetVC = GetCurrentViewController() as? SellerDetailPageVC {
            let offsetY = targetVC.containerScrollView.contentOffset.y
            
                self.discountInfoLabel.frame.origin.y = SCREEN_HEIGHT-scrollViewHeihgt - bottomViewHeight-discountInfoHeight + offsetY
                self.bottomView.frame.origin.y = self.discountInfoLabel.bottom
        }
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
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
