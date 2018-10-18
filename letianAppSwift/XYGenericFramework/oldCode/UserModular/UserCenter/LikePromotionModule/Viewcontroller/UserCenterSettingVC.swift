//
//  UserCenterSettingVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/2.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class UserCenterSettingVC: UIViewController {

    private let subViewHeight = cmSizeFloat(50)
    private let toside = cmSizeFloat(20)
    private let subViewLabelStrArr = ["清除本地缓存","关于我们"]//["清除本地缓存","版本更新","关于我们"]
    private let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    private  var topView:XYTopView!

    
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
        topView.titleLabel.text = "设置"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    

    //MARK:  - 创建子View
    func createSubViews() {
        
        for index in 0..<subViewLabelStrArr.count {
            
            let titleLabel = UILabel(frame: CGRect(x: toside, y: topView.bottom + CGFloat(index)*subViewHeight, width: SCREEN_WIDTH - showMoreImage.size.width - toside*3, height: subViewHeight))
            titleLabel.font = cmSystemFontWithSize(15)
            titleLabel.textColor = MAIN_BLACK
            titleLabel.textAlignment = .left
            titleLabel.text = subViewLabelStrArr[index]
            self.view.addSubview(titleLabel)
            
            let showMoreBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - showMoreImage.size.width - toside*2, y: titleLabel.top, width: showMoreImage.size.width + toside*2, height: subViewHeight))
            showMoreBtn.setImage(showMoreImage, for: .normal)
            showMoreBtn.addTarget(self, action: #selector(showMoreBtnAct(sender:)), for: .touchUpInside)
            showMoreBtn.tag = 200 + index
            self.view.addSubview(showMoreBtn)
            
            
            self.view.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: showMoreBtn.bottom - CGFloat(1)))
            
            if index == subViewLabelStrArr.count - 1 {
                let loginOutBtn = UIButton(frame: CGRect(x: 0, y: showMoreBtn.bottom + cmSizeFloat(20), width: SCREEN_WIDTH, height: cmSizeFloat(36)))
                loginOutBtn.setTitle("退出登录", for: .normal)
                loginOutBtn.setTitleColor(MAIN_BLUE, for: .normal)
                loginOutBtn.titleLabel?.font = cmSystemFontWithSize(15)
                loginOutBtn.backgroundColor = .white
                
                loginOutBtn.addTarget(self, action: #selector(loginOutBtnAct), for: .touchUpInside)
                self.view.addSubview(loginOutBtn)
            }
        }
        
    }
    
    
    //MARK: - 退出登录响应
    @objc func loginOutBtnAct(){
        loginOutApp()
    }
    
    
    //MARK: - 更多按钮响应
    @objc func showMoreBtnAct(sender:UIButton) {
        
        switch sender.tag {
        case 200:
            CleanCache {
                cmShowHUDToWindow(message: "缓存已清除")
            }
            break
        case 201:
            break
        case 202:
            break
        default:
            break
        }
        
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
