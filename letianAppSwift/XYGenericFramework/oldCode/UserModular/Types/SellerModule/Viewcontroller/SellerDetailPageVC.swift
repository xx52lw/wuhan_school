//
//  SellerDetailPageVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/25.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SellerDetailPageVC: UIViewController,UIScrollViewDelegate,horizontalScrollViewDelegate {

    static var shopVCSellerHomeCommonModel:SellerHomePageModel!
    static var commonMerchantID:String!
    let KEYBOARD_BAR_HEIGHT = CGFloat(40)
    let sellerInfoViewHeight = IS_IPHONEX ? cmSizeFloat(180) : cmSizeFloat(140)
    let segmentBtnsViewHeight = cmSizeFloat(40)
    let bottomViewHeight = TABBAR_HEIGHT
    let scrollViewHeihgt = cmSizeFloat( (IS_IPHONEX ? 180 : 140)+40)
    let discountInfoHeight = cmSizeFloat(30)
    let goodsTableHeaderHeihgt = cmSizeFloat(25)
    
    let TOP_BACKGROUND_COLOR = MAIN_BLUE_STR


    var canSroll:Bool!
    var containerScrollView:CustomScrollView!
    var sellerInfoView:UIView!
    var contentView:UIView!
    var pageController:WMPageController!
    
    //网络异常空白页
    public var sellerDetailHomepageAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var sellerDetailHomepageNoDataView:XYAbnormalViewManager!
    
    
    var topView:XYTopView!
    var merchantID:String!
    
    var service:SellerDetailHomepageService =  SellerDetailHomepageService()
    var sellerHomepageModel:SellerHomePageModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        canSroll = true
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Leave_Top"), object: nil)
        
        SellerDetailPageVC.commonMerchantID = merchantID
        service.sellerDetailHomepageDataRequest(target: self, merchantID: merchantID)
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: 0 , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT), in: self.view)
        
    if isNetError == true{
            sellerDetailHomepageAbnormalView = abnormalView
            sellerDetailHomepageAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            sellerDetailHomepageAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.sellerDetailHomepageDataRequest(target: self!, merchantID: self!.merchantID)
            }
        }
    }
    
    
    @objc func acceptMsg(notification:Notification) {
        let userInfo = notification.userInfo
        let canscroll = userInfo!["canScroll"] as! String
        if canscroll == "1" {
            self.canSroll = true
        }
    }
    
    
    func setupView(){
        
        self.view.addSubview(createContainerScrollView())
        creatNavTopView()
        self.containerScrollView.addSubview(self.creatSellerInfoView())
        self.containerScrollView.addSubview(self.creatContentView())
        createPageController()
        self.contentView.addSubview(self.pageController.view)
        pageController.viewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT)

        containerScrollView.delegate = self

    }
    
    func createContainerScrollView() -> CustomScrollView{
        
        
        if (containerScrollView  == nil) {
            containerScrollView = CustomScrollView()
            containerScrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            
            containerScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + sellerInfoViewHeight)
            containerScrollView.showsVerticalScrollIndicator = false
            if #available(iOS 11, *) {
                containerScrollView.contentInsetAdjustmentBehavior = .never
            }
        }
        return containerScrollView
        
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        
        for sublayer in topView.layer.sublayers! {
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0)
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem().rightImageBtnItme(target: self, action: #selector(shareAct), btnImage: #imageLiteral(resourceName: "sellerHomepageShare")).secondRightBtnItem(target: self, action: #selector(likeAct(sender:)), btnImage: #imageLiteral(resourceName: "sellerHomepageLike")))
        if sellerHomepageModel.merchantName != nil {
            topView.titleLabel.text = sellerHomepageModel.merchantName
            topView.titleLabel.alpha = 0
        }
        
        if sellerHomepageModel.HasSC == true {
            topView.secondRightImageBtn.setImage(#imageLiteral(resourceName: "sellerHomepageLiked"), for: .normal)
        }else{
            topView.secondRightImageBtn.setImage(#imageLiteral(resourceName: "sellerHomepageLike"), for: .normal)
        }
        
        
        if IS_IPHONEX == true {
            topView.titleLabel.frame.origin.y -= CGFloat(10)
            topView.backImageBtn.frame.origin.y -= CGFloat(10)
            topView.rightImageBtn.frame.origin.y -= CGFloat(10)
            topView.secondRightImageBtn.frame.origin.y -= CGFloat(10)
        }
        
        
    }

    
    //MARK: - 分享按钮响应
    @objc func shareAct() {

        
    }
    
    //MARK: - 收藏按钮响应
    @objc func likeAct(sender:UIButton) {
        
        if self.sellerHomepageModel.HasSC == true {
            cmShowHUDToWindow(message: "已收藏")
            return
        }
        
        service.collectMerchantRequest(merchantId: merchantID, successAct: {
            DispatchQueue.main.async {
                sender.isSelected =  !sender.isSelected
                self.sellerHomepageModel.HasSC =  !self.sellerHomepageModel.HasSC
                if self.sellerHomepageModel.HasSC == true {
                    sender.setImage(#imageLiteral(resourceName: "sellerHomepageLiked"), for: .normal)
                }else{
                    sender.setImage(#imageLiteral(resourceName: "sellerHomepageLike"), for: .normal)
                }
                cmShowHUDToWindow(message: "收藏成功")
            }
        }) {
            
        }
        
    }
    
    
    //MARK: - 创建商家信息View
    func creatSellerInfoView() -> UIView{
        let toside = cmSizeFloat(15)
        let sellerImageSize = cmSizeFloat(75)
        let wordsToImage = cmSizeFloat(10)
        let wordToTopOrBottom = cmSizeFloat(2)
        
        sellerInfoView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sellerInfoViewHeight))
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sellerInfoViewHeight))
        backImageView.image = #imageLiteral(resourceName: "sellerHomepageBackground")
        sellerInfoView.addSubview(backImageView)
        
        let sellerImageView = UIImageView(frame: CGRect(x: toside, y: NAVBAR_HEIGHT + (sellerInfoViewHeight - NAVBAR_HEIGHT - sellerImageSize)/2 , width: sellerImageSize, height: sellerImageSize))
        if let imageUrl = URL(string:sellerHomepageModel.merchantAvatarUrl){
            sellerImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
        }else{
            sellerImageView.image = #imageLiteral(resourceName: "placeHolderImage")
        }
        sellerInfoView.addSubview(sellerImageView)
        
       let isPauseLabel = UILabel(frame: CGRect(x: 0, y: sellerImageSize - sellerImageSize/5, width: sellerImageSize, height: sellerImageSize/5))
        isPauseLabel.backgroundColor = cmColorWithString(colorName: "333333", alpha: 0.7)
        isPauseLabel.font = cmSystemFontWithSize(12)
        isPauseLabel.textColor = MAIN_WHITE
        isPauseLabel.textAlignment = .center
        isPauseLabel.text = "暂停营业"
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.isOpenStatus == true {
           isPauseLabel.isHidden = true
        }
        sellerImageView.addSubview(isPauseLabel)
        
        
        let sellerNameLabel = UILabel(frame: CGRect(x: sellerImageView.right + wordsToImage, y: sellerImageView.top + wordToTopOrBottom, width: SCREEN_WIDTH - (sellerImageView.right + wordsToImage + toside), height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(17))))
        sellerNameLabel.font = cmBoldSystemFontWithSize(17)
        sellerNameLabel.textColor = MAIN_WHITE
        sellerNameLabel.text = sellerHomepageModel.merchantName
        sellerInfoView.addSubview(sellerNameLabel)
        
        
        let noticeInfoLabel = UILabel(frame: CGRect(x: sellerImageView.right + wordsToImage, y: sellerImageView.bottom - wordToTopOrBottom - cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), width: SCREEN_WIDTH - (sellerImageView.right + wordsToImage + toside), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        noticeInfoLabel.font = cmSystemFontWithSize(12)
        noticeInfoLabel.textColor = MAIN_WHITE
        noticeInfoLabel.text = "公告: " + sellerHomepageModel.sellerNotice
        sellerInfoView.addSubview(noticeInfoLabel)
        
        
        let deliveryInfoLabel = UILabel(frame: CGRect(x: sellerImageView.right + wordsToImage, y: noticeInfoLabel.top - cmSizeFloat(5) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), width: SCREEN_WIDTH - (sellerImageView.right + wordsToImage + toside), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        deliveryInfoLabel.font = cmSystemFontWithSize(12)
        deliveryInfoLabel.textColor = MAIN_WHITE
        
        var deliveryInfoStr = "配送费: ¥" + moneyExchangeToStringTwo(moneyAmount: sellerHomepageModel.deliveryFee)
        if sellerHomepageModel.EnoughFreeDelivery == true {
            deliveryInfoStr += "  满¥" + moneyExchangeToStringTwo(moneyAmount: sellerHomepageModel.EFDeliveryAmount) + "免配送费"
        }
        deliveryInfoLabel.text =  deliveryInfoStr
        sellerInfoView.addSubview(deliveryInfoLabel)
        
        
        return sellerInfoView
        
        
    }
    
    
    func creatContentView() -> UIView {
        
        if (contentView == nil) {
            contentView = UIView(frame:CGRect(x: 0, y: sellerInfoView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT))
            contentView.backgroundColor = .yellow
        }
        return contentView
    }
    
    func  createPageController() {
        let segmentBtnStrArr = ["商品","评价","活动","详情"]
        if (pageController == nil) {
            pageController = WMPageController(viewControllerClasses: [ShopcartVC.self,EvaluateVC.self,GoodsPromotionTableViewController.self,SellerDetailViewController.self], andTheirTitles: segmentBtnStrArr)
            pageController.menuViewStyle      = .default
            pageController.menuHeight         = segmentBtnsViewHeight
            
            pageController.menuBGColor = .white
            pageController.titleSizeNormal    = 15
            pageController.titleSizeSelected  = 15
            pageController.titleColorNormal   = MAIN_GRAY
            pageController.titleColorSelected = MAIN_BLUE
            pageController.horizontalScrollDelegate = self
            


            
        }
    }
    
    //MARK: - 横向翻页scrollview代理
    //当开始横向滑动时，禁止竖直方向滑动
    func unableContainerScroll() {
        self.containerScrollView.isScrollEnabled = false
    }
    
    func enableContainerScroll() {
        self.containerScrollView.isScrollEnabled = true
    }
    
    //MARK: - scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffSetY = sellerInfoViewHeight-topView.size.height
        let offsetY = scrollView.contentOffset.y
        topView.backgroundColor =  cmColorWithString(colorName: TOP_BACKGROUND_COLOR, alpha: ( 0 + offsetY / maxOffSetY))
        topView.titleLabel.alpha = offsetY / maxOffSetY
        
        

        //如果当前VC是shopcartVC则动态调整bottomView的位置
        if let currentSubVC = self.pageController.currentViewController as? ShopcartVC {
            if scrollView == self.containerScrollView{

                    currentSubVC.discountInfoLabel.frame.origin.y = SCREEN_HEIGHT-scrollViewHeihgt - bottomViewHeight-discountInfoHeight + offsetY
                    currentSubVC.bottomView.frame.origin.y = currentSubVC.discountInfoLabel.bottom

                
            }
        }

        
        if offsetY >= maxOffSetY {
            scrollView.contentOffset = CGPoint.init(x: 0, y: maxOffSetY)
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Home_Go_Top") , object: nil, userInfo: ["canScroll":"1"])
            canSroll = false
        }else{
            if canSroll == false {
                scrollView.contentOffset = CGPoint(x: 0, y: maxOffSetY)
            }
            
        }
    }
    
    
    /*
    //MARK: - 创建键盘View
    func creatKeyboardView(){
        //键盘悬浮
        keyBoradView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: KEYBOARD_BAR_HEIGHT))
        keyBoradView.backgroundColor = MAIN_WHITE
        
        let keyBoradViewTopLine = UILabel(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(1)))
        keyBoradViewTopLine.backgroundColor = seperateLineColor
        
        let keyBoradViewBottomLine = UILabel(frame:CGRect(x: 0, y: KEYBOARD_BAR_HEIGHT - CGFloat(1), width: SCREEN_WIDTH, height: CGFloat(1)))
        keyBoradViewBottomLine.backgroundColor = seperateLineColor
        keyBoradView.addSubview(keyBoradViewTopLine)
        keyBoradView.addSubview(keyBoradViewBottomLine)
        
        
        let finishEditBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - 70 , y: 0, width: 70, height: KEYBOARD_BAR_HEIGHT))
        finishEditBtn.addTarget(self, action: #selector(finishEditBtnAct), for: .touchUpInside)
        let btnLab = UILabel(frame: CGRect(x: 10 , y: KEYBOARD_BAR_HEIGHT/2 - 12, width: 50, height: 24))
        btnLab.text = "完成"
        btnLab.textAlignment = .center
        btnLab.textColor = MAIN_BLUE
        btnLab.layer.borderColor = MAIN_BLUE.cgColor
        btnLab.layer.borderWidth = CGFloat(1)
        btnLab.layer.cornerRadius = 2
        finishEditBtn.addSubview(btnLab)
        keyBoradView.addSubview(finishEditBtn)
        
        UIApplication.shared.keyWindow?.addSubview(keyBoradView)
        //self.view.addSubview(keyBoradView)
    }

    //MARK: - 回收键盘
    @objc func finishEditBtnAct(){
        self.view.endEditing(true)
    }
    
    
    //MARK:键盘悬浮处理
    func keyBoardChange(notification :NSNotification){
        
    }
    
    
    func keyBoardWillShow(notification :NSNotification){
        
        // print("键盘将要显示")
        let dict:NSDictionary = notification.userInfo! as NSDictionary
        let aValue = dict.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRect = (aValue! as AnyObject).cgRectValue
        let keyHeight =  keyboardRect?.size.height
        self.keyBoradView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-self.KEYBOARD_BAR_HEIGHT-keyHeight!, width: SCREEN_WIDTH, height: self.KEYBOARD_BAR_HEIGHT)
        
        //self.mainTabView.frame.size.height = SCREEN_HEIGHT - self.KEYBOARD_BAR_HEIGHT-keyHeight! - XY_TOPVIEW_HEIGHT
    }
    
    func keyBoardWillHide(notification :NSNotification){
        keyBoradView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: KEYBOARD_BAR_HEIGHT)
        //self.mainTabView.frame.size.height = SCREEN_HEIGHT - XY_TAB_BAR_HEIGHT - XY_TOPVIEW_HEIGHT
    }
    
    */
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = .default
        tabBarController?.tabBar.isHidden = true
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardChange(notification:)), name:NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        //  NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyBoardDidHide(_:)), name:UIKeyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self)
        
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
