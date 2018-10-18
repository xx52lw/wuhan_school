//
//  OrderAddReciverVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/1/18.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class OrderAddReciverVC: UIViewController {

    let subViewHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let subviewStrArr = ["姓名","性别","联系电话"]
    let genderStrArr = ["先生","女士"]
    let selectGenderImage = #imageLiteral(resourceName: "genderSelected")
    let unselectGenderImage = #imageLiteral(resourceName: "genderUnselected")
    
    var topView:XYTopView!
    var userNameTexfield:UITextField!
    var userTelTexfield:UITextField!
    
    
    var selectedGender = -1
    var genderImageViewArr:[UIImageView] = Array()
    var service:OrderAddRecieverService = OrderAddRecieverService()
    
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
        topView.titleLabel.text = "新增收货人"
    }
    
    //MARK: - 创建sbuview
    func createSubViews() {
        
        let textSpace = cmSizeFloat(10)
        
        
        for index  in 0..<subviewStrArr.count {
            
            let strWidth = subviewStrArr[2].stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
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
                
                let submitAdressBtn = UIButton(frame: CGRect(x: toside, y: userTelTexfield.bottom + cmSizeFloat(20), width: SCREEN_WIDTH - toside*2, height: subViewHeight))
                submitAdressBtn.setTitle("确认提交", for: .normal)
                submitAdressBtn.setTitleColor(MAIN_WHITE, for: .normal)
                submitAdressBtn.titleLabel?.font = cmSystemFontWithSize(15)
                submitAdressBtn.layer.cornerRadius = cmSizeFloat(4)
                submitAdressBtn.clipsToBounds = true
                submitAdressBtn.backgroundColor = MAIN_GREEN
                submitAdressBtn.addTarget(self, action: #selector(submitAdressBtnAct(sender:)), for: .touchUpInside)
                self.view.addSubview(submitAdressBtn)
                break
            default:
                break
            }
            
            
        }
        
    }
    
    //MARK: - 提交
    @objc func submitAdressBtnAct(sender:UIButton) {
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
        
        service.addOrderRecieverRequest(userName: userNameTexfield.text!, gender: selectedGender, userTel: userTelTexfield.text!, successAct: { [weak self] in
            DispatchQueue.main.async {
                sender.isEnabled = true
                
                let navVCCount = self!.navigationController!.viewControllers.count
                if navVCCount > 3 {
                    if let needVC = self?.navigationController?.viewControllers[navVCCount - 3] as? OrderSubmitViewController {
                        let recieverModel = OrderRecieverSetModel()
                        recieverModel.IsDefault = false
                        recieverModel.isselected = false
                        recieverModel.UserName = self!.userNameTexfield.text!
                        recieverModel.PhoneNumber = self!.userTelTexfield.text!
                        recieverModel.Sex = self!.selectedGender
                        needVC.submiteModel.recieverArr.append(recieverModel)
                        
                        if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? OrderReciverSetVC {
                            lastVC.recieverArr.append(recieverModel)
                            lastVC.mainTabView.reloadData()
                        }
                    }
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
    
 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        
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
