//
//  MerchantRefuseReturnOrderVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantRefuseReturnOrderVC: UIViewController,UITextViewDelegate {
    
    let toside = cmSizeFloat(20)
    let refuseTitleHeight = cmSizeFloat(40)
    let comlainTitleStr = "拒绝理由"
    let TEXT_COUNT_LIMIT = 30
    
    var topView:XYTopView!
    var refuseTextView:UITextView!
    var popView:XYNoDetailTipsAlertView!
    
    
    
    var orderID:String!
    var service  = MerchantOrderDetailService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = comlainTitleStr
    }
    
    //MARK: - 创建子View
    func createSubViews(){
        let comlainTitleStrWidth = comlainTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        let refuseTitleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: comlainTitleStrWidth, height: refuseTitleHeight))
        refuseTitleLabel.font = cmSystemFontWithSize(15)
        refuseTitleLabel.textColor = MAIN_BLACK
        refuseTitleLabel.textAlignment = .left
        refuseTitleLabel.text = comlainTitleStr
        self.view.addSubview(refuseTitleLabel)
        
        let refusetTipsLabel = UILabel(frame: CGRect(x: refuseTitleLabel.right + cmSizeFloat(5), y: refuseTitleLabel.frame.origin.y, width: SCREEN_WIDTH - refuseTitleLabel.right - toside - cmSizeFloat(5), height: refuseTitleLabel.frame.size.height))
        refusetTipsLabel.font = cmSystemFontWithSize(12)
        refusetTipsLabel.textColor = MAIN_GRAY
        refusetTipsLabel.textAlignment = .left
        refusetTipsLabel.text = "(30字符以内)"
        self.view.addSubview(refusetTipsLabel)
        
        refuseTextView = UITextView(frame: CGRect(x: toside, y: refusetTipsLabel.frame.maxY, width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(100)))
        refuseTextView.font = UIFont.systemFont(ofSize: 13)
        refuseTextView.textColor = MAIN_BLACK2
        refuseTextView.returnKeyType = .done
        refuseTextView.layer.borderColor = MAIN_BLUE.cgColor
        refuseTextView.layer.borderWidth = CGFloat(1)
        refuseTextView.backgroundColor = seperateLineColor
        refuseTextView.delegate = self
        self.view.addSubview(refuseTextView)
        
        
        
        let submitAdressBtn = UIButton(frame: CGRect(x: toside, y: refuseTextView.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        submitAdressBtn.setTitle("发 送", for: .normal)
        submitAdressBtn.setTitleColor(MAIN_WHITE, for: .normal)
        submitAdressBtn.titleLabel?.font = cmSystemFontWithSize(15)
        submitAdressBtn.layer.cornerRadius = cmSizeFloat(4)
        submitAdressBtn.clipsToBounds = true
        submitAdressBtn.backgroundColor = MAIN_GREEN
        submitAdressBtn.addTarget(self, action: #selector(submitBtnAct), for: .touchUpInside)
        self.view.addSubview(submitAdressBtn)
        
    }
    
    
    //MARK: - 提交按钮
    @objc func submitBtnAct() {
        let refuseContentStr = refuseTextView.text!.trimmingCharacters(in: .whitespaces)
        
        if refuseContentStr.count < 2 {
            cmShowHUDToWindow(message: "提交的内容需大于两个字符")
            return
        }
        
        self.view.endEditing(true)
        
        popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "确认要拒绝退单吗？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
            
        }, certainClosure: { [weak self] in
            self!.service.returnOrderMerchantActRequest(userOrderID: self!.orderID, isAgree: false, reason: self!.refuseTextView.text, successAct: {
                cmShowHUDToWindow(message: "提交成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    let navVCCount = self!.navigationController!.viewControllers.count
                    //直接返回到商家的订单列表
                    if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 3] as? MerchantOrderManageVC {
                        self?.navigationController?.popToViewController(lastVC, animated: true)
                    }
                })
            }, failureAct: {
                
            })
        })
        popView.showInView(view: self.view)
        
        
    }
    
    //MARK: - TextView delegate
    func textViewDidChange(_ textView: UITextView) {
        let contentStr = textView.text
        if textView.text.count >= TEXT_COUNT_LIMIT{
            textView.text = contentStr![0..<(TEXT_COUNT_LIMIT-1)]
            cmShowHUDToWindow(message:"最多输入100个字")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
