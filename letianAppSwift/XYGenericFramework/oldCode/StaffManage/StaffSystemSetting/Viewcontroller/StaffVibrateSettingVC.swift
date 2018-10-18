//
//  StaffVibrateSettingVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffVibrateSettingVC: UIViewController {
    
    let toside = cmSizeFloat(20)
    let chooseStrArr = ["开启","关闭"]
    let useVibrateImage = #imageLiteral(resourceName: "genderSelected")
    let unuseVibrateImage = #imageLiteral(resourceName: "genderUnselected")
    
    var topView:XYTopView!
    var headerTitleLabel:UILabel!
    var chooseImageViewArr:[UIImageView] = Array()
    
    var useVibrate:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        if isStaffOrderUseVibrate() == true {
            useVibrate =  true
        }else{
            useVibrate =  false
        }
        
        creatNavTopView()
        createSubViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "接单铃声设置"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - 创建子View
    func createSubViews(){
        
        let subViewHeight = cmSizeFloat(50)
        
        headerTitleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom, width: SCREEN_WIDTH, height: subViewHeight))
        headerTitleLabel.font = cmSystemFontWithSize(14)
        headerTitleLabel.textColor = MAIN_BLACK
        headerTitleLabel.textAlignment = .left
        headerTitleLabel.text = "接单铃声设置"
        self.view.addSubview(headerTitleLabel)
        
        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: headerTitleLabel.bottom - cmSizeFloat(1)))
        
        
        for index in 0..<chooseStrArr.count {
            
            let chooseView = UIView(frame: CGRect(x: 0, y: headerTitleLabel.bottom + CGFloat(index)*subViewHeight, width: SCREEN_WIDTH, height: subViewHeight))
            chooseView.backgroundColor = .white
            
            let selectImageView = UIImageView(frame: CGRect(x: toside, y: subViewHeight/2 - unuseVibrateImage.size.height/2, width: unuseVibrateImage.size.width, height: unuseVibrateImage.size.height))
            selectImageView.image = unuseVibrateImage
            chooseView.addSubview(selectImageView)
            chooseImageViewArr.append(selectImageView)
            
            let selectTitle = UILabel(frame: CGRect(x: selectImageView.right + toside, y: 0, width: SCREEN_WIDTH - toside*3 - unuseVibrateImage.size.width, height: subViewHeight))
            selectTitle.font = cmSystemFontWithSize(14)
            selectTitle.textColor = MAIN_BLACK
            selectTitle.textAlignment = .left
            selectTitle.text = chooseStrArr[index]
            chooseView.addSubview(selectTitle)
            
            
            chooseView.isUserInteractionEnabled = true
            let chooseViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(chooseViewTapgesture(sender:)))
            chooseView.addGestureRecognizer(chooseViewTapgesture)
            chooseView.tag = 200 + index
            
            self.view.addSubview(chooseView)
            
        }
        
        //提交按钮
        let btnHeight = cmSizeFloat(36)
        let saveBtn = UIButton(frame: CGRect(x: toside, y: cmSizeFloat(12) + headerTitleLabel.bottom + CGFloat(2)*subViewHeight, width: SCREEN_WIDTH - toside*2, height: btnHeight))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(MAIN_WHITE, for: .normal)
        saveBtn.titleLabel?.font = cmSystemFontWithSize(15)
        saveBtn.layer.cornerRadius = cmSizeFloat(4)
        saveBtn.clipsToBounds = true
        saveBtn.backgroundColor = MAIN_GREEN
        saveBtn.addTarget(self, action: #selector(saveBtnAct), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        
        
        if useVibrate == true {
            chooseImageViewArr[0].image =  useVibrateImage
        }else{
            chooseImageViewArr[1].image =  useVibrateImage
        }
        
    }
    
    
    //MARK: - 铃声设置选择响应
    @objc func chooseViewTapgesture(sender:UITapGestureRecognizer) {
        
        for index in 0..<chooseImageViewArr.count {
            
            if (sender.view!.tag - 200) == index {
                chooseImageViewArr[index].image =  useVibrateImage
            }else{
                chooseImageViewArr[index].image =  unuseVibrateImage
            }
            
        }
        
        
        if (sender.view!.tag - 200) == 0 {
            self.useVibrate = true
        }else{
            self.useVibrate = false
        }
        
        
    }
    
    //MARK: - 保存按钮响应
    @objc func saveBtnAct(){
        
        saveStaffVibrateSettingInfo(isUseVibrate: useVibrate)
        self.navigationController?.popViewController(animated: true)
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
