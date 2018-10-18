//
//  SellerDetailViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SellerDetailViewController: UIViewController,UIScrollViewDelegate {

    let segmentBtnsViewHeight = cmSizeFloat(40)
    let toside = cmSizeFloat(20)
    let seperateHeight = cmSizeFloat(7)
    let sellerInfoBtnHeight = cmSizeFloat(50)

    
    let sellerAdressImage = #imageLiteral(resourceName: "sellerDetailAdress")
    let sellerTelImage = #imageLiteral(resourceName: "sellerDetailTel")
    let sellerDeliveryTypeImage = #imageLiteral(resourceName: "sellerDetailDeliveryType")
    let sellerTimeImage = #imageLiteral(resourceName: "sellerDetailDeliveryTime")
    let sellerShowMore = #imageLiteral(resourceName: "sellerDetailShowMore")

    
    var mainScrollView:UIScrollView!
    var sellerTipsView:UIView!
    var sellerInfoView:UIView!
    var phonePopView:XYCallPhonePopView!
    
    //商家资质等其他信息
    var sellerOtherInfoView:UIView!
    //网络异常空白页
    public var sellerInfoAbnormalView:XYAbnormalViewManager!
    var canScroll:Bool = false
    var service:SellerDetailService = SellerDetailService()
    
    var detailModel:SellerDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.sellerDetailInfoDataRequest(target: self, merchantID: SellerDetailPageVC.commonMerchantID)
        
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Go_Top"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(acceptMsg(notification:)), name: NSNotification.Name(rawValue: "Home_Leave_Top"), object: nil)
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建子view
    func createSubViews() {
        createMainScrollView()
        creatSellerTipsView()
        createSellerInfoView()
        createSellerOtherInfo()
        if sellerOtherInfoView.bottom > SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight{
            mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: sellerOtherInfoView.bottom)
        }else {
            mainScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: (SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight)*1.2)
        }
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y: 0 , width: SCREEN_WIDTH, height:  SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight), in: self.view)
        
        if isNetError == true{
            sellerInfoAbnormalView = abnormalView
            sellerInfoAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            sellerInfoAbnormalView.refreshActionBlock = {[weak self] in
               self?.service.sellerDetailInfoDataRequest(target: self!, merchantID: SellerDetailPageVC.commonMerchantID)
            }
        }
    }
    
    //MARK: - 监听通知
    @objc  func acceptMsg(notification:Notification) {
        let notificationName = notification.name
        if notificationName.rawValue == "Home_Go_Top"  {
            let userInfo = notification.userInfo
            let canscroll = userInfo!["canScroll"] as! String
            if canscroll == "1" {
                self.canScroll = true
                
            }
        }else if notificationName.rawValue == "Home_Leave_Top"  {
            if mainScrollView != nil {
            self.mainScrollView.contentOffset = CGPoint.zero
        }
            self.canScroll = false;
        }
    }
    
    
    //MARK: - 创建mainscrollview
    func createMainScrollView(){
        mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - STATUS_NAV_HEIGHT - segmentBtnsViewHeight))
        
        mainScrollView.isPagingEnabled = false
        mainScrollView.backgroundColor = cmColorWithString(colorName: "ffffff")
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        self.view.addSubview(mainScrollView)
    }
    
    //MARK: - 创建商家公告
    func creatSellerTipsView(){
        
        let tipsTitleToseprateHeight = cmSizeFloat(15)
        let tipsDetailToTitleHeight = cmSizeFloat(8)
        
        var sellerTipsStr = SellerDetailPageVC.shopVCSellerHomeCommonModel.sellerNotice!
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.sellerNotice.isEmpty {
            sellerTipsStr = "无"
        }
        let sellerTipsHeight = sellerTipsStr.stringHeight(SCREEN_WIDTH - toside*2, font: cmSystemFontWithSize(14))
        let titleHeight = cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))

        
        sellerTipsView = UIView(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH , height: sellerTipsHeight + tipsTitleToseprateHeight*2 + tipsDetailToTitleHeight + seperateHeight + titleHeight))
        sellerTipsView.backgroundColor = .white
        mainScrollView.addSubview(sellerTipsView)
        
        let sperateLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerTipsView.addSubview(sperateLine)
        
        let titleLabel =  UILabel(frame: CGRect(x: toside, y: sperateLine.bottom + tipsTitleToseprateHeight, width: SCREEN_WIDTH - toside*2 , height: titleHeight))
        titleLabel.font = cmBoldSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "商家公告"
        sellerTipsView.addSubview(titleLabel)
        
        let tipsDetailLabel =  UILabel(frame: CGRect(x: toside, y: titleLabel.bottom + tipsDetailToTitleHeight, width: SCREEN_WIDTH - toside*2 , height: sellerTipsHeight))
        tipsDetailLabel.font = cmBoldSystemFontWithSize(14)
        tipsDetailLabel.textColor = MAIN_BLACK2
        tipsDetailLabel.textAlignment = .left
        tipsDetailLabel.text = sellerTipsStr
        tipsDetailLabel.numberOfLines = 0
        sellerTipsView.addSubview(tipsDetailLabel)
        
    }
    
    //MARK: - 创建商家经营信息
    func createSellerInfoView(){
        
        let textToImageWidth = cmSizeFloat(10)
        
        
        sellerInfoView = UIView(frame: CGRect(x: 0, y: sellerTipsView.bottom, width:SCREEN_WIDTH , height: sellerInfoBtnHeight*4 + seperateHeight*3))
        sellerInfoView.backgroundColor = .white
        mainScrollView.addSubview(sellerInfoView)
        
        let sperateLine = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerInfoView.addSubview(sperateLine)
        //商家电话
        let sellerTelBtn = UIButton(frame: CGRect(x: 0, y: sperateLine.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        sellerTelBtn.addTarget(self, action: #selector(sellerTelBtnAct), for: .touchUpInside)
        let sellerTelImageView  = UIImageView(frame: CGRect(x: toside, y: sellerInfoBtnHeight/2 - sellerTelImage.size.height/2, width: sellerTelImage.size.width, height: sellerTelImage.size.height))
        sellerTelImageView.image = sellerTelImage
        sellerTelBtn.addSubview(sellerTelImageView)
        
        let sellerTelLabel = UILabel(frame: CGRect(x: sellerTelImageView.right + textToImageWidth, y: 0, width: SCREEN_WIDTH - toside*2 - sellerTelImage.size.width - textToImageWidth*2 - sellerShowMore.size.width, height: sellerInfoBtnHeight))
        sellerTelLabel.font = cmSystemFontWithSize(14)
        sellerTelLabel.textColor = MAIN_BLACK2
        sellerTelLabel.textAlignment = .left
        sellerTelLabel.text = detailModel.sellerTel
        sellerTelBtn.addSubview(sellerTelLabel)
        
        let sellerShowMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - toside - sellerShowMore.size.width, y: sellerInfoBtnHeight/2 - sellerShowMore.size.height/2, width: sellerShowMore.size.width, height: sellerShowMore.size.height))
        sellerShowMoreImageView.image = sellerShowMore
        sellerTelBtn.addSubview(sellerShowMoreImageView)
        
        let sellerTelSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: sellerInfoBtnHeight - cmSizeFloat(1))
        sellerTelSeperateLine.frame.origin.x = toside
        sellerTelSeperateLine.frame.size.width = SCREEN_WIDTH - toside
        sellerTelBtn.addSubview(sellerTelSeperateLine)
        sellerInfoView.addSubview(sellerTelBtn)
        
        //商家地址
        let sellerAdressBtn = UIButton(frame: CGRect(x: 0, y: sellerTelBtn.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        sellerAdressBtn.addTarget(self, action: #selector(sellerAdressBtnAct), for: .touchUpInside)
        let sellerAdressImageView  = UIImageView(frame: CGRect(x: toside, y: sellerInfoBtnHeight/2 - sellerAdressImage.size.height/2, width: sellerAdressImage.size.width, height: sellerAdressImage.size.height))
        sellerAdressImageView.image = sellerAdressImage
        sellerAdressBtn.addSubview(sellerAdressImageView)
        
        let sellerAdressLabel = UILabel(frame: CGRect(x: sellerAdressImageView.right + textToImageWidth, y: 0, width: SCREEN_WIDTH - toside*2 - sellerAdressImage.size.width - textToImageWidth*2 - sellerShowMore.size.width, height: sellerInfoBtnHeight))
        sellerAdressLabel.font = cmSystemFontWithSize(14)
        sellerAdressLabel.textColor = MAIN_BLACK2
        sellerAdressLabel.textAlignment = .left
        sellerAdressLabel.text = detailModel.sellerAdress
        sellerAdressBtn.addSubview(sellerAdressLabel)
        
        let sellerAdressShowMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - toside - sellerShowMore.size.width, y: sellerInfoBtnHeight/2 - sellerShowMore.size.height/2, width: sellerShowMore.size.width, height: sellerShowMore.size.height))
        sellerAdressShowMoreImageView.image = sellerShowMore
        sellerAdressBtn.addSubview(sellerAdressShowMoreImageView)
        sellerInfoView.addSubview(sellerAdressBtn)
        
        let sellerAdressSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sellerAdressBtn.bottom, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerInfoView.addSubview(sellerAdressSeperateLine)
        
        //配送时间
        let sellerTimeBtn = UIButton(frame: CGRect(x: 0, y: sellerAdressSeperateLine.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        let sellerTimeImageView  = UIImageView(frame: CGRect(x: toside, y: sellerInfoBtnHeight/2 - sellerTimeImage.size.height/2, width: sellerTimeImage.size.width, height: sellerTimeImage.size.height))
        sellerTimeImageView.image = sellerTimeImage
        sellerTimeBtn.addSubview(sellerTimeImageView)
        
        
       var sellTimeInfo = String(SellerDetailPageVC.shopVCSellerHomeCommonModel.openOneStart) + ":00" + " - " + String(SellerDetailPageVC.shopVCSellerHomeCommonModel.openOneEnd) + ":00"
        if SellerDetailPageVC.shopVCSellerHomeCommonModel.hasOpenTwo == true {
            sellTimeInfo = sellTimeInfo + "、" + String(SellerDetailPageVC.shopVCSellerHomeCommonModel.openTwoStart) + ":00" + " - " + String(SellerDetailPageVC.shopVCSellerHomeCommonModel.openTwoEnd) + ":00"
        }

        
        let sellerTimeLabel = UILabel(frame: CGRect(x: sellerTimeImageView.right + textToImageWidth, y: 0, width: SCREEN_WIDTH - toside*2 - sellerTimeImage.size.width, height: sellerInfoBtnHeight))
        sellerTimeLabel.font = cmSystemFontWithSize(14)
        sellerTimeLabel.textColor = MAIN_BLACK2
        sellerTimeLabel.textAlignment = .left
        sellerTimeLabel.text = "配送时间: " + sellTimeInfo
        sellerTimeBtn.addSubview(sellerTimeLabel)

        let sellerTimeSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: sellerInfoBtnHeight - cmSizeFloat(1))
        sellerTimeSeperateLine.frame.origin.x = toside
        sellerTimeSeperateLine.frame.size.width = SCREEN_WIDTH - toside
        sellerTimeBtn.addSubview(sellerTimeSeperateLine)
        sellerInfoView.addSubview(sellerTimeBtn)
        
        //配送方式
        let sellerDeliveryTypeBtn = UIButton(frame: CGRect(x: 0, y: sellerTimeBtn.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        let sellerDeliveryTypeImageView  = UIImageView(frame: CGRect(x: toside, y: sellerInfoBtnHeight/2 - sellerDeliveryTypeImage.size.height/2, width: sellerDeliveryTypeImage.size.width, height: sellerDeliveryTypeImage.size.height))
        sellerDeliveryTypeImageView.image = sellerDeliveryTypeImage
        sellerDeliveryTypeBtn.addSubview(sellerDeliveryTypeImageView)
        
        let sellerDeliveryTypeLabel = UILabel(frame: CGRect(x: sellerDeliveryTypeImageView.right + textToImageWidth, y: 0, width: SCREEN_WIDTH - toside*2 - sellerDeliveryTypeImage.size.width, height: sellerInfoBtnHeight))
        sellerDeliveryTypeLabel.font = cmSystemFontWithSize(14)
        sellerDeliveryTypeLabel.textColor = MAIN_BLACK2
        sellerDeliveryTypeLabel.textAlignment = .left
        sellerDeliveryTypeLabel.text = "配送服务: " + detailModel.sellerDeliveryType
        sellerDeliveryTypeBtn.addSubview(sellerDeliveryTypeLabel)
        
        let sellerDeliveryTypeSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sellerDeliveryTypeBtn.bottom, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerInfoView.addSubview(sellerDeliveryTypeSeperateLine)
        
        sellerInfoView.addSubview(sellerDeliveryTypeBtn)
    }
    
    //MARK: - 电话展示更多按钮响应
    @objc func sellerTelBtnAct() {
        var callNumArr:[String] = Array()
        if !self.detailModel.telOne.isEmpty {
            callNumArr.append(self.detailModel.telOne)
        }
        if !self.detailModel.telTwo.isEmpty {
            callNumArr.append(self.detailModel.telTwo)
        }
        if callNumArr.count == 0 {
            cmShowHUDToWindow(message: "暂无商家联系方式")
            return
        }else if callNumArr.count == 1 {
            cmMakePhoneCall(phoneStr: callNumArr.first!)
        }else{
            phonePopView = XYCallPhonePopView(frame: .zero, phoneNumArr: callNumArr)
            phonePopView.showInView(view: GetCurrentViewController()!.view)
        }
    }
    //MARK: - 地址按钮响应
    @objc func sellerAdressBtnAct() {
        let sellerAdressMapVC = SellerAdressMapVC()
        sellerAdressMapVC.sellerAdressGeoHashStr = detailModel.AddressGeohash
        GetCurrentViewController()?.navigationController?.pushViewController(sellerAdressMapVC, animated: true)
    }
    
    //MARK: - 创建商家相关的其他信息
    func createSellerOtherInfo() {
        
        sellerOtherInfoView = UIView(frame: CGRect(x: 0, y: sellerInfoView.bottom, width:SCREEN_WIDTH , height: sellerInfoBtnHeight*3 + seperateHeight*2))
        sellerOtherInfoView.backgroundColor = .white
        mainScrollView.addSubview(sellerOtherInfoView)
        //商家资质
        let sellerQualificationsBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        sellerQualificationsBtn.addTarget(self, action: #selector(sellerQualificationsBtnAct), for: .touchUpInside)
        
        let sellerQualificationsLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2 - sellerShowMore.size.width, height: sellerInfoBtnHeight))
        sellerQualificationsLabel.font = cmSystemFontWithSize(14)
        sellerQualificationsLabel.textColor = MAIN_BLACK2
        sellerQualificationsLabel.textAlignment = .left
        sellerQualificationsLabel.text = "商家资质"
        sellerQualificationsBtn.addSubview(sellerQualificationsLabel)
        
        let sellerQualificationsShowMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - toside - sellerShowMore.size.width, y: sellerInfoBtnHeight/2 - sellerShowMore.size.height/2, width: sellerShowMore.size.width, height: sellerShowMore.size.height))
        sellerQualificationsShowMoreImageView.image = sellerShowMore
        sellerQualificationsBtn.addSubview(sellerQualificationsShowMoreImageView)
        
        let sellerQualificationsSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: sellerInfoBtnHeight - cmSizeFloat(1))
        sellerQualificationsSeperateLine.frame.origin.x = toside
        sellerQualificationsSeperateLine.frame.size.width = SCREEN_WIDTH - toside
        sellerQualificationsBtn.addSubview(sellerQualificationsSeperateLine)
        sellerOtherInfoView.addSubview(sellerQualificationsBtn)
        
        //商家环境
        let sellerEnvironmentBtn = UIButton(frame: CGRect(x: 0, y: sellerQualificationsBtn.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        sellerEnvironmentBtn.addTarget(self, action: #selector(sellerEnvironmentBtnAct), for: .touchUpInside)
        
        let sellerEnvironmentLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2 - sellerShowMore.size.width, height: sellerInfoBtnHeight))
        sellerEnvironmentLabel.font = cmSystemFontWithSize(14)
        sellerEnvironmentLabel.textColor = MAIN_BLACK2
        sellerEnvironmentLabel.textAlignment = .left
        sellerEnvironmentLabel.text = "商家环境"
        sellerEnvironmentBtn.addSubview(sellerEnvironmentLabel)
        
        let sellerEnvironmentShowMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - toside - sellerShowMore.size.width, y: sellerInfoBtnHeight/2 - sellerShowMore.size.height/2, width: sellerShowMore.size.width, height: sellerShowMore.size.height))
        sellerEnvironmentShowMoreImageView.image = sellerShowMore
        sellerEnvironmentBtn.addSubview(sellerEnvironmentShowMoreImageView)
        
        sellerOtherInfoView.addSubview(sellerEnvironmentBtn)
        
        let sellerEnvironmentSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sellerEnvironmentBtn.bottom, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerOtherInfoView.addSubview(sellerEnvironmentSeperateLine)
        
        
        //举报商家
        let sellerReportBtn = UIButton(frame: CGRect(x: 0, y: sellerEnvironmentBtn.bottom, width: SCREEN_WIDTH, height: sellerInfoBtnHeight))
        sellerReportBtn.addTarget(self, action: #selector(sellerReportBtnAct), for: .touchUpInside)
        
        let sellerReportLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2 - sellerShowMore.size.width, height: sellerInfoBtnHeight))
        sellerReportLabel.font = cmSystemFontWithSize(14)
        sellerReportLabel.textColor = MAIN_BLACK2
        sellerReportLabel.textAlignment = .left
        sellerReportLabel.text = "举报商家"
        sellerReportBtn.addSubview(sellerReportLabel)
        
        let sellerReportShowMoreImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - toside - sellerShowMore.size.width, y: sellerInfoBtnHeight/2 - sellerShowMore.size.height/2, width: sellerShowMore.size.width, height: sellerShowMore.size.height))
        sellerReportShowMoreImageView.image = sellerShowMore
        sellerReportBtn.addSubview(sellerReportShowMoreImageView)
        
        sellerOtherInfoView.addSubview(sellerReportBtn)
        
        let sellerReportSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sellerReportBtn.bottom, lineWidth:SCREEN_WIDTH , lineHeight: seperateHeight)
        sellerOtherInfoView.addSubview(sellerReportSeperateLine)
        
    }
    
    //MARK: - 查看商家资质
    @objc func sellerQualificationsBtnAct(){
        let qulificationVC = SellerQualificationsVC()
        qulificationVC.imageUrlArr = detailModel.qualificationImageUrlArr
        GetCurrentViewController()?.navigationController?.pushViewController(qulificationVC, animated: true)
    }

    //MARK: - 商家环境
    @objc func sellerEnvironmentBtnAct() {
       let sellerEnvVC = SellerEnvironmentVC()
        sellerEnvVC.imageUrlArr = detailModel.environmentImageUrlArr
        GetCurrentViewController()?.navigationController?.pushViewController(sellerEnvVC, animated: true)
    }
    //MARK: - 举报商家
    @objc func sellerReportBtnAct(){
        let complaintVC = ComplainSellerVC()
        complaintVC.merchantID =  SellerDetailPageVC.commonMerchantID
        GetCurrentViewController()?.navigationController?.pushViewController(complaintVC, animated: true)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
