//
//  OrderRefundVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/31.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderRefundVC: UIViewController {
    
    let subViewImagesArr:[UIImage] = [#imageLiteral(resourceName: "orderCancelOnline"),#imageLiteral(resourceName: "orderCancelTel")]
    let subviewTitleArr:[String] = ["联系商家，快速退款","在线申请退款"]
    let subviewTipsArr:[String] = ["订单已送达，建议您先与商家协商退款。","商家会在24小时内处理您的申请"]
    
    private let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    private let subViewHeight = cmSizeFloat(80)
    private let toside = cmSizeFloat(20)
    
    private  var topView:XYTopView!
    private var actionAlertView:XYAlertView!
    private var callPhonePopView:XYCallPhonePopView!
    
    var phoneNumArr:[String] = Array()
    var orderID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubViews()
         creatActionAlertView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "申请退款"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建弹框按钮View
    func creatActionAlertView(){
        actionAlertView = XYAlertView(frame: .zero, detailTipsStr: "建议您优先联系商家协商，如因您自身原因导致的申请，商家和客服有权拒绝", titleStr: "提示", cancelStr: nil, certainStr: "知道了", cancelBtnClosure: nil, certainClosure: {
            
        })
        actionAlertView.clickControlHideView = false
        actionAlertView.showInView(view: self.view)
        
        self.view.addSubview(actionAlertView)
    }
    
    //MARK: - 创建子View
    func createSubViews(){
        
        let textToImage = cmSizeFloat(10)
        let showMoreBtnWidht = cmSizeFloat(44)
        let titleToTipsHeight = cmSizeFloat(7)
        let textToTop = (subViewHeight - cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) - cmSizeFloat(7))/2
        
        for index in 0..<subviewTitleArr.count {
            
            let subView = UIView(frame: CGRect(x: 0, y: topView.bottom + (subViewHeight+cmSizeFloat(7))*CGFloat(index), width: SCREEN_WIDTH, height: subViewHeight))
            subView.backgroundColor = .white
            self.view.addSubview(subView)
            
            let subImageView = UIImageView(frame: CGRect(x: toside, y: subViewHeight/2 - subViewImagesArr[index].size.height/2, width: subViewImagesArr[index].size.width, height: subViewImagesArr[index].size.height))
            subImageView.image = subViewImagesArr[index]
            subView.addSubview(subImageView)
            
            let titleLabel = UILabel(frame: CGRect(x: subImageView.right + textToImage, y: textToTop, width: SCREEN_WIDTH - (subImageView.right + textToImage+showMoreBtnWidht), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            titleLabel.text = subviewTitleArr[index]
            subView.addSubview(titleLabel)
            
            
            let tipsLabel = UILabel(frame: CGRect(x: subImageView.right + textToImage, y: titleLabel.bottom + titleToTipsHeight, width: titleLabel.frame.size.width, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            tipsLabel.font = cmSystemFontWithSize(13)
            tipsLabel.textColor = MAIN_GRAY
            tipsLabel.textAlignment = .left
            tipsLabel.text = subviewTipsArr[index]
            subView.addSubview(tipsLabel)
            
            
            let showMoreBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - showMoreBtnWidht, y: 0, width: showMoreBtnWidht, height: subViewHeight))
            showMoreBtn.setImage(showMoreImage, for: .normal)
            showMoreBtn.tag = 200 + index
            showMoreBtn.addTarget(self, action: #selector(showMoreBtnAct(sender:)), for: .touchUpInside)
            subView.addSubview(showMoreBtn)
            
            if index != subviewTitleArr.count - 1 {
                self.view.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: subView.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
            }
            
        }
        
        
    }
    
    //MARK: - 更多按钮响应
    @objc func showMoreBtnAct(sender:UIButton) {
        switch  sender.tag{
        case 200:
            if self.phoneNumArr.count == 0 {
                cmShowHUDToWindow(message: "暂无商家联系方式")
                return
            }else if self.phoneNumArr.count == 1 {
                cmMakePhoneCall(phoneStr: self.phoneNumArr.first!)
            }else{
                callPhonePopView = XYCallPhonePopView(frame: .zero, phoneNumArr: self.phoneNumArr)
                callPhonePopView.showInView(view: self.view)
            }
            break
        case 201:
            let refundOnlineVC = OrderRefundOnlineVC()
            refundOnlineVC.orderID = self.orderID
            self.navigationController?.pushViewController(refundOnlineVC, animated: true)
            break
        default:
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
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
