//
//  AddNewAdressVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/11/20.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class AddNewAdressVC: UIViewController {
    
    let subViewHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let subviewStrArr = ["姓名","性别","联系电话","校内地址",""]
    let genderStrArr = ["先生","女士"]
    let selectGenderImage = #imageLiteral(resourceName: "genderSelected")
    let unselectGenderImage = #imageLiteral(resourceName: "genderUnselected")
    
    var topView:XYTopView!
    var userNameTexfield:UITextField!
    var userTelTexfield:UITextField!
    var userDetailAdressTexfield:UITextField!
    var  mapLocationBtn:UIButton!
    var  submitAdressBtn:UIButton!


    var submitModel:AdressManageCellModel!
    var service:DeliveryAdressService =  DeliveryAdressService()
    
    var genderImageViewArr:[UIImageView] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if submitModel == nil {
            submitModel = AdressManageCellModel()
        }
        creatNavTopView()
        createSubViews()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        if  submitModel.userAddressID == nil{
            topView.titleLabel.text = "新增地址"
        }else{
            topView.titleLabel.text = "修改地址"
        }
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - 创建sbuview
    func createSubViews() {
        
        let textSpace = cmSizeFloat(10)

        
        for index  in 0..<subviewStrArr.count {
            
            let strWidth = subviewStrArr[3].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
            let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom +  subViewHeight*CGFloat(index), width: strWidth, height: subViewHeight))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            titleLabel.text = subviewStrArr[index]
            self.view.addSubview(titleLabel)
            
            self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: titleLabel.bottom - cmSizeFloat(1)))
            
            switch index {
            case 0:
                userNameTexfield = UITextField(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                userNameTexfield.placeholder = "请输入收货人姓名"
                userNameTexfield.font = cmSystemFontWithSize(15)
                userNameTexfield.textColor = MAIN_BLACK
                userNameTexfield.textAlignment = .left
                self.view.addSubview(userNameTexfield)
                break
            case 1:
                let genderImageToText = cmSizeFloat(4)
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
            case 2:
                userTelTexfield = UITextField(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                userTelTexfield.placeholder = "请输入收货人联系方式"
                userTelTexfield.font = cmSystemFontWithSize(15)
                userTelTexfield.textColor = MAIN_BLACK
                userTelTexfield.keyboardType = .numberPad
                userTelTexfield.textAlignment = .left
                self.view.addSubview(userTelTexfield)
                break
            case 3:
                 mapLocationBtn = UIButton(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                mapLocationBtn.setTitle("在地图中定位", for: .normal)
                mapLocationBtn.setTitleColor(MAIN_GRAY, for: .normal)
                mapLocationBtn.titleLabel?.font = cmSystemFontWithSize(15)
                mapLocationBtn.contentHorizontalAlignment = .left
                mapLocationBtn.addTarget(self, action: #selector(mapLocationBtnAc), for: .touchUpInside)
                self.view.addSubview(mapLocationBtn)
                break
            case 4:
                userDetailAdressTexfield = UITextField(frame: CGRect(x: titleLabel.right + textSpace, y: titleLabel.top, width: SCREEN_WIDTH - (titleLabel.right + textSpace + toside), height: subViewHeight))
                userDetailAdressTexfield.placeholder = "详细地址(如几号宿舍楼)"
                userDetailAdressTexfield.font = cmSystemFontWithSize(15)
                userDetailAdressTexfield.textColor = MAIN_BLACK
                userDetailAdressTexfield.textAlignment = .left
                self.view.addSubview(userDetailAdressTexfield)
                
                
                 submitAdressBtn = UIButton(frame: CGRect(x: toside, y: userDetailAdressTexfield.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: subViewHeight))
                submitAdressBtn.setTitle("确认提交", for: .normal)
                submitAdressBtn.setTitleColor(MAIN_WHITE, for: .normal)
                submitAdressBtn.titleLabel?.font = cmSystemFontWithSize(15)
                submitAdressBtn.layer.cornerRadius = cmSizeFloat(4)
                submitAdressBtn.clipsToBounds = true
                submitAdressBtn.backgroundColor = MAIN_BLUE
                submitAdressBtn.addTarget(self, action: #selector(submitAdressBtnAct), for: .touchUpInside)
                self.view.addSubview(submitAdressBtn)
                
                
                
                break
            default:
                break
            }
            
            
        }
        
        
        refreshUI()
        
    }
    
    
    //MARK: - 刷新UI
    func refreshUI(){
        if submitModel.userGender != nil {
            for iamgeViewIndex in 0..<genderImageViewArr.count {
                if submitModel.userGender == iamgeViewIndex + 1 {
                    genderImageViewArr[iamgeViewIndex].image = selectGenderImage
                }else{
                    genderImageViewArr[iamgeViewIndex].image = unselectGenderImage
                }
            }
        }
        if submitModel.userName != nil {
            userNameTexfield.text = submitModel.userName
        }
        if submitModel.userAdress != nil && !submitModel.userAdress.isEmpty {
            mapLocationBtn.setTitle(submitModel.userAdress, for: .normal)
        }
        
        if submitModel.ueserTel != nil {
            userTelTexfield.text = submitModel.ueserTel
        }
        
        if !submitModel.addressDetail.isEmpty {
            userDetailAdressTexfield.text = submitModel.addressDetail
        }
        
    }
    
    
    
    
    //MARK: - 提交按钮
    @objc func submitAdressBtnAct() {
        
        if userNameTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            cmShowHUDToWindow(message: "请填写您的姓名")
            return
        }
        
        if submitModel.userGender == nil{
            cmShowHUDToWindow(message: "请选择您的性别")
            return
        }
        
        if userTelTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty || userTelTexfield.text!.isNotPerfectMatchTelNum() == false {
            cmShowHUDToWindow(message: "请填写正确的手机号码")
            return
        }
        
        submitModel.userName = userNameTexfield.text!
        submitModel.ueserTel = userTelTexfield.text!
        
        if !userDetailAdressTexfield.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            submitModel.addressDetail = userDetailAdressTexfield.text!
        }
        submitAdressBtn.isEnabled = false
        //userAddressID不为空则为修改地址，否则为新增地址
        if submitModel.userAddressID == nil {
            service.addNewDeliveryAdressRequest(model: submitModel, successAct: { [weak self] in
                DispatchQueue.main.async {
                    self?.refreshAdressManagerVC()
                    self?.navigationController?.popViewController(animated: true)
                }
            }, failureAct: { [weak self] in
                DispatchQueue.main.async {
                self?.submitAdressBtn.isEnabled = true
                }

            })
        }else{
            service.updateDeliveryAdressRequest(model: submitModel, successAct: { [weak self] in
                DispatchQueue.main.async {
                    self?.refreshAdressManagerVC()
                    self?.navigationController?.popViewController(animated: true)
                }
            }, failureAct: { [weak self] in
                DispatchQueue.main.async {
                    self?.submitAdressBtn.isEnabled = true
                }
            })
        }
        
        
    }
    
    //MARK: - 刷新地址管理列表页数据
    func refreshAdressManagerVC(){
        
        let navVCCount = self.navigationController!.viewControllers.count
        //上一个界面时主页，选择则更新主页地址信息及位置
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? DeliveryAdressManagerVC {
            lastVC.mainTabView.mj_header.beginRefreshing()
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
            self.submitModel.userGender = 1
        }else{
            self.submitModel.userGender = 2
        }
        
    }
    
    //MARK: - 地图定位
    @objc func mapLocationBtnAc() {
        
        let mapLocationVC = MapLocationVC()
        self.navigationController?.pushViewController(mapLocationVC, animated: true)
        
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
