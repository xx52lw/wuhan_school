//
//  BindingWechatViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class BindingWechatViewController: UIViewController {
    var topView:XYTopView!
    let logoSize = cmSizeFloat(72)
    let logoToTop = cmSizeFloat(50)
    let spaceSize = cmSizeFloat(25)
    let btnWidth = SCREEN_WIDTH/3
    let btnHeight = cmSizeFloat(38)

    var bindingBtn:UIButton!
    var cancelBindingBtn:UIButton!
    var bootomTipLabel:UILabel!
    
    var account:String!
    var password:String!
    
    var service:LoginRegisterService = LoginRegisterService()
    
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
        topView.titleLabel.text = "绑定微信"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //MARK: - 创建子View
    func createSubViews(){
        let logoImageView = UIImageView(frame: CGRect(x: (SCREEN_WIDTH - logoSize)/2 , y: topView.bottom + logoToTop, width: logoSize, height: logoSize))
        logoImageView.image = #imageLiteral(resourceName: "bindingWeiXin")
        self.view.addSubview(logoImageView)
        
        let bindingTisLabel = UILabel(frame: CGRect(x: 0, y: logoImageView.bottom + logoToTop, width: SCREEN_WIDTH, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(15))))
        bindingTisLabel.font = cmSystemFontWithSize(15)
        bindingTisLabel.textColor = MAIN_BLACK2
        bindingTisLabel.text = "是否绑定微信?"
        bindingTisLabel.textAlignment = .center
        self.view.addSubview(bindingTisLabel)
        
        bindingBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - SCREEN_WIDTH/3)/2, y: bindingTisLabel.bottom + spaceSize, width: SCREEN_WIDTH/3, height: btnHeight))
        bindingBtn.clipsToBounds = true
        bindingBtn.layer.cornerRadius = btnHeight/2
        bindingBtn.setTitle("绑 定", for: .normal)
        bindingBtn.setTitleColor(MAIN_WHITE, for: .normal)
        bindingBtn.titleLabel?.font = cmSystemFontWithSize(14)
        bindingBtn.backgroundColor = MAIN_BLUE
        bindingBtn.addTarget(self, action: #selector(bindingBtnAct), for: .touchUpInside)
        self.view.addSubview(bindingBtn)
        
        cancelBindingBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - SCREEN_WIDTH/3)/2, y: bindingBtn.bottom + spaceSize, width: SCREEN_WIDTH/3, height: btnHeight))
        cancelBindingBtn.clipsToBounds = true
        cancelBindingBtn.layer.cornerRadius = btnHeight/2
        cancelBindingBtn.setTitle("不绑定", for: .normal)
        cancelBindingBtn.setTitleColor(MAIN_WHITE, for: .normal)
        cancelBindingBtn.titleLabel?.font = cmSystemFontWithSize(14)
        cancelBindingBtn.backgroundColor = MAIN_BLUE
        cancelBindingBtn.addTarget(self, action: #selector(cancelBindingAct), for: .touchUpInside)
        self.view.addSubview(cancelBindingBtn)
        
        
        bootomTipLabel = UILabel(frame: CGRect(x: 0, y: cancelBindingBtn.bottom + spaceSize, width: SCREEN_WIDTH, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        bootomTipLabel.font = cmSystemFontWithSize(12)
        bootomTipLabel.textColor = MAIN_GRAY
        bootomTipLabel.text = "账户绑定微信后可直接用微信登录"
        bootomTipLabel.textAlignment = .center
        self.view.addSubview(bootomTipLabel)
        
    }
    
    
    //MARK: - 绑定
    @objc func bindingBtnAct() {
        service.bindingWechat(account: self.account, passWord: self.password)
    }
    
    //MARK: - 不绑定
    @objc func cancelBindingAct(){
         service.cancelBindingWechat(account: self.account, passWord: self.password)
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
