//
//  LoginViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/12/31.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

typealias LoginSuccess = ()->Void

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    let logoSize = cmSizeFloat(70)
    let btnSizeWidth = SCREEN_WIDTH*3/4
    let btnSizeHeight = cmSizeFloat(32)
    let textFieldWidth = SCREEN_WIDTH*3/4
    let textFieldHeight = cmSizeFloat(32)
    let btnSpace = cmSizeFloat(22)
    let wxLogoSize = cmSizeFloat(54)
    let logoToTop = cmSizeFloat(30)
    let weixinBottomTipsToBottom = cmSizeFloat(80)
    
    let weixinBottomTipsStr = "账号绑定微信后可直接登录"
    let weixinLoginTipStr = "微信直接登录"
    
    var topView:XYTopView!
    var accountTextField:UITextField!
    var passWordTextField:UITextField!
    var logingBtn:UIButton!
    var visitorBtn:UIButton!
    var registerBtn:UIButton!
    var weixinLoginBtn:UIButton!
    var weixinLoginTipLabel:UILabel!
    var weixinBottomTipsLabel:UILabel!
    
    var loginService:LoginRegisterService = LoginRegisterService()
    
    var loginSucessClosure:LoginSuccess!
    
    //是否close 游客显示
    var isCloseVister =  false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createSubViews()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - 创建subviews
    func createSubViews(){
        
//        let logoImageView = UIImageView(frame: CGRect(x: (SCREEN_WIDTH - logoSize)/2 , y: topView.bottom + logoToTop, width: logoSize, height: logoSize))
//        logoImageView.image = #imageLiteral(resourceName: "loginLogo")
//        self.view.addSubview(logoImageView)
        
        //账号
        accountTextField = UITextField(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: topView.bottom + logoToTop, width: textFieldWidth, height: textFieldHeight))
        self.view.addSubview(accountTextField)
        accountTextField.clipsToBounds = true
        accountTextField.layer.cornerRadius = textFieldHeight/2
        accountTextField.layer.borderWidth = CGFloat(1)
        accountTextField.layer.borderColor = MAIN_GRAY.cgColor
        accountTextField.font = cmSystemFontWithSize(13)
        accountTextField.textColor = MAIN_BLACK
        accountTextField.backgroundColor = MAIN_WHITE
        accountTextField.returnKeyType = .done
        accountTextField.delegate = self
        
        let textFieldTitleToleftsize = cmSizeFloat(12)
        let accountTitleStr = "账号 :"
        let accountTitleWidth = accountTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        let accountLeftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldTitleToleftsize + accountTitleWidth + cmSizeFloat(5), height: textFieldHeight))
        let accountLeftLabel = UILabel(frame: CGRect(x: textFieldTitleToleftsize, y: 0, width: accountTitleWidth, height: textFieldHeight))
        accountLeftLabel.font = cmSystemFontWithSize(13)
        accountLeftLabel.textColor = MAIN_BLACK
        accountLeftLabel.text = accountTitleStr
        accountLeftView.addSubview(accountLeftLabel)
        
        accountTextField.leftView = accountLeftView
        accountTextField.leftViewMode = .always
        
        //密码
        passWordTextField = UITextField(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: accountTextField.bottom + btnSpace, width: textFieldWidth, height: textFieldHeight))
        self.view.addSubview(passWordTextField)
        passWordTextField.clipsToBounds = true
        passWordTextField.layer.cornerRadius = textFieldHeight/2
        passWordTextField.layer.borderWidth = CGFloat(1)
        passWordTextField.layer.borderColor = MAIN_GRAY.cgColor
        passWordTextField.font = cmSystemFontWithSize(13)
        passWordTextField.textColor = MAIN_BLACK
        passWordTextField.backgroundColor = MAIN_WHITE
        passWordTextField.returnKeyType = .done
        passWordTextField.delegate = self
        passWordTextField.isSecureTextEntry = true
        
        let passwordTitleStr = "密码 :"
        let passwordTitleWidth = passwordTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: textFieldTitleToleftsize + passwordTitleWidth + cmSizeFloat(5), height: textFieldHeight))
        let passwordLeftLabel = UILabel(frame: CGRect(x: textFieldTitleToleftsize, y: 0, width: passwordTitleWidth, height: textFieldHeight))
        passwordLeftLabel.font = cmSystemFontWithSize(13)
        passwordLeftLabel.textColor = MAIN_BLACK
        passwordLeftLabel.text = passwordTitleStr
        passwordLeftView.addSubview(passwordLeftLabel)
        
        passWordTextField.leftView = passwordLeftView
        passWordTextField.leftViewMode = .always
        
        
        //用户协议
        let btnTitleStr = "登录即代表阅读并同意用户协议"
        let userProtocolBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: passWordTextField.bottom + btnSpace*3/5, width: textFieldWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        userProtocolBtn.setTitleColor(MAIN_BLACK, for: .normal)
        let blueWordRange:NSRange = NSMakeRange(btnTitleStr.count - 4, 4)
        let blueWordString = NSMutableAttributedString(string: btnTitleStr as String)
        blueWordString.addAttribute(NSAttributedStringKey.foregroundColor, value: MAIN_BLUE, range: blueWordRange)
        userProtocolBtn.setAttributedTitle(blueWordString, for: .normal)
        userProtocolBtn.titleLabel?.font = cmSystemFontWithSize(12)
        userProtocolBtn.addTarget(self, action: #selector(userProtocolBtnAct), for: .touchUpInside)
        self.view.addSubview(userProtocolBtn)
        
        
        //登录
        logingBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: userProtocolBtn.bottom + btnSpace*3/5, width: textFieldWidth, height: textFieldHeight))
        logingBtn.clipsToBounds = true
        logingBtn.layer.cornerRadius = textFieldHeight/2
        logingBtn.setTitle("登  录", for: .normal)
        logingBtn.setTitleColor(MAIN_WHITE, for: .normal)
        logingBtn.titleLabel?.font = cmSystemFontWithSize(15)
        logingBtn.backgroundColor = MAIN_BLUE
        logingBtn.addTarget(self, action: #selector(logingBtnAct), for: .touchUpInside)

        self.view.addSubview(logingBtn)

        //注册
        registerBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: logingBtn.bottom + btnSpace, width: textFieldWidth, height: textFieldHeight))
        registerBtn.clipsToBounds = true
        registerBtn.layer.cornerRadius = textFieldHeight/2
        registerBtn.setTitle("注  册", for: .normal)
        registerBtn.setTitleColor(MAIN_BLACK, for: .normal)
        registerBtn.titleLabel?.font = cmSystemFontWithSize(15)
        registerBtn.clipsToBounds = true
        registerBtn.layer.cornerRadius = textFieldHeight/2
        registerBtn.layer.borderColor = MAIN_BLUE.cgColor
        registerBtn.layer.borderWidth = CGFloat(1)
        registerBtn.addTarget(self, action: #selector(registerBtnAct), for: .touchUpInside)

        self.view.addSubview(registerBtn)
        
        //注册
        visitorBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - textFieldWidth)/2, y: registerBtn.bottom + btnSpace, width: textFieldWidth, height: textFieldHeight))
        visitorBtn.clipsToBounds = true
        visitorBtn.layer.cornerRadius = textFieldHeight/2
        visitorBtn.setTitle("游客进入", for: .normal)
        visitorBtn.setTitleColor(MAIN_BLUE, for: .normal)
        visitorBtn.titleLabel?.font = cmSystemFontWithSize(15)
        visitorBtn.addTarget(self, action: #selector(visitorBtnAct), for: .touchUpInside)
        visitorBtn.isHidden = isCloseVister
        
        self.view.addSubview(visitorBtn)
        
        
        //微信登录底部按钮提示
        weixinBottomTipsLabel = UILabel(frame: CGRect(x: 0, y: SCREEN_HEIGHT - weixinBottomTipsToBottom - cmSingleLineHeight(fontSize: cmSystemFontWithSize(12)), width: SCREEN_WIDTH, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(12))))
        weixinBottomTipsLabel.font = cmSystemFontWithSize(12)
        weixinBottomTipsLabel.textColor = MAIN_GRAY
        weixinBottomTipsLabel.text = weixinBottomTipsStr
        weixinBottomTipsLabel.textAlignment = .center
        self.view.addSubview(weixinBottomTipsLabel)
        
        //微信登录按钮
        let bottomTipsToWxLogin = cmSizeFloat(12)
        weixinLoginBtn = UIButton(frame: CGRect(x: (SCREEN_WIDTH - wxLogoSize)/2 , y: weixinBottomTipsLabel.top -  bottomTipsToWxLogin - wxLogoSize, width: wxLogoSize, height: wxLogoSize))
        weixinLoginBtn.setImage(#imageLiteral(resourceName: "wechatImage"), for: .normal)
        weixinLoginBtn.addTarget(self, action: #selector(weixinLoginBtnAct), for: .touchUpInside)
        self.view.addSubview(weixinLoginBtn)

        //微信登录按钮上的tips
        let topTipsToWxLogin = cmSizeFloat(14)
        let weixinLoginTipStrWidth = weixinLoginTipStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(14)), font: cmSystemFontWithSize(14))
        weixinLoginTipLabel = UILabel(frame: CGRect(x: (SCREEN_WIDTH - weixinLoginTipStrWidth - cmSizeFloat(20))/2, y:weixinLoginBtn.top - topTipsToWxLogin - cmSingleLineHeight(fontSize: cmSystemFontWithSize(20)), width: weixinLoginTipStrWidth + cmSizeFloat(20), height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))))
        weixinLoginTipLabel.font = cmSystemFontWithSize(14)
        weixinLoginTipLabel.textColor = MAIN_BLACK2
        weixinLoginTipLabel.text = weixinLoginTipStr
        weixinLoginTipLabel.textAlignment = .center
        self.view.addSubview(weixinLoginTipLabel)
        

        
        let leftSeperateLine = UIView(frame: CGRect(x: 0, y: weixinLoginTipLabel.top +  cmSingleLineHeight(fontSize: cmSystemFontWithSize(14))/2, width: (SCREEN_WIDTH - weixinLoginTipStrWidth - cmSizeFloat(20))/2, height: cmSizeFloat(1)))
        leftSeperateLine.backgroundColor =  seperateLineColor
        self.view.addSubview(leftSeperateLine)
        
        let rightSeperateLine = UIView(frame: CGRect(x: weixinLoginTipLabel.right, y: leftSeperateLine.top, width: leftSeperateLine.size.width, height: cmSizeFloat(1)))
        rightSeperateLine.backgroundColor =  seperateLineColor
        self.view.addSubview(rightSeperateLine)

        //如果没有安装微信，隐藏微信登录界面
        if UIApplication.shared.canOpenURL(URL.init(string: "weixin://")!) == false {
            weixinLoginBtn.isHidden = true
            weixinLoginTipLabel.isHidden = true
            leftSeperateLine.isHidden = true
            rightSeperateLine.isHidden = true
            weixinBottomTipsLabel.isHidden = true
        }
        
    }
    
    //MARK: - 用户协议
    @objc func userProtocolBtnAct(){
        
        let userProtocolWebVC = XYWebViewController()
        userProtocolWebVC.urlString = "https://xy.ltedu.net/page/protocol_user.html"
        userProtocolWebVC.titleStr = "用户协议"
        self.navigationController?.pushViewController(userProtocolWebVC, animated: true)
        
    }
    
    //MARK:- 微信登录
    @objc func weixinLoginBtnAct() {
        clickWechatIsBinding = false
        ltWechatAuth()
    }
    
    //MARK:- 登录
    @objc func logingBtnAct() {
        
        self.view.endEditing(true)
        
        if accountTextField.text!.isEmpty {
            cmShowHUDToWindow(message: "账号不能为空")
            return
        }
        if passWordTextField.text!.isEmpty {
            cmShowHUDToWindow(message: "密码不能为空")
            return
        }
        
        logingBtn.isEnabled = false
        
        loginService.loginByAccount(account: accountTextField.text!, passWord: passWordTextField.text!, loginSuccessAct: { [weak self] in
            DispatchQueue.main.async {
                self?.logingBtn.isEnabled = true
            }
            if self?.loginSucessClosure != nil {
                self?.loginSucessClosure()
            }else{
                //MARK: - 如果根视图是首页，则刷新首页数据
                if getUserRole() == .User {
                    if  let rootVC =  GetCurrentViewController()?.navigationController?.viewControllers.first as? TakeOutFoodVC{
                        rootVC.service.takefoodOutDataRequest(target: rootVC)
                    }
                    self?.navigationController?.popToRootViewController(animated: true)

                }else{
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }) { [weak self] in
            DispatchQueue.main.async {
                self?.logingBtn.isEnabled = true
            }
        }
    }
    //MARK:- 注册
    @objc func registerBtnAct() {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK: - 游客登录
    @objc func visitorBtnAct() {
        visitorBtn.isEnabled = false
        removeLoginInfo()
        removeTokenInfo()
        loginService.loginByAccount(account: "guest", passWord: "1011", loginSuccessAct: { [weak self] in
            DispatchQueue.main.async {
                self?.visitorBtn.isEnabled = true
            }
            //MARK: - 如果根视图是首页，则刷新首页数据
            if getUserRole() == .Guest {
                if  let rootVC =  GetCurrentViewController()?.navigationController?.viewControllers.first as? TakeOutFoodVC{
                    rootVC.service.takefoodOutDataRequest(target: rootVC)
                    self?.navigationController?.popToRootViewController(animated: true)
                }else{
                    let navVCCount = self!.navigationController!.viewControllers.count
                    //上一个界面是含退出登录的页面则退回根视图
                    if  let _ = self?.navigationController?.viewControllers[navVCCount - 2] as? UserCenterSettingVC {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
                
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }) { [weak self] in
            DispatchQueue.main.async {
                self?.visitorBtn.isEnabled = true
            }
        }
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem())
        topView.titleLabel.text = "登录"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
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
        //禁止系统手势右滑返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //打开系统手势右滑返回
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
