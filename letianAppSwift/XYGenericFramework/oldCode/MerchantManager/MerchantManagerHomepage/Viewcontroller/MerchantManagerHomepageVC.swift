//
//  MerchantManagerHomepageVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantManagerHomepageVC: UIViewController {

    let toside = cmSizeFloat(20)
    let btnViewHeight = cmSizeFloat(100)

    let actBtnStrArr = ["商家信息","经营设置","商品管理","营销设置","配送员管理","结算","系统设置"]
    let actBtnImageArr = [#imageLiteral(resourceName: "merchantInfo"),#imageLiteral(resourceName: "businnessSetting"),#imageLiteral(resourceName: "goodsManager"),#imageLiteral(resourceName: "sellSetting"),#imageLiteral(resourceName: "courierManager"),#imageLiteral(resourceName: "settlement"),#imageLiteral(resourceName: "systemSetting")]
    let headerBtnStrArr = ["今日订单","用户评价","损坏订单"]
    let headerBtnImageArr = [#imageLiteral(resourceName: "todayOrder"),#imageLiteral(resourceName: "userEvaluateImage"),#imageLiteral(resourceName: "dismissOrder")]
    let messageImage = #imageLiteral(resourceName: "mineMessage")
    
    var topView:XYTopView!

    var turnoverOfDayLabel:UILabel!
    var businessStateLabel:UILabel!
    var setBusinessStateBtn:UIButton!
    var businessInfoView:UIView!
    var headerBtnsView:UIView!
    var messageTipsView:UIView!

    //网络异常空白页
    public var merchantManagerAbnormalView:XYAbnormalViewManager!
    
    var service:MerchantManagerHomeService = MerchantManagerHomeService()
    var merchantManagerModel:MerchantManagerHomepageModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubviews()
        service.getMerchantManagerHomepageRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().rightImageBtnItme(target: self, action: #selector(messageAct), btnImage: messageImage))
        
        let messageTipsViewSize = cmSizeFloat(6)
        messageTipsView = UIView(frame: CGRect(x: SCREEN_WIDTH-cmSizeFloat(44)/2 + messageImage.size.width/2 - messageTipsViewSize , y: STATUSBAR_HEIGHT + cmSizeFloat(44)/2 - messageImage.size.height/2, width: messageTipsViewSize, height: messageTipsViewSize))
        messageTipsView.clipsToBounds = true
        messageTipsView.layer.cornerRadius = messageTipsViewSize/2
        messageTipsView.backgroundColor = MAIN_RED
        self.view.addSubview(messageTipsView)
        
    }

    //MARK: - 消息按钮
    @objc func messageAct() {
        
        let messasgeListVC = MerchantMessageVC()
        self.navigationController?.pushViewController(messasgeListVC, animated: true)
        
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:topView.bottom , width: SCREEN_WIDTH, height: SCREEN_HEIGHT-STATUS_NAV_HEIGHT), in: self.view)
        

            merchantManagerAbnormalView = abnormalView
            merchantManagerAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            merchantManagerAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.getMerchantManagerHomepageRequest(target: self!)

        }
    }
    
    
    //MARK: -  创建子View
    func createSubviews(){
        
        createBusinessStateSubview()
        createActBtnSubview()
    }
    
    
    //MARK: - 刷新UI
    func refreshUI(){
        turnoverOfDayLabel.text = "¥" + moneyExchangeToString(moneyAmount: merchantManagerModel.Money)
        topView.titleLabel.text = merchantManagerModel.MerchantName

        if merchantManagerModel.OpenStatus == true {
            businessStateLabel.text = "营业中"
        }else{
            businessStateLabel.text = "暂停营业"
        }
        
        if merchantManagerModel.HasNewMS == false {
            messageTipsView.isHidden = true
        }else{
             messageTipsView.isHidden = false
        }
        
    }
    
    
    //MARK: - 创建营业状态子View
    func createBusinessStateSubview(){
        
        let businessInfoViewToTopView = cmSizeFloat(20)
        let businessInfoViewTextSpace = cmSizeFloat(10)
        let businessInfoViewHeight = cmSizeFloat(20*2+10) + cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) + cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))
        
        //营业额及状态
        businessInfoView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: businessInfoViewHeight))
        
        let turnoverTitleLabel = UILabel(frame: CGRect(x: 0, y: businessInfoViewToTopView, width: SCREEN_WIDTH/2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
        turnoverTitleLabel.font = cmBoldSystemFontWithSize(15)
        turnoverTitleLabel.textColor = MAIN_BLACK
        turnoverTitleLabel.textAlignment = .center
        turnoverTitleLabel.text = "今日营业统计"
        businessInfoView.addSubview(turnoverTitleLabel)
        
        turnoverOfDayLabel = UILabel(frame: CGRect(x: 0, y: turnoverTitleLabel.bottom + businessInfoViewTextSpace, width: SCREEN_WIDTH/2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
        turnoverOfDayLabel.font = cmSystemFontWithSize(13)
        turnoverOfDayLabel.textColor = MAIN_RED
        turnoverOfDayLabel.textAlignment = .center
        businessInfoView.addSubview(turnoverOfDayLabel)
        
        
        let businessStatusTitleLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH/2, y: businessInfoViewToTopView, width: SCREEN_WIDTH/2, height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
        businessStatusTitleLabel.font = cmBoldSystemFontWithSize(15)
        businessStatusTitleLabel.textColor = MAIN_BLACK
        businessStatusTitleLabel.textAlignment = .center
        businessStatusTitleLabel.text = "营业状态"
        businessInfoView.addSubview(businessStatusTitleLabel)
        
        businessStateLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH/2, y: turnoverTitleLabel.bottom + businessInfoViewTextSpace, width: SCREEN_WIDTH/2, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
        businessStateLabel.font = cmSystemFontWithSize(13)
        businessStateLabel.textColor = MAIN_RED
        businessStateLabel.textAlignment = .center
        businessInfoView.addSubview(businessStateLabel)
        
        let seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: cmSizeFloat(10), lineWidth: CGFloat(1), lineHeight: businessInfoViewHeight - cmSizeFloat(10*2))
        seperateLine.frame.origin.x = SCREEN_WIDTH/2
        businessInfoView.addSubview(seperateLine)
        self.view.addSubview(businessInfoView)
        
        
        //设置header按钮
        let btnViewWidth = SCREEN_WIDTH/3
        let textToImage = cmSizeFloat(10)
        
        headerBtnsView = UIView(frame: CGRect(x: 0, y: businessInfoView.bottom, width: SCREEN_WIDTH, height: btnViewHeight+cmSizeFloat(7*2)))
        headerBtnsView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
        
        
        for strIndex in 0..<headerBtnStrArr.count {
            
            let imageToViewTop = (btnViewHeight - cmSizeFloat(10) - headerBtnImageArr[strIndex].size.height - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))/2
            
            
            let btnView = UIView(frame: CGRect(x: btnViewWidth*CGFloat(strIndex), y:cmSizeFloat(7), width: btnViewWidth, height: btnViewHeight))
            btnView.tag = 400+strIndex

            let btnImageView = UIImageView(frame: CGRect(x: btnViewWidth/2 - headerBtnImageArr[strIndex].size.width/2, y: imageToViewTop, width: headerBtnImageArr[strIndex].size.width, height: headerBtnImageArr[strIndex].size.height))
            btnImageView.image = headerBtnImageArr[strIndex]
            btnView.addSubview(btnImageView)
            
            let btnLabel = UILabel(frame: CGRect(x: 0, y: btnImageView.bottom + textToImage, width: btnViewWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            btnLabel.font = cmSystemFontWithSize(13)
            btnLabel.textColor = MAIN_BLACK2
            btnLabel.textAlignment = .center
            btnLabel.text = headerBtnStrArr[strIndex]
            btnView.addSubview(btnLabel)
            
            
            btnView.isUserInteractionEnabled = true
            let headerBtnViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(headerBtnViewTapgesture(sender:)))
            btnView.addGestureRecognizer(headerBtnViewTapgesture)
            headerBtnsView.addSubview(btnView)
            
        }
        
        headerBtnsView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: btnViewHeight+cmSizeFloat(7), lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
        self.view.addSubview(headerBtnsView)
        
    }
    
    
    //MARK: - 创建功能按钮view
    func createActBtnSubview(){
        
        let btnViewWidth = SCREEN_WIDTH/3
        let textToImage = cmSizeFloat(10)
        
        for index in 0..<actBtnStrArr.count {
            
            let imageWidth = actBtnImageArr[index].size.width
            let imageHeight = actBtnImageArr[index].size.height
            let imageToViewTop = (btnViewHeight - cmSizeFloat(10) - imageHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)))/2
            
            let picLineIndexNum = index/3
            let picLcolumnNum = index%3
            
            let btnView = UIView(frame: CGRect(x: btnViewWidth*CGFloat(picLcolumnNum), y:headerBtnsView.bottom +
                btnViewHeight*CGFloat(picLineIndexNum), width: btnViewWidth, height: btnViewHeight))
            btnView.tag = 300+index


            
            let btnImageView = UIImageView(frame: CGRect(x: btnViewWidth/2 - imageWidth/2, y: imageToViewTop, width: imageWidth, height: imageHeight))
            btnImageView.image = actBtnImageArr[index]
            btnView.addSubview(btnImageView)
            
            let btnLabel = UILabel(frame: CGRect(x: 0, y: btnImageView.bottom + textToImage, width: btnViewWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            btnLabel.font = cmSystemFontWithSize(13)
            btnLabel.textColor = MAIN_BLACK2
            btnLabel.textAlignment = .center
            btnLabel.text = actBtnStrArr[index]
            btnView.addSubview(btnLabel)
            
            
            btnView.isUserInteractionEnabled = true
            let btnViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(btnViewTapgestureAct(sender:)))
            btnView.addGestureRecognizer(btnViewTapgesture)
            self.view.addSubview(btnView)

            
        }
        
    }
    
    //MARK: - header按钮响应
    @objc func headerBtnViewTapgesture(sender:UITapGestureRecognizer){
        cmDebugPrint("------>")
        switch  sender.view!.tag{
        case 400:
            //今日订单
            let merchantOrderManageVC = MerchantOrderManageVC()
            self.navigationController?.pushViewController(merchantOrderManageVC, animated: true)
            break
        case 401:
            //用户评价
            let evaluateListVC = MerchantOrderEvaluateListVC()
            self.navigationController?.pushViewController(evaluateListVC, animated: true)
            break
        case 402:
            //损坏订单
            break
        default:
            break
        }
    }
    
    
    //MARK: - 功能能按钮响应
    @objc func btnViewTapgestureAct(sender:UITapGestureRecognizer){
        cmDebugPrint("------>")
        switch  sender.view!.tag{
        case 300:
            //商家信息
            break
        case 301:
            //经营设置
            let businnessSetVC = MerchantBusinnessSetVC()
            self.navigationController?.pushViewController(businnessSetVC, animated: true)
            break
        case 302:
            //商品管理
            break
        case 303:
            //营销设置
            break
        case 304:
            //配送员管理
            let staffManageVC = StaffManageListVC()
            self.navigationController?.pushViewController(staffManageVC, animated: true)
            break
        case 305:
            //结算
            let settlementVC = MerchantSettlementVC()
            self.navigationController?.pushViewController(settlementVC, animated: true)
            break
        case 306:
            //系统设置
            let systemSettionVC = MerchantSystemSettingHomeVC()
            self.navigationController?.pushViewController(systemSettionVC, animated: true)
            break
        default:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        //禁止系统手势右滑返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if topView != nil {
            service.getMerchantManagerHomepageRequest(target: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //打开系统手势右滑返回
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
