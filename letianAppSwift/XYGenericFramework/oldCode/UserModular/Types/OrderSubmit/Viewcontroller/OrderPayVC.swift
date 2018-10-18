//
//  OrderPayVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderPayVC: UIViewController {

    let seletcedImage = #imageLiteral(resourceName: "adressSelected")
    let unselectedImage = #imageLiteral(resourceName: "adressUnselected")
    
    let payImageArr = [#imageLiteral(resourceName: "alipayImage"),#imageLiteral(resourceName: "weixinPayImage")]
    let titleStrArr = ["支付宝支付","微信支付"]
    let payIntroduceStrArr = ["推荐有支付宝账号的用户使用","推荐按照微信5.0以上版本的用户使用"]
    
    var selectedImageviewsArr:[UIImageView] = Array()
    
    var topView:XYTopView!
    var leftPayTimeLabel:UILabel!
    var popView:XYNoDetailTipsAlertView!
    
    //倒计时Timer
    var limitTimer:Timer!
    var leftTime:Int = 0
    
    var orderPayModel:OrderSubmitResultModel!
    var selectedPayWayTag:Int = -1
    var service:OrderPayService = OrderPayService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubviews()
        createLimitTimer()
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建倒计时
    func createLimitTimer(){
        leftTime = orderPayModel.effectTime
        limitTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    //MARK: - 倒计时响应
    @objc func timerAction() {
        if self.leftTime <= 0 {
            self.limitTimer.invalidate()
            self.limitTimer = nil
            return
        }
        self.leftTime -= 1
        
        leftPayTimeLabel.text = timeTransform(self.leftTime)
    }
    
    
    func timeTransform(_ timeSeconds:Int) ->String {
        
        var minStr:String =  String(Int(timeSeconds * 100) / 60 / 100)
        if timeSeconds/60 < 10 {
            minStr = "0" + minStr
        }
        var secondStr:String = String(Int(timeSeconds * 100)%6000/100)
        if timeSeconds%60 < 10 {
            secondStr = "0" +  secondStr
        }
        
        return minStr + ":" + secondStr
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: #selector(backBtnAction)).navigationTitleItem())
        topView.titleLabel.text = "订单支付"
    }
    
    @objc func backBtnAction() {
        
        popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "您确定要取消支付吗？", cancelStr: "不取消", certainStr:"确定" , cancelBtnClosure: {
            
        }, certainClosure: { [weak self] in
            
            if self?.limitTimer != nil {
                self?.limitTimer.invalidate()
                self?.limitTimer = nil
            }
            
            DispatchQueue.main.async {
                let navVCCount = self!.navigationController!.viewControllers.count
                if  self?.navigationController?.viewControllers[navVCCount - 2] is OrderSubmitViewController {
                    self?.navigationController?.popToRootViewController(animated: true)
                }else{
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        })
        popView.clickControlHideView = false
        popView.showInView(view: self.view)


    }
    
    func createSubviews() {
       let merchantNameStrWidth = orderPayModel.merchantName.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
       let payAmountStr = "¥"  + moneyExchangeToString(moneyAmount: orderPayModel.totalPayMoney)
       let payAmountStrWidth = payAmountStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
       let merchantLabelToleft = (SCREEN_WIDTH-merchantNameStrWidth-payAmountStrWidth-cmSizeFloat(9))/2
        
        
       let merchantNameLabel = UILabel(frame: CGRect(x: merchantLabelToleft, y: topView.bottom, width: merchantNameStrWidth, height: cmSizeFloat(50)))
        merchantNameLabel.font = cmSystemFontWithSize(15)
        merchantNameLabel.textColor = MAIN_BLACK
        merchantNameLabel.textAlignment = .center
        merchantNameLabel.text = orderPayModel.merchantName
        self.view.addSubview(merchantNameLabel)
        
        let payAmountLabel = UILabel(frame: CGRect(x: merchantNameLabel.right + cmSizeFloat(9), y: topView.bottom, width: payAmountStrWidth, height: cmSizeFloat(50)))
        payAmountLabel.font = cmSystemFontWithSize(15)
        payAmountLabel.textColor = MAIN_RED
        payAmountLabel.textAlignment = .center
        payAmountLabel.text = "¥"  +  moneyExchangeToString(moneyAmount: orderPayModel.totalPayMoney)
        self.view.addSubview(payAmountLabel)
        
       let seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: merchantNameLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        self.view.addSubview(seperateLine)
        
        
       let payInfoViewHeight = cmSizeFloat(75)
       let spaceHeight = cmSizeFloat(10)
       let payLimitTimeToSeperateHeight = (payInfoViewHeight - spaceHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(16)))/2
       
        let leftTimeTitleLabel = UILabel(frame: CGRect(x: 0, y: seperateLine.bottom + payLimitTimeToSeperateHeight, width: SCREEN_WIDTH, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
        leftTimeTitleLabel.font = cmSystemFontWithSize(15)
        leftTimeTitleLabel.textColor = MAIN_BLACK
        leftTimeTitleLabel.textAlignment = .center
        leftTimeTitleLabel.text = "支付剩余时间"
        self.view.addSubview(leftTimeTitleLabel)
        
        
        leftPayTimeLabel = UILabel(frame: CGRect(x: 0, y: leftTimeTitleLabel.bottom + spaceHeight, width: SCREEN_WIDTH, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(16))))
        leftPayTimeLabel.font = cmSystemFontWithSize(16)
        leftPayTimeLabel.textColor = MAIN_RED
        leftPayTimeLabel.text = timeTransform(self.orderPayModel.effectTime)
        leftPayTimeLabel.textAlignment = .center
        self.view.addSubview(leftPayTimeLabel)
        
        let leftTimeSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: leftPayTimeLabel.bottom + payLimitTimeToSeperateHeight , lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        self.view.addSubview(leftTimeSeperateLine)
        
        //支付
        let toside = cmSizeFloat(20)
        let textToimageWidth  = cmSizeFloat(15)
        let payViewHeight = cmSizeFloat(70)
        let payIntroduceToTitle = cmSizeFloat(7)
        let textToTopHeight = (payViewHeight - cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) - payIntroduceToTitle)/2
        
        
        for index in 0..<payImageArr.count {
            
            let payView = UIView(frame: CGRect(x: 0, y: leftTimeSeperateLine.bottom + payViewHeight*CGFloat(index), width: SCREEN_WIDTH, height: payViewHeight))
            self.view.addSubview(payView)
            
            let payIconImageView = UIImageView(frame: CGRect(x: toside, y: payViewHeight/2 - payImageArr[index].size.height/2, width: payImageArr[index].size.width, height: payImageArr[index].size.height))
            payIconImageView.image = payImageArr[index]
            payView.addSubview(payIconImageView)
            
            let selectedImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - seletcedImage.size.width - toside*2, y: 0, width: unselectedImage.size.width, height: unselectedImage.size.width + toside*2))
            selectedImageView.image = unselectedImage
            selectedImageView.contentMode = .scaleAspectFit
            selectedImageView.isUserInteractionEnabled = true
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(selectedPayAction(tap:)))
            selectedImageView.addGestureRecognizer(imageTap)
            selectedImageView.tag = 200 + index
            selectedImageviewsArr.append(selectedImageView)
            payView.addSubview(selectedImageView)
            
            let payTitleLabel = UILabel(frame: CGRect(x: textToimageWidth+payIconImageView.right, y: textToTopHeight, width: SCREEN_WIDTH - payIconImageView.right - textToimageWidth - selectedImageView.frame.size.width , height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(15))))
            payTitleLabel.font = cmBoldSystemFontWithSize(15)
            payTitleLabel.textColor = MAIN_BLACK
            payTitleLabel.textAlignment = .left
            payTitleLabel.text = titleStrArr[index]
            payView.addSubview(payTitleLabel)
            
            let payIntroduceLabel = UILabel(frame: CGRect(x: payTitleLabel.frame.origin.x, y: payTitleLabel.bottom + payIntroduceToTitle, width: payTitleLabel.frame.size.width , height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            payIntroduceLabel.font = cmSystemFontWithSize(13)
            payIntroduceLabel.textColor = MAIN_GRAY
            payIntroduceLabel.textAlignment = .left
            payIntroduceLabel.text = payIntroduceStrArr[index]
            payView.addSubview(payIntroduceLabel)
            
            
            if index != payImageArr.count - 1 {
                payView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: payView.frame.size.height - CGFloat(1)))
            }
            
            
            if index == payImageArr.count - 1 {
                
                let submitPayBtn = UIButton(frame: CGRect(x: toside, y: payView.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
                submitPayBtn.setTitle("确定支付", for: .normal)
                submitPayBtn.setTitleColor(MAIN_WHITE, for: .normal)
                submitPayBtn.titleLabel?.font = cmSystemFontWithSize(15)
                submitPayBtn.layer.cornerRadius = cmSizeFloat(4)
                submitPayBtn.clipsToBounds = true
                submitPayBtn.backgroundColor = MAIN_GREEN
                submitPayBtn.addTarget(self, action: #selector(submitPayAct), for: .touchUpInside)
                self.view.addSubview(submitPayBtn)
                
            }
            
        }
    }
    
    //MARK: - 支付
    @objc func submitPayAct(){
        
        switch  selectedPayWayTag{
        case 200:
            break
        case 201:
            break
        default:
            break
        }
        
        service.orderPayRequest(userOrderID: self.orderPayModel.userOrderID, successAct: {
            cmShowHUDToWindow(message: "支付成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                let detailService = OrderDetailService()
                detailService.otherOrderDetailDataRequest(userOrderID: self.orderPayModel.userOrderID)
            })
        }) {
            
        }
        
    }
    
    //MARK: - 选定支付方式
    @objc func selectedPayAction(tap:UITapGestureRecognizer) {
        
        for selectedimageView in selectedImageviewsArr {
            selectedimageView.image = unselectedImage
        }
        
        if let tapImageView = tap.view as? UIImageView {
            tapImageView.image = seletcedImage
            selectedPayWayTag = tapImageView.tag

        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
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
