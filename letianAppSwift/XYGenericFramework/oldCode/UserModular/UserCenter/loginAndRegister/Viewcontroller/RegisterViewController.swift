//
//  RegisterViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    let subviewStrArr = ["账号","密码","昵称","姓名","性别","联系电话","城市","学校"]//["账号","密码","昵称","姓名","性别","联系电话","城市","学校","校内地址"]
    let toside = cmSizeFloat(20)
    let subViewHeight = cmSizeFloat(50)
    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    let genderStrArr = ["先生","女士"]
    let selectGenderImage = #imageLiteral(resourceName: "genderSelected")
    let unselectGenderImage = #imageLiteral(resourceName: "genderUnselected")

    
    var topView:XYTopView!

    var accountTextField:UITextField!
    var passWordTextField:UITextField!
    var userNickNameTexfield:UITextField!
    var userNameTexfield:UITextField!
    var userGender:UIView!
    var userTelTexfield:UITextField!
    var selectedCityTF:UITextField!
    var selectedSchoolTF:UITextField!
    //var mapLocationTF:UITextField!
    
    var submitButton:UIButton!
    
    var selectedGender = -1
    var settingInfoModel:UserInfoSettingModel = UserInfoSettingModel()

    var userInfoSettingService:UserInfoSettingService = UserInfoSettingService()
    
    var loginRegisterService:LoginRegisterService = LoginRegisterService()
    
    var genderImageViewArr:[UIImageView] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        
        userInfoSettingService.cityDataRequest(target: self) { [weak self] (cityModelArr) in
            self?.settingInfoModel.cityModelArr = cityModelArr
            DispatchQueue.main.async {
                self?.createSubViews()
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "注册"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - UI设置
    func refreshSubviewsUI() {
        
        if settingInfoModel.selectedCityModel != nil {
            selectedCityTF.text = settingInfoModel.selectedCityModel.cityName
        }
        if settingInfoModel.selectedAreaModel != nil {
            selectedSchoolTF.text = settingInfoModel.selectedAreaModel.areaName
        }
        
//        if settingInfoModel.schoolAdress != nil {
//            mapLocationTF.text = settingInfoModel.schoolAdress
//        }
        
    }
    
    
    
    
    //MARK: - 创建子View
    func createSubViews() {
        
        for index  in 0..<subviewStrArr.count{
        
        let strWidth = subviewStrArr[5].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom +  subViewHeight*CGFloat(index), width: strWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = subviewStrArr[index]
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: titleLabel.bottom - cmSizeFloat(1)))
        
        switch index {
        case 0:
            accountTextField = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2, height: subViewHeight))
            accountTextField.font = cmSystemFontWithSize(15)
            accountTextField.textColor = MAIN_BLACK
            accountTextField.textAlignment = .left
            accountTextField.placeholder = "6-20位字符"
            accountTextField.returnKeyType = .done
            accountTextField.delegate = self
            accountTextField.addTarget(self, action: #selector(textFieldDidChang(sender:)), for: .editingChanged)
            self.view.addSubview(accountTextField)
            break
            
        case 1:
            passWordTextField = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2, height: subViewHeight))
            passWordTextField.font = cmSystemFontWithSize(15)
            passWordTextField.textColor = MAIN_BLACK
            passWordTextField.textAlignment = .left
            passWordTextField.placeholder = "6-20位字符"
            passWordTextField.returnKeyType = .done
            passWordTextField.delegate = self
            passWordTextField.addTarget(self, action: #selector(textFieldDidChang(sender:)), for: .editingChanged)
            passWordTextField.isSecureTextEntry = true
            self.view.addSubview(passWordTextField)
            break
            
        case 2:
            userNickNameTexfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2, height: subViewHeight))
            userNickNameTexfield.font = cmSystemFontWithSize(15)
            userNickNameTexfield.textColor = MAIN_BLACK
            userNickNameTexfield.textAlignment = .left
            userNickNameTexfield.placeholder = "2-15个字符以内"
            userNickNameTexfield.returnKeyType = .done
            userNickNameTexfield.delegate = self
            userNickNameTexfield.addTarget(self, action: #selector(textFieldDidChang(sender:)), for: .editingChanged)
            self.view.addSubview(userNickNameTexfield)
            break
        case 3:
            userNameTexfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2, height: subViewHeight))
            userNameTexfield.font = cmSystemFontWithSize(15)
            userNameTexfield.textColor = MAIN_BLACK
            userNameTexfield.textAlignment = .left
            userNameTexfield.placeholder = "必填，最多四个汉字"
            userNameTexfield.returnKeyType = .done
            userNameTexfield.delegate = self
            userNameTexfield.addTarget(self, action: #selector(textFieldDidChang(sender:)), for: .editingChanged)
            self.view.addSubview(userNameTexfield)
            break
        case 4:
            let genderImageToText = cmSizeFloat(4)
            let textSpace = cmSizeFloat(10)
            for strIndex in 0..<genderStrArr.count {
                let btnWidth = genderStrArr[strIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)) + selectGenderImage.size.width + genderImageToText
                
                let selectGenderBtn = UIButton(frame: CGRect(x: titleLabel.right + textSpace + (cmSizeFloat(20)+btnWidth)*CGFloat(strIndex), y: titleLabel.top, width: btnWidth, height: subViewHeight))
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
            break
        case 5:
            userTelTexfield = UITextField(frame: CGRect(x: titleLabel.right + cmSizeFloat(10), y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2 - cmSizeFloat(10), height: subViewHeight))
            userTelTexfield.placeholder = "录入手机号码(11位数字)"
            userTelTexfield.font = cmSystemFontWithSize(15)
            userTelTexfield.textColor = MAIN_BLACK
            userTelTexfield.keyboardType = .numberPad
            userTelTexfield.textAlignment = .left
            userTelTexfield.returnKeyType = .done
            userTelTexfield.delegate = self
            self.view.addSubview(userTelTexfield)
            break
        case 6:
            selectedCityTF = UITextField(frame: CGRect(x: SCREEN_WIDTH - SCREEN_WIDTH/2 - toside, y: titleLabel.top, width: SCREEN_WIDTH/2, height: subViewHeight))
            selectedCityTF.font = cmSystemFontWithSize(15)
            selectedCityTF.textColor = MAIN_BLACK
            selectedCityTF.textAlignment = .right
            selectedCityTF.placeholder = "请选择城市"
            
            let showMoreImageView = UIImageView(frame: CGRect(x: selectedCityTF.frame.size.width - cmSizeFloat(8), y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + cmSizeFloat(16), height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            showMoreImageView.contentMode = .scaleAspectFit
            selectedCityTF.rightView = showMoreImageView
            selectedCityTF.rightViewMode = .always
            selectedCityTF.delegate = self
            
            self.view.addSubview(selectedCityTF)
            break
        case 7:
            selectedSchoolTF = UITextField(frame: CGRect(x: SCREEN_WIDTH - SCREEN_WIDTH/2 - toside, y: titleLabel.top, width: SCREEN_WIDTH/2, height: subViewHeight))
            selectedSchoolTF.font = cmSystemFontWithSize(15)
            selectedSchoolTF.textColor = MAIN_BLACK
            selectedSchoolTF.textAlignment = .right
            selectedSchoolTF.placeholder = "请选择学校"
            
            let showMoreImageView = UIImageView(frame: CGRect(x: selectedCityTF.frame.size.width - cmSizeFloat(8), y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + cmSizeFloat(16), height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            showMoreImageView.contentMode = .scaleAspectFit
            selectedSchoolTF.rightView = showMoreImageView
            selectedSchoolTF.rightViewMode = .always
            selectedSchoolTF.delegate = self
            self.view.addSubview(selectedSchoolTF)
            
            //提交按钮
            let btnSizeHeight = cmSizeFloat(32)
            submitButton = UIButton(frame: CGRect(x: (SCREEN_WIDTH - SCREEN_WIDTH*3/4)/2, y: selectedSchoolTF.bottom + cmSizeFloat(15), width: SCREEN_WIDTH*3/4, height: btnSizeHeight))
            submitButton.clipsToBounds = true
            submitButton.layer.cornerRadius = btnSizeHeight/2
            submitButton.setTitle("确认提交", for: .normal)
            submitButton.setTitleColor(MAIN_WHITE, for: .normal)
            submitButton.titleLabel?.font = cmSystemFontWithSize(15)
            submitButton.backgroundColor = MAIN_BLUE
            submitButton.addTarget(self, action: #selector(submitButtonAct), for: .touchUpInside)
            
            self.view.addSubview(submitButton)
            
            break
            /*
        case 8:
            mapLocationTF = UITextField(frame: CGRect(x: SCREEN_WIDTH - SCREEN_WIDTH/2 - toside, y: titleLabel.top, width: SCREEN_WIDTH/2, height: subViewHeight))
            mapLocationTF.font = cmSystemFontWithSize(15)
            mapLocationTF.textColor = MAIN_BLACK
            mapLocationTF.textAlignment = .right
            mapLocationTF.placeholder = "选择"
            
            let showMoreImageView = UIImageView(frame: CGRect(x: mapLocationTF.frame.size.width - cmSizeFloat(8), y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + cmSizeFloat(16), height: showMoreImage.size.height))
            showMoreImageView.image = showMoreImage
            showMoreImageView.contentMode = .scaleAspectFit
            mapLocationTF.rightView = showMoreImageView
            mapLocationTF.rightViewMode = .always
            mapLocationTF.delegate = self
            self.view.addSubview(mapLocationTF)
            
            
            //提交按钮
            let btnSizeHeight = cmSizeFloat(32)
           submitButton = UIButton(frame: CGRect(x: (SCREEN_WIDTH - SCREEN_WIDTH*3/4)/2, y: mapLocationTF.bottom + cmSizeFloat(15), width: SCREEN_WIDTH*3/4, height: btnSizeHeight))
            submitButton.clipsToBounds = true
            submitButton.layer.cornerRadius = btnSizeHeight/2
            submitButton.setTitle("确认提交", for: .normal)
            submitButton.setTitleColor(MAIN_WHITE, for: .normal)
            submitButton.titleLabel?.font = cmSystemFontWithSize(15)
            submitButton.backgroundColor = MAIN_BLUE
            submitButton.addTarget(self, action: #selector(submitButtonAct), for: .touchUpInside)
            
            self.view.addSubview(submitButton)

            
            break
        */
        default:
            break
        }
        
        
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
    
    
    
    
    //MARK: - 提交按钮
    @objc func submitButtonAct(){
        

        
        
        if  accountTextField.text!.count < 6 {
            cmShowHUDToWindow(message: "账号最少需要输入6位字符")
            return
        }
        
        if passWordTextField.text!.count < 6{
            cmShowHUDToWindow(message: "密码最少需要输入6位字符")
            return
        }
        
        if userNickNameTexfield.text!.count < 2{
            cmShowHUDToWindow(message: "昵称最少需要输入2个字符")
            return
        }
        
        if userNameTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请填写您的姓名")
            return
        }
        
        if userNameTexfield.text!.trimmingCharacters(in: .whitespaces).count > 4{
            cmShowHUDToWindow(message: "姓名最多只能输入4个字符")
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
        
        
        settingInfoModel.nickName = userNickNameTexfield.text!
        settingInfoModel.account = accountTextField.text!
        settingInfoModel.passWord = passWordTextField.text!
        settingInfoModel.userName = userNameTexfield.text!
        settingInfoModel.userTel = userTelTexfield.text!
        settingInfoModel.userSex = selectedGender
        
        if settingInfoModel.selectedCityModel == nil{
            cmShowHUDToWindow(message: "您还没有选择城市哦")
            return
        }
        if settingInfoModel.selectedAreaModel == nil{
            cmShowHUDToWindow(message: "您还没有选择学校哦")
            return
        }
        
        if settingInfoModel.nickName == nil {
            cmShowHUDToWindow(message: "请填写您的姓名")
            return
        }
        

        /*
        if settingInfoModel.geoHash == nil || settingInfoModel.schoolAdress == nil{
            cmShowHUDToWindow(message: "请选择在校内的地址")
            return
        }
        */
        
        
        loginRegisterService.userRegisterRequest(target: self)
        
    }
    
    //MARK: - 地图定位
    func mapLocationBtnAc() {
        
        if settingInfoModel.selectedAreaModel == nil {
            cmShowHUDToWindow(message: "请先选择城市和学校")
            return
        }
        
        let geohashVC = chooseMapGeoHashVC()
        geohashVC.geohashStrArr = settingInfoModel.selectedAreaModel.expressPoints.components(separatedBy: "-")
        self.navigationController?.pushViewController(geohashVC, animated: true)
        
    }
    
    //MARK: - delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == selectedCityTF {
            let selectCityVC = ChooseCityVC()
            selectCityVC.cityModelArr =  settingInfoModel.cityModelArr
            self.navigationController?.pushViewController(selectCityVC, animated: true)
            return false
        }else if textField ==  selectedSchoolTF{
            if settingInfoModel.selectedCityModel == nil{
                cmShowHUDToWindow(message: "请先选择城市")
                return false
            }
            let selectAreaVC = ChooseAreaVC()
            selectAreaVC.cityCode =  settingInfoModel.selectedCityModel.cityCode
            self.navigationController?.pushViewController(selectAreaVC, animated: true)
            return false
        }
        /*
        else if textField ==  mapLocationTF{
            mapLocationBtnAc()
            return false
        }
         */
        return true
    }
    
    
    
    //MARK: - 字符输入限制
   @objc func textFieldDidChang(sender:UITextField){
        let contentStr = sender.text!
    if sender == accountTextField  || sender == passWordTextField{
        if contentStr.count > 20{
            sender.text = contentStr[0..<20]
            cmShowHUDToWindow(message: "最多只能输入20位字符")
        }
    }else if sender == userNickNameTexfield{
        if contentStr.count > 15{
            sender.text = contentStr[0..<15]
            cmShowHUDToWindow(message: "最多只能输15个字符")
        }
    }
    /*
    else if sender == userNameTexfield{
        if contentStr.count > 4{
            sender.text = contentStr[0..<4]
            cmShowHUDToWindow(message: "最多只能输4个汉字")
        }
    }
    */
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
