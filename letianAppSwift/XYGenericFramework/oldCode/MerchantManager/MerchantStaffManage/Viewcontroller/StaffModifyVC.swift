//
//  StaffModifyVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffModifyVC: UIViewController,UITextFieldDelegate {
    
    let subViewHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let subviewStrArr = ["配送员姓名:","配送员电话:","密码:","状态设置"]
    let statusStrArr = ["开通","关闭"]
    let selectStatusImage = #imageLiteral(resourceName: "genderSelected")
    let unselectStatusImage = #imageLiteral(resourceName: "genderUnselected")
    
    var topView:XYTopView!
    var staffNameTexfield:UITextField!
    var staffTelTexfield:UITextField!
    var passWordTextField:UITextField!
    
    var  submitStaffBtn:UIButton!
    var statusImageViewArr:[UIImageView] = Array()

    var staffModel:StaffManageListCellModel!
    var service:StaffManageListService = StaffManageListService()
    
    var staffCanUse:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        staffCanUse = staffModel.CanUse
        creatNavTopView()
        createSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "修改"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建sbuview
    func createSubViews() {
        
        let textSpace = cmSizeFloat(10)
        
        
        for index  in 0..<subviewStrArr.count {
            
            let strWidth = subviewStrArr[0].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
            let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom +  subViewHeight*CGFloat(index), width: strWidth, height: subViewHeight))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            titleLabel.text = subviewStrArr[index]
            self.view.addSubview(titleLabel)
            
            self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: titleLabel.bottom - cmSizeFloat(1)))
            
            switch index {
            case 0:
                staffNameTexfield = UITextField(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                staffNameTexfield.placeholder = "请输入配送员姓名"
                staffNameTexfield.font = cmSystemFontWithSize(15)
                staffNameTexfield.textColor = MAIN_BLACK
                staffNameTexfield.textAlignment = .left
                staffNameTexfield.returnKeyType = .done
                staffNameTexfield.delegate = self
                self.view.addSubview(staffNameTexfield)
                break
                
            case 1:
                staffTelTexfield = UITextField(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                staffTelTexfield.placeholder = "请输入配送员联系电话"
                staffTelTexfield.font = cmSystemFontWithSize(15)
                staffTelTexfield.textColor = MAIN_BLACK
                staffTelTexfield.textAlignment = .left
                staffTelTexfield.returnKeyType = .done
                staffTelTexfield.delegate = self
                self.view.addSubview(staffTelTexfield)
                break
            case 2:
                passWordTextField = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - strWidth - toside*2, height: subViewHeight))
                passWordTextField.font = cmSystemFontWithSize(15)
                passWordTextField.textColor = MAIN_BLACK
                passWordTextField.textAlignment = .left
                passWordTextField.placeholder = "6-20位字符"
                passWordTextField.returnKeyType = .done
                passWordTextField.delegate = self
                passWordTextField.isSecureTextEntry = true
                self.view.addSubview(passWordTextField)
                
                
                
                break
                
            case 3:
                let genderImageToText = cmSizeFloat(4)
                for strIndex in 0..<statusStrArr.count {
                    let btnWidth = statusStrArr[strIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)) + selectStatusImage.size.width + genderImageToText
                    
                    let selectStatusBtn = UIButton(frame: CGRect(x: titleLabel.right + textSpace + (cmSizeFloat(20)+btnWidth)*CGFloat(strIndex), y: titleLabel.top, width: btnWidth, height: subViewHeight))
                    selectStatusBtn.tag = 200 + strIndex
                    selectStatusBtn.addTarget(self, action: #selector(selectStatusBtnAct(sender:)), for: .touchUpInside)
                    self.view.addSubview(selectStatusBtn)
                    
                    let genderImageView = UIImageView(frame: CGRect(x: 0, y: subViewHeight/2-unselectStatusImage.size.height/2, width: unselectStatusImage.size.width, height: unselectStatusImage.size.height))
                    genderImageView.image = unselectStatusImage
                    statusImageViewArr.append(genderImageView)
                    selectStatusBtn.addSubview(genderImageView)
                    
                    let genderStrLabel = UILabel(frame: CGRect(x: genderImageView.right + genderImageToText, y: 0, width: statusStrArr[strIndex].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15)), height: subViewHeight))
                    genderStrLabel.font = cmSystemFontWithSize(15)
                    genderStrLabel.textColor = MAIN_BLACK
                    genderStrLabel.textAlignment = .left
                    genderStrLabel.text = statusStrArr[strIndex]
                    selectStatusBtn.addSubview(genderStrLabel)
                    
                }
                
                submitStaffBtn = UIButton(frame: CGRect(x: toside, y: passWordTextField.bottom + subViewHeight + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(38)))
                submitStaffBtn.setTitle("确  认", for: .normal)
                submitStaffBtn.setTitleColor(MAIN_WHITE, for: .normal)
                submitStaffBtn.titleLabel?.font = cmSystemFontWithSize(15)
                submitStaffBtn.layer.cornerRadius = cmSizeFloat(4)
                submitStaffBtn.clipsToBounds = true
                submitStaffBtn.backgroundColor = .gray
                submitStaffBtn.isEnabled = false
                submitStaffBtn.addTarget(self, action: #selector(submitStaffBtnAct), for: .touchUpInside)
                self.view.addSubview(submitStaffBtn)
                
                break
                
            default:
                break
            }
            
            
        }
        
        refreshUI()
        
    }
    
    
    //MARK: - 刷新UI
    func refreshUI(){
        if staffModel.CanUse == true {
            statusImageViewArr[0].image = selectStatusImage
            statusImageViewArr[1].image = unselectStatusImage
        }else{
            statusImageViewArr[1].image = selectStatusImage
            statusImageViewArr[0].image = unselectStatusImage
        }
        
        
        if staffModel.StaffName != nil {
            staffNameTexfield.text = staffModel.StaffName
        }
        
        
        if staffModel.Phone != nil {
            staffTelTexfield.text = staffModel.Phone
        }
        
    }
    
    
    //MARK: - 状态选择响应
    @objc func selectStatusBtnAct(sender:UIButton){
        
        for iamgeViewIndex in 0..<statusImageViewArr.count {
            if sender.tag - 200 == iamgeViewIndex {
                statusImageViewArr[iamgeViewIndex].image = selectStatusImage
                
            }else{
                statusImageViewArr[iamgeViewIndex].image = unselectStatusImage
                
            }
        }
        
        if sender.tag == 200 {
            staffCanUse = true
        }else{
            staffCanUse = false
        }
        
    }
    
    
    //MARK: - 提交修改
    @objc func  submitStaffBtnAct(){
        if staffNameTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请填写配送员的姓名")
            return
        }
        
        if staffTelTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty || staffTelTexfield.text!.isNotPerfectMatchTelNum() == false {
            cmShowHUDToWindow(message: "请填写正确的手机号码")
            return
        }
        
        if passWordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            cmShowHUDToWindow(message: "请输入密码")
            return
        }
        
        if passWordTextField.text!.trimmingCharacters(in: .whitespaces).count < 6 ||
            passWordTextField.text!.trimmingCharacters(in: .whitespaces).count > 20 {
            
            cmShowHUDToWindow(message: "密码格式不正确")
            return
            
        }
        
        submitStaffBtn.isEnabled = false
        service.updateStaffRequest(canUse: self.staffCanUse, staffName: staffNameTexfield.text!, staffID: staffModel.DStaffID, password: passWordTextField.text!, successAct: { [weak self] in
            DispatchQueue.main.async {
                let navVCCount = self!.navigationController!.viewControllers.count
                if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? StaffManageListVC {
                    lastVC.service.refreshStaffManagerListData(target: lastVC)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }) { [weak self] in
            self?.submitStaffBtn.isEnabled = true
        }
        
    }
    
    //MARK: - textfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        refreshSubmitBtnUI()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        refreshSubmitBtnUI()
    }
    
    
    //MARK: - 按钮状态变更
    func refreshSubmitBtnUI(){
        if  !staffNameTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty && !staffTelTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty && !passWordTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty && passWordTextField.text!.trimmingCharacters(in: .whitespaces).count >= 6 &&
            passWordTextField.text!.trimmingCharacters(in: .whitespaces).count < 20{
            submitStaffBtn.backgroundColor = MAIN_GREEN
            submitStaffBtn.isEnabled = true
        }else{
            submitStaffBtn.backgroundColor = .gray
            submitStaffBtn.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
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
