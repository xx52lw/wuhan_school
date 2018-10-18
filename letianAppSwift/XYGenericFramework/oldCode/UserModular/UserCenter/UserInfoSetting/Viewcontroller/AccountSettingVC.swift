//
//  accountSettingVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class AccountSettingVC: UIViewController,UITextFieldDelegate {

    let genderStrArr = ["先生","女士"]
    let toside = cmSizeFloat(20)
    let subViewHeight = cmSizeFloat(50)
    let selectGenderImage = #imageLiteral(resourceName: "genderSelected")
    let unselectGenderImage = #imageLiteral(resourceName: "genderUnselected")
    let textSpace = cmSizeFloat(10)
    let strWidth = "联系电话".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
    
    var topView:XYTopView!
    var userNameTexfield:UITextField!
    var userNickNameTexfield:UITextField!
    var userTelTexfield:UITextField!
    var genderImageViewArr:[UIImageView] = Array()

    var selectedGender = -1
    
    var userSettingInfoModel:UserInfoSettingModel!
    var service:UserInfoModifyService = UserInfoModifyService()

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
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "账户设置"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK:  - 创建子View
    func createSubViews() {
        

        let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: strWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "姓名"
        self.view.addSubview(titleLabel)
        
        
        userNameTexfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2 - textSpace, height: subViewHeight))
        userNameTexfield.font = cmSystemFontWithSize(15)
        userNameTexfield.textColor = MAIN_BLACK
        userNameTexfield.textAlignment = .left
        userNameTexfield.placeholder = "必填，最多四个汉字"
        userNameTexfield.returnKeyType = .done
        userNameTexfield.delegate = self
        if userSettingInfoModel.userName != nil {
            userNameTexfield.text = userSettingInfoModel.userName
        }
        self.view.addSubview(userNameTexfield)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: userNameTexfield.bottom - cmSizeFloat(1)))
        
        let genderTitleLabel = UILabel(frame: CGRect(x: toside, y: userNameTexfield.bottom, width: strWidth, height: subViewHeight))
        genderTitleLabel.font = cmSystemFontWithSize(15)
        genderTitleLabel.textColor = MAIN_BLACK
        genderTitleLabel.textAlignment = .left
        genderTitleLabel.text = "性别"
        self.view.addSubview(genderTitleLabel)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: genderTitleLabel.bottom - cmSizeFloat(1)))

        
        let genderImageToText = cmSizeFloat(4)
        for strIndex in 0..<genderStrArr.count {
            let btnWidth = genderStrArr[strIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)) + selectGenderImage.size.width + genderImageToText
            
            let selectGenderBtn = UIButton(frame: CGRect(x: genderTitleLabel.right + textSpace + (cmSizeFloat(20)+btnWidth)*CGFloat(strIndex), y: genderTitleLabel.top, width: btnWidth, height: subViewHeight))
            selectGenderBtn.tag = 200 + strIndex
            selectGenderBtn.addTarget(self, action: #selector(selectGenderBtnAct(sender:)), for: .touchUpInside)
            self.view.addSubview(selectGenderBtn)
            
            let genderImageView = UIImageView(frame: CGRect(x: 0, y: subViewHeight/2-unselectGenderImage.size.height/2, width: unselectGenderImage.size.width, height: unselectGenderImage.size.height))
            genderImageView.image = unselectGenderImage
            genderImageViewArr.append(genderImageView)
            selectGenderBtn.addSubview(genderImageView)
            
            let genderStrLabel = UILabel(frame: CGRect(x: genderImageView.right + genderImageToText, y: 0, width: genderStrArr[strIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)), height: subViewHeight))
            genderStrLabel.font = cmSystemFontWithSize(15)
            genderStrLabel.textColor = MAIN_BLACK
            genderStrLabel.textAlignment = .left
            genderStrLabel.text = genderStrArr[strIndex]
            selectGenderBtn.addSubview(genderStrLabel)
            
        }
        //已设置性别设置
        if userSettingInfoModel.userSex != -1 {
            selectedGender = userSettingInfoModel.userSex
            if userSettingInfoModel.userSex == 1 {
                genderImageViewArr[0].image = selectGenderImage
                genderImageViewArr[1].image = unselectGenderImage
            }else if userSettingInfoModel.userSex == 2{
                genderImageViewArr[0].image = unselectGenderImage
                genderImageViewArr[1].image = selectGenderImage
            }
        }
        
        let telTitleLabel = UILabel(frame: CGRect(x: toside, y: genderTitleLabel.bottom, width: strWidth, height: subViewHeight))
        telTitleLabel.font = cmSystemFontWithSize(15)
        telTitleLabel.textColor = MAIN_BLACK
        telTitleLabel.textAlignment = .left
        telTitleLabel.text = "联系电话"
        self.view.addSubview(telTitleLabel)
        
        userTelTexfield = UITextField(frame: CGRect(x: strWidth + toside + textSpace, y: telTitleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2 - textSpace, height: subViewHeight))
        userTelTexfield.placeholder = "录入手机号码(11位数字)"
        userTelTexfield.font = cmSystemFontWithSize(15)
        userTelTexfield.textColor = MAIN_BLACK
        userTelTexfield.keyboardType = .numberPad
        userTelTexfield.textAlignment = .left
        userTelTexfield.returnKeyType = .done
        userTelTexfield.delegate = self
        if userSettingInfoModel.userTel != nil {
            userTelTexfield.text = userSettingInfoModel.userTel
        }
        self.view.addSubview(userTelTexfield)

        let backgroundView = UIView(frame: CGRect(x: 0, y: userTelTexfield.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-userTelTexfield.bottom))
        backgroundView.backgroundColor = seperateLineColor
        self.view.addSubview(backgroundView)

        let submitModifyBtn = UIButton(frame: CGRect(x: toside, y: userTelTexfield.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(40)))
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
        if userNameTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请填写您的姓名")
            return
        }
        
        if selectedGender == -1{
            cmShowHUDToWindow(message: "请选择您的性别")
            return
        }
        
        if userTelTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty || userTelTexfield.text!.isNotPerfectMatchTelNum() == false {
            cmShowHUDToWindow(message: "请填写正确的手机号码")
            return
        }
        
        sender.isEnabled = false

        service.updateUserAccountRequest(userName: userNameTexfield.text!, gender: selectedGender, userTel: userTelTexfield.text!, successAct: { [weak self] in
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
    
    
    //MARK: - 性别选择
    @objc func selectGenderBtnAct(sender:UIButton) {
        
        for iamgeViewIndex in 0..<genderImageViewArr.count {
            if sender.tag - 200 == iamgeViewIndex {
                genderImageViewArr[iamgeViewIndex].image = selectGenderImage
            }else{
                genderImageViewArr[iamgeViewIndex].image = unselectGenderImage
            }
        }

        //性别选择
        if sender.tag == 200 {
            selectedGender = 1
        }else{
            selectedGender = 2
        }
        
        
    }
    

    
    
    //MARK: - 字符输入限制
    @objc func textFieldDidChang(sender:UITextField){
        let contentStr = sender.text!
        if sender == userNameTexfield{
            if contentStr.count > 4{
                sender.text = contentStr[0..<4]
                cmShowHUDToWindow(message: "姓名最多只能输入4个字符")
            }
        }else{
            if sender == userTelTexfield{
                if contentStr.count > 11{
                    sender.text = contentStr[0..<11]
                    cmShowHUDToWindow(message: "联系方式最多为11位")
                }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
