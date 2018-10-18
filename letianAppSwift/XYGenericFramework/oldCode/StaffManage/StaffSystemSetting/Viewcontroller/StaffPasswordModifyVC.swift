//
//  StaffPasswordModifyVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffPasswordModifyVC: UIViewController,UITextFieldDelegate {
    
    let strWidth = "原密码".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
    let toside = cmSizeFloat(20)
    let subViewHeight = cmSizeFloat(50)
    let textSpace = cmSizeFloat(10)
    
    var topView:XYTopView!
    var passWordTextfield:UITextField!
    var passWordModifyTextfield:UITextField!
    
    var service:StaffSystemSettingService = StaffSystemSettingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubviews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建子View
    func createSubviews() {
        
        
        //初始密码
        let passwordTitleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: strWidth, height: subViewHeight))
        passwordTitleLabel.font = cmSystemFontWithSize(15)
        passwordTitleLabel.textColor = MAIN_BLACK
        passwordTitleLabel.textAlignment = .left
        passwordTitleLabel.text = "原密码"
        self.view.addSubview(passwordTitleLabel)
        
        passWordTextfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: passwordTitleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2 - textSpace , height: subViewHeight))
        passWordTextfield.font = cmSystemFontWithSize(15)
        passWordTextfield.textColor = MAIN_GRAY
        passWordTextfield.textAlignment = .left
        passWordTextfield.placeholder = "录入账号的原始密码"
        passWordTextfield.returnKeyType = .done
        passWordTextfield.delegate = self
        passWordTextfield.isSecureTextEntry = true
        self.view.addSubview(passWordTextfield)
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: passWordTextfield.bottom - cmSizeFloat(1)))
        
        //更改密码
        let passwordModifyTitleLabel = UILabel(frame: CGRect(x: toside, y: passWordTextfield.bottom, width: strWidth, height: subViewHeight))
        passwordModifyTitleLabel.font = cmSystemFontWithSize(15)
        passwordModifyTitleLabel.textColor = MAIN_BLACK
        passwordModifyTitleLabel.textAlignment = .left
        passwordModifyTitleLabel.text = "新密码"
        self.view.addSubview(passwordModifyTitleLabel)
        
        passWordModifyTextfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: passwordModifyTitleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2 - textSpace , height: subViewHeight))
        passWordModifyTextfield.font = cmSystemFontWithSize(15)
        passWordModifyTextfield.textColor = MAIN_GRAY
        passWordModifyTextfield.textAlignment = .left
        passWordModifyTextfield.placeholder = "录入更改后的密码"
        passWordModifyTextfield.returnKeyType = .done
        passWordModifyTextfield.delegate = self
        passWordModifyTextfield.isSecureTextEntry = true
        self.view.addSubview(passWordModifyTextfield)
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: passWordModifyTextfield.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-passWordModifyTextfield.bottom))
        backgroundView.backgroundColor = seperateLineColor
        self.view.addSubview(backgroundView)
        
        let submitModifyBtn = UIButton(frame: CGRect(x: toside, y: passWordModifyTextfield.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        submitModifyBtn.setTitle("确认修改", for: .normal)
        submitModifyBtn.setTitleColor(MAIN_WHITE, for: .normal)
        submitModifyBtn.titleLabel?.font = cmSystemFontWithSize(15)
        submitModifyBtn.layer.cornerRadius = cmSizeFloat(4)
        submitModifyBtn.clipsToBounds = true
        submitModifyBtn.backgroundColor = MAIN_GREEN
        submitModifyBtn.addTarget(self, action: #selector(submitModifyBtnAct(sender:)), for: .touchUpInside)
        self.view.addSubview(submitModifyBtn)
        
    }
    
    
    //MARK: - 提交修改
    @objc func submitModifyBtnAct(sender:UIButton) {
        if passWordTextfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请输入原始密码")
            return
        }
        
        if passWordModifyTextfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请输入新密码")
            return
        }
        
        if passWordModifyTextfield.text!.count < 6 || passWordTextfield.text!.count < 6{
            cmShowHUDToWindow(message: "密码最少需要输入6位字符")
            return
        }
        
        sender.isEnabled = false
        
        
        var paramsDict: [String: Any] = Dictionary()
        paramsDict["OldPassword"] = passWordTextfield.text!
        paramsDict["NewPassword"] = passWordModifyTextfield.text!
        paramsDict["NewPasswordConfirm"] = passWordModifyTextfield.text!
        
        service.updateStaffPassWordRequest(paramsDict: paramsDict, successAct: { [weak self] in
            cmShowHUDToWindow(message: "修改成功")
            DispatchQueue.main.async {
                sender.isEnabled = true
                self?.navigationController?.popViewController(animated: true)
            }
        }) {
            sender.isEnabled = true
        }
        
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "修改密码"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
