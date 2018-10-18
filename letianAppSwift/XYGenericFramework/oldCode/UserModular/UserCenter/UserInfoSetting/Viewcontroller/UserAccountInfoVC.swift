//
//  UserAccountInfoVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2018/1/6.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class UserAccountInfoVC: UIViewController,UITextFieldDelegate {

    let avatarViewHeight = cmSizeFloat(70)
    let subViewHeight = cmSizeFloat(50)
    let sectionViewHeight = cmSizeFloat(28)
    let toside = cmSizeFloat(20)
    let titleStrMaxWidth = "登录密码".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))

    let showMoreImage = #imageLiteral(resourceName: "sellerDetailShowMore")
    
    var topView:XYTopView!
    var avatarBtn:UIButton!
    var mianScrollView:UIScrollView!
    var userNickNameTexfield:UITextField!
    var accountSettingTextfield:UITextField!
    var passwordSettingTextfield:UITextField!
    var areaSettingTextfield:UITextField!
    var bindingSetingTextfield:UITextField!
    
    
    var settingInfoModel:UserInfoSettingModel!
    var service:UserInfoModifyService = UserInfoModifyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = seperateLineColor
        creatNavTopView()
        createSubViews()
        service.userInfoRequest(target: self)
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "账户信息"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    
    //创建子View
    func createSubViews(){
        createMainScrollView()
        createAvatarNickName()
        createInfoSettingView()
        createAreaSettingView()
        createAccountBindingView()
    }
    
    //MARK: - 创建mainscrollView
    func createMainScrollView(){
        mianScrollView = UIScrollView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - topView.bottom))
        mianScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - topView.bottom)
        mianScrollView.isPagingEnabled = false
        mianScrollView.bounces = true
        mianScrollView.backgroundColor = cmColorWithString(colorName: "ffffff")
        mianScrollView.showsVerticalScrollIndicator = false
        mianScrollView.showsHorizontalScrollIndicator = false

        self.view.addSubview(mianScrollView)
    }
    
    //MARK: - 创建用户名及头像
    func createAvatarNickName(){
        //头像
        let avartarView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: avatarViewHeight))
        let avatarTitleStr = "头像"
        let avaterSize = cmSizeFloat(50)
        let strWidth = avatarTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(15)), font: cmSystemFontWithSize(15))
        let avatarTitleLabel = UILabel(frame: CGRect(x: toside, y: 0, width: strWidth, height: avatarViewHeight))
        avatarTitleLabel.font = cmSystemFontWithSize(15)
        avatarTitleLabel.textColor = MAIN_BLACK
        avatarTitleLabel.textAlignment = .left
        avatarTitleLabel.text = avatarTitleStr
        avartarView.addSubview(avatarTitleLabel)
        
        let showMoreBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - toside*2  - showMoreImage.size.width, y: 0, width: toside*2  +  showMoreImage.size.width, height: avatarViewHeight))
        showMoreBtn.setImage(showMoreImage, for: .normal)
        avartarView.addSubview(showMoreBtn)
        
        avatarBtn = UIButton(frame: CGRect(x: showMoreBtn.left - avaterSize, y: (avatarViewHeight - avaterSize)/2, width: avaterSize, height: avaterSize))
        avatarBtn.clipsToBounds = true
        avatarBtn.layer.cornerRadius = avaterSize/2
        avartarView.addSubview(avatarBtn)
        
        avartarView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: avartarView.bottom - cmSizeFloat(1)))
        
        mianScrollView.addSubview(avartarView)
        //用户名
        let titleLabel = UILabel(frame: CGRect(x: toside, y: avartarView.bottom, width: titleStrMaxWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "用户名"
        mianScrollView.addSubview(titleLabel)
        
        userNickNameTexfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - toside - titleStrMaxWidth , height: subViewHeight))
        userNickNameTexfield.font = cmSystemFontWithSize(15)
        userNickNameTexfield.textColor = MAIN_GRAY
        userNickNameTexfield.textAlignment = .right
        
        let showMoreImageView = UIImageView(frame: CGRect(x: userNickNameTexfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        userNickNameTexfield.rightView = showMoreImageView
        userNickNameTexfield.rightViewMode = .always
        userNickNameTexfield.delegate = self
        mianScrollView.addSubview(userNickNameTexfield)
        
    }
    //MARK: - 账户设置
    func createInfoSettingView(){
        
        let accountSettingTitleView =  UIView(frame: CGRect(x:0 , y: userNickNameTexfield.bottom, width: SCREEN_WIDTH, height: sectionViewHeight))
        accountSettingTitleView.backgroundColor = seperateLineColor
        let accountSettingLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH-toside, height: sectionViewHeight))
        accountSettingLabel.font = cmSystemFontWithSize(13)
        accountSettingLabel.textColor = MAIN_BLACK2
        accountSettingLabel.textAlignment = .left
        accountSettingLabel.text = "账户设置"
        accountSettingTitleView.addSubview(accountSettingLabel)
        mianScrollView.addSubview(accountSettingTitleView)

        
        //账户设置
        let titleLabel = UILabel(frame: CGRect(x: toside, y: accountSettingTitleView.bottom, width: titleStrMaxWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "账户设置"
        mianScrollView.addSubview(titleLabel)
        
        accountSettingTextfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - toside - titleStrMaxWidth , height: subViewHeight))
        accountSettingTextfield.font = cmSystemFontWithSize(15)
        accountSettingTextfield.textColor = MAIN_GRAY
        accountSettingTextfield.textAlignment = .right
        
        let showMoreImageView = UIImageView(frame: CGRect(x: accountSettingTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        accountSettingTextfield.rightView = showMoreImageView
        accountSettingTextfield.rightViewMode = .always
        accountSettingTextfield.delegate = self
        accountSettingTextfield.text = "修改"
        mianScrollView.addSubview(accountSettingTextfield)
        
        mianScrollView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: accountSettingTextfield.bottom - cmSizeFloat(1)))
        
        //密码设置
        let passwordTitleLabel = UILabel(frame: CGRect(x: toside, y: accountSettingTextfield.bottom, width: titleStrMaxWidth, height: subViewHeight))
        passwordTitleLabel.font = cmSystemFontWithSize(15)
        passwordTitleLabel.textColor = MAIN_BLACK
        passwordTitleLabel.textAlignment = .left
        passwordTitleLabel.text = "登录密码"
        mianScrollView.addSubview(passwordTitleLabel)
        
        passwordSettingTextfield = UITextField(frame: CGRect(x: passwordTitleLabel.right, y: passwordTitleLabel.top, width: SCREEN_WIDTH - toside - titleStrMaxWidth , height: subViewHeight))
        passwordSettingTextfield.font = cmSystemFontWithSize(15)
        passwordSettingTextfield.textColor = MAIN_GRAY
        passwordSettingTextfield.textAlignment = .right
        
        let passwordShowMoreImageView = UIImageView(frame: CGRect(x: passwordSettingTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        passwordShowMoreImageView.image = showMoreImage
        passwordShowMoreImageView.contentMode = .scaleAspectFit
        passwordSettingTextfield.rightView = passwordShowMoreImageView
        passwordSettingTextfield.rightViewMode = .always
        passwordSettingTextfield.delegate = self
        passwordSettingTextfield.text = "修改"
        mianScrollView.addSubview(passwordSettingTextfield)
        
        
    }
    //MARK: - 区域设置
    func createAreaSettingView(){
        let areaSettingTitleView =  UIView(frame: CGRect(x:0 , y: passwordSettingTextfield.bottom, width: SCREEN_WIDTH, height: sectionViewHeight))
        areaSettingTitleView.backgroundColor = seperateLineColor
        let areaSettingLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH-toside, height: sectionViewHeight))
        areaSettingLabel.font = cmSystemFontWithSize(13)
        areaSettingLabel.textColor = MAIN_BLACK2
        areaSettingLabel.textAlignment = .left
        areaSettingLabel.text = "区域设置"
        areaSettingTitleView.addSubview(areaSettingLabel)
        mianScrollView.addSubview(areaSettingTitleView)
        
        
        //区域设置
        let titleLabel = UILabel(frame: CGRect(x: toside, y: areaSettingTitleView.bottom, width: titleStrMaxWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "区域设置"
        mianScrollView.addSubview(titleLabel)
        
        areaSettingTextfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - toside - titleStrMaxWidth , height: subViewHeight))
        areaSettingTextfield.font = cmSystemFontWithSize(15)
        areaSettingTextfield.textColor = MAIN_GRAY
        areaSettingTextfield.textAlignment = .right
        
        let showMoreImageView = UIImageView(frame: CGRect(x: accountSettingTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        areaSettingTextfield.rightView = showMoreImageView
        areaSettingTextfield.rightViewMode = .always
        areaSettingTextfield.delegate = self
        areaSettingTextfield.text = "修改"
        mianScrollView.addSubview(areaSettingTextfield)
    }
    //MARK: - 账号绑定
    func createAccountBindingView(){
        let bindingSettingTitleView =  UIView(frame: CGRect(x:0 , y: areaSettingTextfield.bottom, width: SCREEN_WIDTH, height: sectionViewHeight))
        bindingSettingTitleView.backgroundColor = seperateLineColor
        let bindingSettingLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH-toside, height: sectionViewHeight))
        bindingSettingLabel.font = cmSystemFontWithSize(13)
        bindingSettingLabel.textColor = MAIN_BLACK2
        bindingSettingLabel.textAlignment = .left
        bindingSettingLabel.text = "账号绑定"
        bindingSettingTitleView.addSubview(bindingSettingLabel)
        mianScrollView.addSubview(bindingSettingTitleView)
        
        
        //账号绑定
        
        let wxImageView = UIImageView(frame: CGRect(x: toside, y: bindingSettingTitleView.bottom + (subViewHeight - cmSizeFloat(30))/2, width: cmSizeFloat(30), height: cmSizeFloat(30)))
        wxImageView.clipsToBounds = true
        wxImageView.layer.cornerRadius = subViewHeight/2
        wxImageView.image = #imageLiteral(resourceName: "wechatImage")
        mianScrollView.addSubview(wxImageView)

        
        let titleLabel = UILabel(frame: CGRect(x: wxImageView.right, y: bindingSettingTitleView.bottom, width: titleStrMaxWidth, height: subViewHeight))
        titleLabel.font = cmSystemFontWithSize(15)
        titleLabel.textColor = MAIN_BLACK
        titleLabel.textAlignment = .left
        titleLabel.text = "微信"
        mianScrollView.addSubview(titleLabel)
        
        bindingSetingTextfield = UITextField(frame: CGRect(x: titleLabel.right, y: titleLabel.top, width: SCREEN_WIDTH - titleLabel.right , height: subViewHeight))
        bindingSetingTextfield.font = cmSystemFontWithSize(15)
        bindingSetingTextfield.textColor = MAIN_GRAY
        bindingSetingTextfield.textAlignment = .right
        
        let showMoreImageView = UIImageView(frame: CGRect(x: bindingSetingTextfield.frame.size.width - toside*2 - showMoreImage.size.width, y: subViewHeight/2 - showMoreImage.size.height/2, width: showMoreImage.size.width + toside*2, height: showMoreImage.size.height))
        showMoreImageView.image = showMoreImage
        showMoreImageView.contentMode = .scaleAspectFit
        bindingSetingTextfield.rightView = showMoreImageView
        bindingSetingTextfield.rightViewMode = .always
        bindingSetingTextfield.delegate = self
        bindingSetingTextfield.text = "已绑定"
        mianScrollView.addSubview(bindingSetingTextfield)
        
        mianScrollView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY: bindingSetingTextfield.bottom - cmSizeFloat(1)))
    }
    
    
    //MARK: - UI刷新
    func refreshSubviewsUI() {
        if let avatarUrl = URL.init(string: settingInfoModel.avatarUrl){
            avatarBtn.sd_setImage(with: avatarUrl, for: .normal, placeholderImage: #imageLiteral(resourceName: "mineAvatarPlaceHolder"))
        }else{
            avatarBtn.setImage(#imageLiteral(resourceName: "mineAvatarPlaceHolder"), for: .normal)
        }
        userNickNameTexfield.text = settingInfoModel.nickName
        
        if settingInfoModel.hasWechat == true {
            bindingSetingTextfield.text = "已绑定"
            bindingSetingTextfield.textColor = MAIN_GRAY
        }else{
            bindingSetingTextfield.text = "未绑定"
            bindingSetingTextfield.textColor = MAIN_BLUE
        }
        
    }
    
    //MARK: - delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == userNickNameTexfield {
            let userNameVC = UserNameSettingVC()
            userNameVC.userSettingInfoModel = self.settingInfoModel
            self.navigationController?.pushViewController(userNameVC, animated: true)
            return false
        }else if textField ==  accountSettingTextfield{
            let accountSettingVC = AccountSettingVC()
            accountSettingVC.userSettingInfoModel = self.settingInfoModel
            self.navigationController?.pushViewController(accountSettingVC, animated: true)
            return false
        }else if textField ==  passwordSettingTextfield{
            let passwordSettingVC = PasswordSettingVC()
            passwordSettingVC.userSettingInfoModel = self.settingInfoModel
            self.navigationController?.pushViewController(passwordSettingVC, animated: true)
            return false
        }else if textField ==  areaSettingTextfield{
            let areaSettingVC = AreaSettingVC()
            areaSettingVC.userSettingInfoModel = self.settingInfoModel
            self.navigationController?.pushViewController(areaSettingVC, animated: true)
            return false
        }else if textField ==  bindingSetingTextfield {
            if settingInfoModel.hasWechat == false {
                clickWechatIsBinding = true
                //调起微信
                ltWechatAuth()
            }else{
                cmShowHUDToWindow(message: "当前用户已绑定微信")
            }
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
