//
//  MerchantBusinnessSetVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantBusinnessSetVC: UIViewController {

    let selectSetImage = #imageLiteral(resourceName: "genderSelected")
    let unselectSetImage = #imageLiteral(resourceName: "genderUnselected")
    let selectedImageSize = cmSizeFloat(24)
    let chooseViewHeight = cmSizeFloat(50)
    let toside = cmSizeFloat(20)
    let chooseStrArr = ["营业","暂停营业"]
    
    var topView:XYTopView!
    var chooseImageViewsArr:[UIImageView] = Array()
    var selectedTag = -1
    var popView:XYNoDetailTipsAlertView!
    var saveSetBtn:UIButton!

    var service:BusinnessSettingService = BusinnessSettingService()
    
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
        topView.titleLabel.text = "经营设置"
    }
    
    //MARK: - 创建子View
    func createSubViews(){
        
        for index in 0..<chooseStrArr.count {
            
            let selectedImageView:UIImageView = UIImageView(frame: CGRect(x: toside, y: topView.bottom + chooseViewHeight*CGFloat(index) + chooseViewHeight/2 - selectedImageSize/2, width: selectedImageSize, height: selectedImageSize))
            selectedImageView.image = unselectSetImage
            chooseImageViewsArr.append(selectedImageView)
            self.view.addSubview(selectedImageView)
            
            let chooseTitlLabel =  UILabel(frame: CGRect(x: selectedImageView.right + toside, y: topView.bottom + chooseViewHeight*CGFloat(index), width: SCREEN_WIDTH - toside*3 - selectedImageSize, height: chooseViewHeight))
            chooseTitlLabel.font = cmSystemFontWithSize(14)
            chooseTitlLabel.textColor = MAIN_BLACK
            chooseTitlLabel.textAlignment = .left
            chooseTitlLabel.text = chooseStrArr[index]
            self.view.addSubview(chooseTitlLabel)
            
            let selectedBtn = UIButton(frame: CGRect(x: 0, y: topView.bottom + chooseViewHeight*CGFloat(index), width: SCREEN_WIDTH, height: chooseViewHeight))
            selectedBtn.tag = 200 + index
            selectedBtn.addTarget(self, action: #selector(chooseSetAct(sender:)), for: .touchUpInside)
            self.view.addSubview(selectedBtn)

            
        }

        self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: topView.bottom + chooseViewHeight*CGFloat(chooseStrArr.count)))
        
        let submitTipsLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom + chooseViewHeight*CGFloat(chooseStrArr.count), width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(35)))
        submitTipsLabel.font = cmSystemFontWithSize(12)
        submitTipsLabel.textColor = MAIN_BLACK2
        submitTipsLabel.textAlignment = .left
        submitTipsLabel.text = "操作暂停营业后，需要等待30分钟才能恢复营业"
        self.view.addSubview(submitTipsLabel)
        
         let saveBtnHeight = cmSizeFloat(40)
         saveSetBtn = UIButton(frame: CGRect(x: toside, y: submitTipsLabel.bottom, width: SCREEN_WIDTH - toside*2, height: saveBtnHeight))
         saveSetBtn.setTitle("保 存", for: .normal)
         saveSetBtn.setTitleColor(MAIN_WHITE, for: .normal)
         saveSetBtn.titleLabel?.font = cmSystemFontWithSize(15)
         saveSetBtn.layer.cornerRadius = cmSizeFloat(4)
         saveSetBtn.clipsToBounds = true
         saveSetBtn.backgroundColor = MAIN_GREEN
         saveSetBtn.addTarget(self, action: #selector(saveSetBtnAct), for: .touchUpInside)
         self.view.addSubview(saveSetBtn)
        
        
    }
    
    
    //MARK: - 选择按钮响应
    @objc func chooseSetAct(sender:UIButton){
        for iamgeViewIndex in 0..<chooseImageViewsArr.count {
            if sender.tag - 200 == iamgeViewIndex {
                chooseImageViewsArr[iamgeViewIndex].image = selectSetImage
            }else{
                chooseImageViewsArr[iamgeViewIndex].image = unselectSetImage
            }
        }
        selectedTag = sender.tag
    }
    
    
    //MARK: - 保存设置按钮响应
    @objc func saveSetBtnAct(){
        switch selectedTag {
        case 200:
            
            popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "是否要开启营业？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
                
            }, certainClosure: { [weak self] in
                self?.saveSetBtn.isEnabled = false
                self?.service.businessActRequest(type: 0, successAct: {
                    cmShowHUDToWindow(message: "已开启营业")
                    let navVCCount = self!.navigationController!.viewControllers.count
                    if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? MerchantManagerHomepageVC {
                        lastVC.service.getMerchantManagerHomepageRequest(target: lastVC)
                    }
                    self?.navigationController?.popViewController(animated: true)
                }, failureAct: {
                    self?.saveSetBtn.isEnabled = true

                })

            })
            popView.showInView(view: self.view)
            break
        case 201:
            
            popView = XYNoDetailTipsAlertView(frame: .zero, titleStr: "是否要暂停营业？", cancelStr: "取消", certainStr: "确定", cancelBtnClosure: {
                
            }, certainClosure: { [weak self] in
                self?.saveSetBtn.isEnabled = false
                self?.service.businessActRequest(type: 1, successAct: {
                    cmShowHUDToWindow(message: "已暂停营业")
                    let navVCCount = self!.navigationController!.viewControllers.count
                    if  let lastVC = self?.navigationController?.viewControllers[navVCCount - 2] as? MerchantManagerHomepageVC {
                        lastVC.service.getMerchantManagerHomepageRequest(target: lastVC)
                    }
                    self?.navigationController?.popViewController(animated: true)
                }, failureAct: {
                    self?.saveSetBtn.isEnabled = true

                })
                
            })
            popView.showInView(view: self.view)
            

            break
        default:
            break
        }
        
        
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
