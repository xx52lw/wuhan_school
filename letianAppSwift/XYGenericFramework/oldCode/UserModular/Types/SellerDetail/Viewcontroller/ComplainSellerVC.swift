//
//  ComplainSellerVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ComplainSellerVC: UIViewController,UITextViewDelegate {

    let toside = cmSizeFloat(20)
    let complainTitleHeight = cmSizeFloat(40)
    let comlainTitleStr = "举报投诉"
    let TEXT_COUNT_LIMIT = 100
    
    var topView:XYTopView!
    var complainTextView:UITextView!
    var popView:XYNoDetailTipsAlertView!
    
    
    
    var merchantID:String!
    var service  = OrderDetailService()
    
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
        let complainTitleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: comlainTitleStrWidth, height: complainTitleHeight))
        complainTitleLabel.font = cmSystemFontWithSize(15)
        complainTitleLabel.textColor = MAIN_BLACK
        complainTitleLabel.textAlignment = .left
        complainTitleLabel.text = comlainTitleStr
        self.view.addSubview(complainTitleLabel)
        
        let complaintTipsLabel = UILabel(frame: CGRect(x: complainTitleLabel.right + cmSizeFloat(5), y: complainTitleLabel.frame.origin.y, width: SCREEN_WIDTH - complainTitleLabel.right - toside - cmSizeFloat(5), height: complainTitleLabel.frame.size.height))
        complaintTipsLabel.font = cmSystemFontWithSize(12)
        complaintTipsLabel.textColor = MAIN_GRAY
        complaintTipsLabel.textAlignment = .left
        complaintTipsLabel.text = "(请描述举报投诉的内容，2-100字符)"
        self.view.addSubview(complaintTipsLabel)
        
        complainTextView = UITextView(frame: CGRect(x: toside, y: complaintTipsLabel.frame.maxY, width: SCREEN_WIDTH-toside*2, height: cmSizeFloat(150)))
        complainTextView.font = UIFont.systemFont(ofSize: 13)
        complainTextView.textColor = MAIN_BLACK2
        complainTextView.returnKeyType = .done
        complainTextView.layer.borderColor = MAIN_BLUE.cgColor
        complainTextView.layer.borderWidth = CGFloat(1)
        complainTextView.backgroundColor = seperateLineColor
        complainTextView.delegate = self
        self.view.addSubview(complainTextView)
        
        
        
        let submitAdressBtn = UIButton(frame: CGRect(x: toside, y: complainTextView.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        submitAdressBtn.setTitle("提 交", for: .normal)
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
        let complainContentStr = complainTextView.text!.trimmingCharacters(in: .whitespaces)
        
        if complainContentStr.count < 2 {
            cmShowHUDToWindow(message: "提交的内容需大于两个字符")
            return
        }
        
        self.view.endEditing(true)
        
        popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "确认要投诉吗？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
            
        }, certainClosure: { [weak self] in
            self?.service.applicationForComplainRequest(merchantID: self!.merchantID, content: self!.complainTextView.text, successAct: {
                cmShowHUDToWindow(message: "提交成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }) {
                
            }
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
