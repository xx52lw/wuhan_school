//
//  UserNameSettingVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class UserNameSettingVC: UIViewController,UITextFieldDelegate {

    let toside = cmSizeFloat(20)
    let subViewHeight = cmSizeFloat(50)

    let titleStrMaxWidth = "用户名".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
    var topView:XYTopView!
    var userNickNameTexfield:UITextField!
    var  submitModifyBtn:UIButton!

    var userSettingInfoModel:UserInfoSettingModel!
    var service:UserInfoModifyService = UserInfoModifyService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = seperateLineColor
        creatNavTopView()
        createAvatarNickName()
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "用户名"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建用户名
    func createAvatarNickName(){

        
        userNickNameTexfield = UITextField(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH , height: subViewHeight))
        userNickNameTexfield.font = cmSystemFontWithSize(15)
        userNickNameTexfield.textColor = MAIN_GRAY
        userNickNameTexfield.textAlignment = .right
        userNickNameTexfield.returnKeyType = .done
        userNickNameTexfield.backgroundColor = .white
        userNickNameTexfield.delegate = self
        userNickNameTexfield.addTarget(self, action: #selector(textFieldDidChang(sender:)), for: .editingChanged)
        if userSettingInfoModel.nickName != nil {
            userNickNameTexfield.text = userSettingInfoModel.nickName
        }
        
        //用户名
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: toside*2 + titleStrMaxWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .center
        titleLabel.text = "用户名"
        titleLabel.backgroundColor = .white
        userNickNameTexfield.leftView = titleLabel
        userNickNameTexfield.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: SCREEN_WIDTH - toside, y:0 , width: toside, height: subViewHeight))
        userNickNameTexfield.rightView = rightView
        userNickNameTexfield.rightViewMode = .always
        
        self.view.addSubview(userNickNameTexfield)
        
        let tipsLabel = UILabel(frame: CGRect(x: toside, y: userNickNameTexfield.bottom, width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
        tipsLabel.font = cmSystemFontWithSize(13)
        tipsLabel.textColor = MAIN_BLACK2
        tipsLabel.textAlignment = .left
        tipsLabel.text = "用户名只能修改一次(2-15字符内)"
        self.view.addSubview(tipsLabel)
        
        
         submitModifyBtn = UIButton(frame: CGRect(x: toside, y: tipsLabel.bottom, width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
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
        if userNickNameTexfield.text!.count < 2{
            cmShowHUDToWindow(message: "用户名最少需要输入2个字符")
            return
        }
        sender.isEnabled = false
        service.updateUserNickNameRequest(nickName: userNickNameTexfield.text!, successAct: { [weak self] in
            cmShowHUDToWindow(message: "更新成功")
            DispatchQueue.main.async {
                sender.isEnabled = true
                if let lastVC =  self?.navigationController?.viewControllers[(self?.navigationController?.viewControllers.count)! - 2] as? UserAccountInfoVC {
                    lastVC.service.userInfoRequest(target: lastVC)
                }
                self?.navigationController?.popViewController(animated: true)
            }
        }) {
            sender.isEnabled = true
        }
    }
    
    
    //MARK: - 字符输入限制
    @objc func textFieldDidChang(sender:UITextField){
        let contentStr = sender.text!
        if sender == userNickNameTexfield{
            if contentStr.count > 15{
                sender.text = contentStr[0..<15]
                cmShowHUDToWindow(message: "最多只能输15个字符")
            }
        }
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
