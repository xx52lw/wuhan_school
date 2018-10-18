//
//  ShowGoodsDetailVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/1.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class ShowGoodsDetailVC: UIViewController,XYBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    let sectionHeaderEvaluateHeight = cmSizeFloat(60)
    let addBtnSize = cmSizeFloat(44)
    let toside = cmSizeFloat(20)
    let seperateLineHeight = cmSizeFloat(7)
    let goodsNameLabelToTop = cmSizeFloat(15)
    let lineHeight = cmSizeFloat(7)
    let discountDetailHeight = cmSizeFloat(21)
    let wordWidth = SCREEN_WIDTH - cmSizeFloat(20)*2
    
    
    let sectionHeaderGoodsInfoHeight = cmSizeFloat(15*2) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)) + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)) + cmSizeFloat(7*2) + cmSizeFloat(44) + cmSizeFloat(7)
    let addImage = #imageLiteral(resourceName: "shopcartPlus")
    let reduceImage = #imageLiteral(resourceName: "shopcartReduce")
    let grayAddImage = #imageLiteral(resourceName: "grayAdd")
    
    var topView:XYTopView!
    //tableView
    var mainTabView:UITableView!
    //tableHeaderView
    var tableHeaderView:XYBannerBrowser!
    //sectionHeader
    var sectionHeader:UIView!
    //sectionHeader的子view
    var sectionHeaderEvaluateView:UIView!
    var sectionHeaderGoodsInfoView:UIView!
    var goodsDetailInfoView:UIView!
    var evaluateTitleLabel:UILabel!
    //网络异常空白页
    public var goodsDetailAbnormalView:XYAbnormalViewManager!
    
    var addBtn:UIButton!
    var selectedCountLabel:UILabel!
    var reduceBtn:UIButton!
    
    var foodNameStr:String!
    
    var goodsDetailShowModel:GoodsDetailShowModel!
    
    var currentGoodsSelectedNum = 0
    
    var goodsID:String!
    var service:GoodsDetailService = GoodsDetailService()
    
    var shopVCSelectedCellIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        service.goodsDetailDataRequest(target: self, goodsID: goodsID)
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        for sublayer in topView.layer.sublayers! {
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = foodNameStr
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0)
    }
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: 0 , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT), in: self.view)
        
        if isNetError == true{
            goodsDetailAbnormalView = abnormalView
            goodsDetailAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            goodsDetailAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.goodsDetailDataRequest(target: self!, goodsID: self!.goodsID)
            }
        }
    }
    
    //MARK: - 创建tableHeaderView
    func  creatTableHeaderView(){
        //创建BannerView
        tableHeaderView  = XYBannerBrowser(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:SCREEN_WIDTH), imageArrayUrl: goodsDetailShowModel.bannerUrlArr)
        tableHeaderView.delegate = self
    }
    
    
    //MARK: - 点击了当前的图片
    func didClickCurrentImage(currentIndex: Int) {
        
    }
    
    //MARK: 创建sectionHeader
    func creatSectionHeader() -> UIView{

        //goodsDeatail 常量
        let  goodsDetailLabelToTop = cmSizeFloat(15)
        let goodsDetailLabelHeight = goodsDetailShowModel.goodsDetailInfo.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        let goodsDetailInfoHeight = goodsDetailLabelHeight + goodsDetailLabelToTop*3 + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + seperateLineHeight
        
        sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeaderGoodsInfoHeight  + sectionHeaderEvaluateHeight + goodsDetailInfoHeight + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + cmSizeFloat(15)))
        sectionHeader.backgroundColor = .white
        

        createGoodsIntroduceView()
        createGoodsDetailInfoView()
        
        
        //评论title
         evaluateTitleLabel = UILabel(frame: CGRect(x: toside, y: goodsDetailInfoView.bottom + cmSizeFloat(15), width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
        evaluateTitleLabel.font = cmBoldSystemFontWithSize(15)
        evaluateTitleLabel.textColor = MAIN_BLACK
        evaluateTitleLabel.textAlignment = .left
        evaluateTitleLabel.text = "商品评论"
        sectionHeader.addSubview(evaluateTitleLabel)
        
        createEvaluateView()



        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: sectionHeaderEvaluateView.bottom - cmSizeFloat(1))
        sectionHeader.addSubview(seperateLine)
        
        return sectionHeader
    }
    
    
    //MARK: - 创建商品介绍View
    func createGoodsIntroduceView() {
         sectionHeaderGoodsInfoView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeaderGoodsInfoHeight))
        
        let seperateBannerLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight)
        sectionHeaderGoodsInfoView.addSubview(seperateBannerLine)
        
        let goodsNameLabel = UILabel(frame: CGRect(x: toside, y: seperateBannerLine.bottom + goodsNameLabelToTop, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
        goodsNameLabel.font = cmSystemFontWithSize(15)
        goodsNameLabel.textColor = MAIN_BLACK
        goodsNameLabel.textAlignment = .left
        goodsNameLabel.text = goodsDetailShowModel.goodsName
        sectionHeaderGoodsInfoView.addSubview(goodsNameLabel)
        
        let goodSaleInfoLabel = UILabel(frame: CGRect(x: toside, y: goodsNameLabel.bottom + lineHeight, width:wordWidth , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        goodSaleInfoLabel.font = cmSystemFontWithSize(12)
        goodSaleInfoLabel.textColor = MAIN_GRAY
        goodSaleInfoLabel.textAlignment = .left
        goodSaleInfoLabel.text =  "月售\(goodsDetailShowModel.goodsSaleCount!)份" + "    好评率%\(goodsDetailShowModel.goodsEvaluateScore!)"
        sectionHeaderGoodsInfoView.addSubview(goodSaleInfoLabel)
        
        
        
        let discountDetailStrWidth = goodsDetailShowModel.goodsDiscountInfo.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(10)), font: cmSystemFontWithSize(10))
        let discountDetailLabel = UILabel(frame: CGRect(x: toside, y: goodSaleInfoLabel.bottom + lineHeight, width:discountDetailStrWidth+cmSizeFloat(6) , height: discountDetailHeight))
        discountDetailLabel.font = cmSystemFontWithSize(10)
        discountDetailLabel.textColor = MAIN_RED
        discountDetailLabel.textAlignment = .center
        discountDetailLabel.layer.borderColor = MAIN_RED.cgColor
        discountDetailLabel.layer.borderWidth = 1
        discountDetailLabel.layer.cornerRadius = cmSizeFloat(1.5)
        discountDetailLabel.clipsToBounds = true
        discountDetailLabel.text = goodsDetailShowModel.goodsDiscountInfo
        sectionHeaderGoodsInfoView.addSubview(discountDetailLabel)
        
        
        let currencySymbolLabelWidth = "¥".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), font: cmSystemFontWithSize(12))
        let currencySymbolLabel = UILabel(frame: CGRect(x: toside, y: discountDetailLabel.bottom, width:currencySymbolLabelWidth , height: addBtnSize))
        currencySymbolLabel.font = cmSystemFontWithSize(12)
        currencySymbolLabel.textColor = MAIN_RED
        currencySymbolLabel.textAlignment = .left
        currencySymbolLabel.text = "¥"
        sectionHeaderGoodsInfoView.addSubview(currencySymbolLabel)
        
        
        var discountPriceStr = moneyExchangeToString(moneyAmount: goodsDetailShowModel.goodsDiscountPrice)
        
        //如果没有折扣，则将原价显示在折扣价位置
        if goodsDetailShowModel.hasDiscount == false {
            discountPriceStr = moneyExchangeToString(moneyAmount: goodsDetailShowModel.goodsPrice)
            discountDetailLabel.isHidden = true
        }
        
        let discountPriceWidth = discountPriceStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17)), font: cmBoldSystemFontWithSize(17))
        let discountPriceLabel = UILabel(frame: CGRect(x: currencySymbolLabel.right, y: discountDetailLabel.bottom, width:discountPriceWidth , height: addBtnSize))
        discountPriceLabel.font = cmBoldSystemFontWithSize(17)
        discountPriceLabel.textColor = MAIN_RED
        discountPriceLabel.textAlignment = .left
        discountPriceLabel.text = discountPriceStr
        sectionHeaderGoodsInfoView.addSubview(discountPriceLabel)
        
        //添加价格中划线
        let costPriceLabel = UILabel(frame: CGRect(x: discountPriceLabel.right + cmSizeFloat(7), y: discountDetailLabel.bottom, width:SCREEN_WIDTH - toside*3 - addImage.size.width*3, height: addBtnSize))
        costPriceLabel.font = cmSystemFontWithSize(12)
        costPriceLabel.textColor = MAIN_GRAY
        costPriceLabel.textAlignment = .left
        let attributes = [NSAttributedStringKey.font:cmSystemFontWithSize(12),NSAttributedStringKey.foregroundColor:MAIN_GRAY,NSAttributedStringKey.strikethroughStyle:NSNumber.init(value:1)]
        costPriceLabel.attributedText = NSAttributedString.init(string: "¥ " +  moneyExchangeToString(moneyAmount: goodsDetailShowModel.goodsPrice) , attributes: attributes)
        sectionHeaderGoodsInfoView.addSubview(costPriceLabel)
        if goodsDetailShowModel.hasDiscount == false {
            costPriceLabel.isHidden = true
        }
        
        addBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - toside - addBtnSize, y: discountDetailLabel.bottom, width: addBtnSize, height: addBtnSize))
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == false {
            addBtn.setImage(grayAddImage, for: .normal)
        }else{
            addBtn.setImage(addImage, for: .normal)
        }
        
        addBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
        //addBtn.backgroundColor = cmColorWithString(colorName: "666666")
        sectionHeaderGoodsInfoView.addSubview(addBtn)
        
        
        let selectedCountWidth = String(goodsDetailShowModel.selectedCount).stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14)) + cmSizeFloat(5)
        
        selectedCountLabel = UILabel(frame: CGRect(x: addBtn.left - selectedCountWidth, y: addBtn.top, width:selectedCountWidth , height: addBtnSize))
        selectedCountLabel.font = cmSystemFontWithSize(14)
        selectedCountLabel.textColor = MAIN_BLACK
        selectedCountLabel.textAlignment = .center
        selectedCountLabel.text = String(goodsDetailShowModel.selectedCount)
        if goodsDetailShowModel.selectedCount > 0{
            selectedCountLabel.isHidden = false
        }else{
            selectedCountLabel.isHidden = true
        }
        sectionHeaderGoodsInfoView.addSubview(selectedCountLabel)
        
        
        reduceBtn = UIButton(frame: CGRect(x: selectedCountLabel.left - addBtnSize, y: addBtn.top, width:addBtnSize , height: addBtnSize))
        reduceBtn.setImage(reduceImage, for: .normal)
        reduceBtn.addTarget(self, action: #selector(reduceBtnAct), for: .touchUpInside)
        if goodsDetailShowModel.selectedCount > 0{
            reduceBtn.isHidden = false
        }else{
            reduceBtn.isHidden = true
        }
        sectionHeaderGoodsInfoView.addSubview(reduceBtn)
        
        
        let seperateGoodsInfoLine = XYCommonViews.creatCustomSeperateLine(pointY: sectionHeaderGoodsInfoView.frame.size.height - seperateLineHeight, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight)
        sectionHeaderGoodsInfoView.addSubview(seperateGoodsInfoLine)
        
        
        
        sectionHeader.addSubview(sectionHeaderGoodsInfoView)

    }
    
    
    //MARK: - 增加按钮响应
    @objc func addBtnAct() {
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == false {
            cmShowHUDToWindow(message: "商家已暂停营业")
            return
        }
        if let lastTargetVC =  self.navigationController?.viewControllers[self.navigationController!.viewControllers.count - 2] as? SellerDetailPageVC {
            if let sellerHomeVC = lastTargetVC.pageController.currentViewController as? ShopcartVC {
               let goodsNum = self.goodsDetailShowModel.selectedCount + 1
                
                sellerHomeVC.shopcartService.shopcartAddGoodsRequest(targetVC: self, goodsSpuid: self.goodsID, addNum: goodsNum, successAct: { [weak self]  (shopcartModelArr) in
                    
                    //如果当前选择的cell已经清空
                    if goodsNum == 0 {
                        sellerHomeVC.sellerModel.goodsCellModelArr[self!.shopVCSelectedCellIndex].selectedCount = 0
                    }else{
                        //先将cell已购数量清0
                        for shopcartTempModel in shopcartModelArr {
                            for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                                if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                                    sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount = 0
                                    break
                                }
                            }
                        }
                        
                        
                        //然后累加购物车当中的所有当前商品数目之和即为所有的已购数目（含折扣与无折扣商品之和）,将购物车的数据同步到cell当中
                        for shopcartTempModel in shopcartModelArr {
                            for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                                if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                                    sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount += shopcartTempModel.selectedCount
                                    break
                                }
                            }
                        }
                    }
                    
                    
                    sellerHomeVC.sellerModel.shopcartModelArr = shopcartModelArr
                    //更新UI
                    DispatchQueue.main.async {
                        self!.goodsDetailShowModel.selectedCount += 1
                        self?.mainTabView.reloadData()
                        let indexPath = IndexPath(row: self!.shopVCSelectedCellIndex, section: 0)
                        sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                        sellerHomeVC.refreshBottomView()
                    }
                }, fialureAct: { [weak self] in
                    //更新UI
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: self!.shopVCSelectedCellIndex, section: 0)
                        sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                        sellerHomeVC.refreshBottomView()
                    }
                })
                
            }
        }

    }
    
    
    //MARK: - 减少按钮
    @objc func reduceBtnAct()
    {
        if let lastTargetVC =  self.navigationController?.viewControllers[self.navigationController!.viewControllers.count - 2] as? SellerDetailPageVC {
            if let sellerHomeVC = lastTargetVC.pageController.currentViewController as? ShopcartVC {
                
                var goodsNum = 0
                if self.goodsDetailShowModel.selectedCount > 0{
                    goodsNum = self.goodsDetailShowModel.selectedCount - 1
                }else{
                    return
                }
                
                sellerHomeVC.shopcartService.shopcartAddGoodsRequest(targetVC: self, goodsSpuid: self.goodsID, addNum: goodsNum, successAct: { [weak self]  (shopcartModelArr) in
                    
                    //如果当前选择的cell已经清空
                    if goodsNum == 0 {
                        sellerHomeVC.sellerModel.goodsCellModelArr[self!.shopVCSelectedCellIndex].selectedCount = 0
                    }else{
                        //先将cell已购数量清0
                        for shopcartTempModel in shopcartModelArr {
                            for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                                if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                                    sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount = 0
                                    break
                                }
                            }
                        }
                        
                        
                        //然后累加购物车当中的所有当前商品数目之和即为所有的已购数目（含折扣与无折扣商品之和）,将购物车的数据同步到cell当中
                        for shopcartTempModel in shopcartModelArr {
                            for goodsCellIndex in 0..<sellerHomeVC.sellerModel.goodsCellModelArr.count {
                                if shopcartTempModel.goodsID == sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].goodsID {
                                    sellerHomeVC.sellerModel.goodsCellModelArr[goodsCellIndex].selectedCount += shopcartTempModel.selectedCount
                                    break
                                }
                            }
                        }
                    }
                    
                    
                    sellerHomeVC.sellerModel.shopcartModelArr = shopcartModelArr
                    //更新UI
                    DispatchQueue.main.async {
                        self!.goodsDetailShowModel.selectedCount -= 1
                        self?.mainTabView.reloadData()
                        let indexPath = IndexPath(row: self!.shopVCSelectedCellIndex, section: 0)
                        sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                        sellerHomeVC.refreshBottomView()
                    }
                    }, fialureAct: { [weak self] in
                        //更新UI
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(row: self!.shopVCSelectedCellIndex, section: 0)
                            sellerHomeVC.goodsTableView.reloadRows(at: [indexPath], with: .none)
                            sellerHomeVC.refreshBottomView()
                        }
                })
                
            }
        }
        
        
    }
    
    
    //MARK: - 创建商品详细信息View
    func createGoodsDetailInfoView() {
        //goodsDeatail 常量
        let  goodsDetailLabelToTop = cmSizeFloat(15)
        let goodsDetailLabelHeight = goodsDetailShowModel.goodsDetailInfo.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        let goodsDetailInfoHeight = goodsDetailLabelHeight + goodsDetailLabelToTop*3 + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + seperateLineHeight
        
        
        //商品信息
         goodsDetailInfoView = UIView(frame: CGRect(x: 0, y: sectionHeaderGoodsInfoView.bottom, width: SCREEN_WIDTH, height: goodsDetailInfoHeight))
        goodsDetailInfoView.backgroundColor = .white
        
        let goodsDetailInfoTitleLabel = UILabel(frame: CGRect(x: toside, y: goodsDetailLabelToTop, width: SCREEN_WIDTH - toside*2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
        goodsDetailInfoTitleLabel.font = cmBoldSystemFontWithSize(15)
        goodsDetailInfoTitleLabel.textColor = MAIN_BLACK
        goodsDetailInfoTitleLabel.textAlignment = .left
        goodsDetailInfoTitleLabel.text = "商品描述"
        goodsDetailInfoView.addSubview(goodsDetailInfoTitleLabel)
        
        let goodsDetailInfoLabel = UILabel(frame: CGRect(x: toside, y: goodsDetailInfoTitleLabel.bottom + goodsDetailLabelToTop, width: SCREEN_WIDTH - toside*2, height: goodsDetailLabelHeight))
        goodsDetailInfoLabel.font = cmSystemFontWithSize(14)
        goodsDetailInfoLabel.textColor = MAIN_BLACK2
        goodsDetailInfoLabel.textAlignment = .left
        goodsDetailInfoLabel.numberOfLines = 0
        goodsDetailInfoLabel.text = goodsDetailShowModel.goodsDetailInfo
        goodsDetailInfoView.addSubview(goodsDetailInfoLabel)
        
        let seperateEvaluateLine = XYCommonViews.creatCustomSeperateLine(pointY: goodsDetailInfoLabel.bottom + goodsDetailLabelToTop, lineWidth: SCREEN_WIDTH, lineHeight: seperateLineHeight)
        goodsDetailInfoView.addSubview(seperateEvaluateLine)
        
        sectionHeader.addSubview(goodsDetailInfoView)

    }
    
     //MARK: - 创建商品评价View
    func createEvaluateView() {
        
        //sectionHeader 评价title
        let sectionDicArr:[Dictionary<String,Int>] = [["全部":goodsDetailShowModel.totalEvaluateCount],["满意":goodsDetailShowModel.satisfiedCount],["一般":goodsDetailShowModel.commonCount],["不满意":goodsDetailShowModel.dissatisfiedCount]]
          sectionHeaderEvaluateView = UIView(frame: CGRect(x: 0, y: evaluateTitleLabel.bottom, width: SCREEN_WIDTH, height: sectionHeaderEvaluateHeight))
        sectionHeaderEvaluateView.backgroundColor = .white
        
        
        for index in 0..<sectionDicArr.count {
            let btnWidth = SCREEN_WIDTH/CGFloat(sectionDicArr.count)
            let titleToTop = (sectionHeaderEvaluateHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) - cmSizeFloat(5))/2
            let btnView = UIView(frame: CGRect(x: CGFloat(index)*btnWidth, y: 0, width: btnWidth, height: sectionHeaderEvaluateHeight))
            let titleLabel = UILabel(frame: CGRect(x: 0, y: titleToTop, width: btnWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .center
            titleLabel.text = String(sectionDicArr[index].keys.first!)
            btnView.addSubview(titleLabel)
            
            let evaluateCountLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.bottom + cmSizeFloat(5), width: btnWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            evaluateCountLabel.font = cmSystemFontWithSize(13)
            evaluateCountLabel.textColor = MAIN_GRAY
            evaluateCountLabel.textAlignment = .center
            evaluateCountLabel.text = String(sectionDicArr[index].values.first!)
            btnView.addSubview(evaluateCountLabel)
            
            sectionHeaderEvaluateView.addSubview(btnView)
            
        }
        sectionHeader.addSubview(sectionHeaderEvaluateView)
        
    }
    
    

    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        creatTableHeaderView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT), style: .grouped)
        
        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [weak self] in
            self?.service.goodsEvaluatesPullListData(target: self!, goodsID: self!.goodsID)
        })
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(EvaluateNoAnswerTabCell.self, forCellReuseIdentifier: "EvaluateNoAnswerTabCell")
        mainTabView.register(EvaluateAnswerTabCell.self, forCellReuseIdentifier: "EvaluateAnswerTabCell")
        
        self.view.addSubview(mainTabView)
    }
    
    
    
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsDetailShowModel.goodsDetailEvaluateArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row].answerContent.isEmpty {
            let commentContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10+8*2)
            let evaluateCellHeight = goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row].evaluateContent.stringHeight(commentContentWidth, font: cmSystemFontWithSize(13)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + cmSizeFloat(20+24+10+1)
            return evaluateCellHeight
        }else{
            //评论高度
            let commentContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10*2+8)
            let commentContentHeight = goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row].evaluateContent.stringHeight(commentContentWidth, font: cmSystemFontWithSize(13))
            //回复高度
            let answerContentWidth = SCREEN_WIDTH - cmSizeFloat(35+10*2+8+4)
            let answerContentHeight = goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row].answerContent.stringHeight(answerContentWidth, font: cmSystemFontWithSize(13))
            let otherHeight = cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)) + cmSizeFloat(20+24+15+7)
            let evaluateCellHeight = answerContentHeight + otherHeight + commentContentHeight
            return evaluateCellHeight
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row].answerContent.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateNoAnswerTabCell")
            if cell == nil {
                cell = EvaluateNoAnswerTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "EvaluateNoAnswerTabCell")
            }
            if let targetCell = cell as? EvaluateNoAnswerTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row])
                
                
                return targetCell
            }else{
                return cell!
            }
        }else{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateAnswerTabCell")
            if cell == nil {
                cell = EvaluateAnswerTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "EvaluateAnswerTabCell")
            }
            if let targetCell = cell as? EvaluateAnswerTabCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: goodsDetailShowModel.goodsDetailEvaluateArr[indexPath.row])
                
                
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let  goodsDetailLabelToTop = cmSizeFloat(15)
        let goodsDetailLabelHeight = goodsDetailShowModel.goodsDetailInfo.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        
        let goodsDetailInfoHeight = goodsDetailLabelHeight + goodsDetailLabelToTop*3 + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + seperateLineHeight
        
        return sectionHeaderGoodsInfoHeight  + sectionHeaderEvaluateHeight + goodsDetailInfoHeight + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + cmSizeFloat(15)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return creatSectionHeader()
    }
    
    
    
    
    //MARK: - Scrollview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = SCREEN_WIDTH - STATUS_NAV_HEIGHT
        if scrollView == mainTabView{
            //颜色渐变
            if  scrollView.contentOffset.y <= scrollHeight{
                
                if   scrollView.contentOffset.y > 0{
                    topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: ( 0 + scrollView.contentOffset.y / scrollHeight))
                }else if scrollView.contentOffset.y <= 0{
                    topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0)
                }
            }else{
                topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 1)
            }
        }
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
