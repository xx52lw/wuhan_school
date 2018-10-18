//
//  UserCenterViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/8.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SDWebImage
class UserCenterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    let avatarToTop = cmSizeFloat(20)
    let toside = cmSizeFloat(20)
    let tableHeaderUserViewSize = cmSizeFloat(105)
    let tableHeaderViewHeight = cmSizeFloat(105+85+100+7+7)
    let showMoreBtnSize = cmSizeFloat(44)
    let sectionHeaderHeight = cmSizeFloat(85)
    let bannerViewHeight = cmSizeFloat(100+7+7)
    let bannerHeight = cmSizeFloat(100)
    let sectionBtnsDicArr:[Dictionary<String,UIImage>] = [["积分":#imageLiteral(resourceName: "mineIntegral")],["收藏":#imageLiteral(resourceName: "mineCollection")],["代金券":#imageLiteral(resourceName: "mineVoucher")]]
    
    let showMoreImage = #imageLiteral(resourceName: "mineShowMore")
    let telImage = #imageLiteral(resourceName: "mineTel")
    let messageImage = #imageLiteral(resourceName: "mineMessage")
    
    var  topView:XYTopView!
    var  backGroundView:UIView!
    //tableView
    var mainTabView:UITableView!
    //tableHeaderView
    var tableHeaderView:UIView!
    //tableHeader的多个按钮View
    var sectionHeader:UIView!
    //headerBannerImageView
    var headerBannerImageView:UIImageView!
    
    
    var avatarImageView:UIImageView!
    var userNickNameLab:UILabel!
    var userTelLabel:UILabel!
    var messageTipsView:UIView!

    
    var mineHomepageModel:MineHomepageModel = MineHomepageModel.praseMineHomepageData()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createBackgroundView()

        creatMainTabView()
        //loginSetUI()

        // Do any additional setup after loading the view.
    }

    //MARK: - 创建backgroundView
    func createBackgroundView() {
        backGroundView  = UIView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: 0))
        backGroundView.backgroundColor = MAIN_BLUE
        self.view.addSubview(backGroundView)
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().rightImageBtnItme(target: self, action: #selector(setUpAct), btnImage:#imageLiteral(resourceName: "mineSetup") ).secondRightBtnItem(target: self, action: #selector(messageAct), btnImage: messageImage))
        topView.titleLabel.text = "我的"
        for sublayer in topView.layer.sublayers! {
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)

        
        let messageTipsViewSize = cmSizeFloat(6)
        messageTipsView = UIView(frame: CGRect(x: SCREEN_WIDTH - cmSizeFloat(44) -  cmSizeFloat(44)/2 + messageImage.size.width/2 - messageTipsViewSize , y: STATUSBAR_HEIGHT + cmSizeFloat(44)/2 - messageImage.size.height/2, width: messageTipsViewSize, height: messageTipsViewSize))
        messageTipsView.clipsToBounds = true
        messageTipsView.layer.cornerRadius = messageTipsViewSize/2
        messageTipsView.backgroundColor = MAIN_RED
        self.view.addSubview(messageTipsView)
        
    }
    
    
    //MARK: - 消息及设置按钮响应
    @objc func messageAct() {
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        let messageVC = MessagesListVC()
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc func setUpAct() {
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        let setUpVC = UserCenterSettingVC()
        self.navigationController?.pushViewController(setUpVC, animated: true)

    }
    
    //MARK: - 创建headerView
    func creatTableHeaderView() {
        let avatarSize = cmSizeFloat(60)
        let userNameToAvatar = cmSizeFloat(20)
        let telImageToUserNameHeight = cmSizeFloat(10)
        let userTelToImageWidth = cmSizeFloat(5)
        let userNameToAvatarTop = (cmSizeFloat(60) - cmSingleLineHeight(fontSize: cmSystemFontWithSize(17)) - telImage.size.height - cmSizeFloat(10))/2
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: tableHeaderViewHeight))
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(loginBtnAct))
        tableHeaderView.addGestureRecognizer(tapGesture)
        tableHeaderView.backgroundColor = MAIN_BLUE
        
        avatarImageView = UIImageView(frame: CGRect(x: toside, y: avatarToTop, width: avatarSize, height: avatarSize))
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarSize/2
        tableHeaderView.addSubview(avatarImageView)
        
        userNickNameLab = UILabel(frame: CGRect(x: avatarImageView.right + userNameToAvatar, y: avatarImageView.top + userNameToAvatarTop, width: SCREEN_WIDTH - toside - avatarSize - userNameToAvatar - showMoreBtnSize, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(17))))
        userNickNameLab.font = cmBoldSystemFontWithSize(17)
        userNickNameLab.textColor = MAIN_WHITE
        userNickNameLab.textAlignment = .left
        tableHeaderView.addSubview(userNickNameLab)
        
        let telImageView = UIImageView(frame: CGRect(x: userNickNameLab.left, y: userNickNameLab.bottom + telImageToUserNameHeight, width: telImage.size.width, height: telImage.size.height))
        telImageView.image = telImage
        tableHeaderView.addSubview(telImageView)
        
        userTelLabel =  UILabel(frame: CGRect(x: telImageView.right + userTelToImageWidth, y: userNickNameLab.bottom + telImageToUserNameHeight, width: SCREEN_WIDTH - toside - avatarSize - userNameToAvatar - showMoreBtnSize - telImage.size.width - userTelToImageWidth, height: telImage.size.height))
        userTelLabel.font = cmBoldSystemFontWithSize(12)
        userTelLabel.textColor = MAIN_WHITE
        userTelLabel.textAlignment = .left
        tableHeaderView.addSubview(userTelLabel)
        

        let showMoreBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - showMoreBtnSize, y: avatarImageView.bottom - avatarSize/2 - showMoreBtnSize/2, width: showMoreBtnSize, height: showMoreBtnSize))
        showMoreBtn.setImage(showMoreImage, for: .normal)
        showMoreBtn.addTarget(self, action: #selector(showMoreBtnAct), for: .touchUpInside)
        tableHeaderView.addSubview(showMoreBtn)
        
        
        tableHeaderView.addSubview(creatHeaderBtnsHeader())
        tableHeaderView.addSubview(createTableViewHeaderBanner())

    }
    //MARK: - 创建sectionHeader
    func creatHeaderBtnsHeader() -> UIView{
        
        let sectionBtnImageToTextHeight = cmSizeFloat(7)
        sectionHeader = UIView(frame: CGRect(x: 0, y: tableHeaderUserViewSize, width: SCREEN_WIDTH, height: sectionHeaderHeight))
        sectionHeader.backgroundColor = .white
        
        for index in 0..<sectionBtnsDicArr.count {
            
           let sectionHeaderWidth = (SCREEN_WIDTH/CGFloat(sectionBtnsDicArr.count))
           let btnImageToTop = (sectionHeaderHeight - sectionBtnsDicArr[index].values.first!.size.height - cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)) - sectionBtnImageToTextHeight)/2

            
            let sectionBtn = UIButton(frame: CGRect(x: sectionHeaderWidth*CGFloat(index), y: 0, width: sectionHeaderWidth, height: sectionHeaderHeight))
            sectionBtn.tag = 200 + index
            sectionBtn.addTarget(self, action: #selector(sectionBtnAct(sender:)), for: .touchUpInside)
            
            let sectionBtnImage = UIImageView(frame: CGRect(x: sectionHeaderWidth/2 -  sectionBtnsDicArr[index].values.first!.size.width/2, y: btnImageToTop, width: sectionBtnsDicArr[index].values.first!.size.width, height: sectionBtnsDicArr[index].values.first!.size.height))
            sectionBtnImage.image = sectionBtnsDicArr[index].values.first!
            sectionBtn.addSubview(sectionBtnImage)
            
            let sectionBtnLabel = UILabel(frame: CGRect(x: 0, y: sectionBtnImage.bottom + sectionBtnImageToTextHeight, width: sectionHeaderWidth, height: cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))))
            sectionBtnLabel.font = cmSystemFontWithSize(13)
            sectionBtnLabel.textColor = MAIN_BLACK2
            sectionBtnLabel.textAlignment = .center
            sectionBtnLabel.text = sectionBtnsDicArr[index].keys.first!
            sectionBtn.addSubview(sectionBtnLabel)
            if index < sectionBtnsDicArr.count - 1 {
            let sectionBtnSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: sectionHeaderHeight/6, lineWidth: CGFloat(1), lineHeight: sectionHeaderHeight*2/3)
            sectionBtnSeperateLine.frame.origin.x = sectionHeaderWidth - CGFloat(1)
            sectionBtn.addSubview(sectionBtnSeperateLine)
            }
            
            sectionHeader.addSubview(sectionBtn)
        }
        

        
        return sectionHeader

    }
    
    
    @objc func sectionBtnAct(sender:UIButton) {
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        
        switch  sender.tag{
        case 200:
            let jfListVC = SellerJFListVC()
            self.navigationController?.pushViewController(jfListVC, animated: true)
            break
        case 201:
            let collectionVC = CollectionListVC()
            self.navigationController?.pushViewController(collectionVC, animated: true)
            break
        case 202:
            let promotionVC = PromotionListVC()
            self.navigationController?.pushViewController(promotionVC, animated: true)
            break
        default:
            break
        }
        
    }
    
    //MARK: - 登录按钮响应
    @objc func loginBtnAct() {
        if isLogined() == true {
            let userInfoSettingVC =   UserAccountInfoVC()
            self.navigationController?.pushViewController(userInfoSettingVC, animated: true)
        }else{
            checkLoginStatusAndAct()
        }
    }
    
    
    //MARK: - 创建tableviewHeader广告栏
    func createTableViewHeaderBanner() -> UIView{
        let bannerView = UIView(frame: CGRect(x: 0, y: sectionHeader.bottom, width: SCREEN_WIDTH, height: bannerViewHeight))
        bannerView.backgroundColor = .white
        
        let sectionHeaderSeprateLine = XYCommonViews.creatCommonSeperateLine(pointY: 0)
        sectionHeaderSeprateLine.frame.size.height = cmSizeFloat(7)
        bannerView.addSubview(sectionHeaderSeprateLine)
        
        headerBannerImageView = UIImageView(frame: CGRect(x: 0, y: sectionHeaderSeprateLine.bottom, width: SCREEN_WIDTH, height: bannerHeight))
        bannerView.addSubview(headerBannerImageView)
        
        let bottomSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: headerBannerImageView.bottom)
        bottomSeperateLine.frame.size.height = cmSizeFloat(7)
        bannerView.addSubview(bottomSeperateLine)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(bannerAct))
        bannerView.addGestureRecognizer(tapGesture)
        
        
        return bannerView
    }
    
    //MARK: - 点击广告
    @objc func bannerAct(){
        
        cmDebugPrint("---->点击广告")
        
    }
    
    //MARK: - 登录或取消登录后设置
    func loginSetUI(){
        if let avatarImageURL = URL(string:mineHomepageModel.userAvatarUrl) {
            avatarImageView.sd_setImage(with: avatarImageURL, placeholderImage: #imageLiteral(resourceName: "mineAvatarPlaceHolder"))
        }else{
            avatarImageView.image = #imageLiteral(resourceName: "mineAvatarPlaceHolder")
        }
        userNickNameLab.text = mineHomepageModel.userName
        userTelLabel.text = mineHomepageModel.userTel
        if let bannerImageURL = URL(string:mineHomepageModel.bannerImageUrl) {
            headerBannerImageView.sd_setImage(with: bannerImageURL, placeholderImage:#imageLiteral(resourceName: "XYplaceHolderImage.png"))
        }else{
            headerBannerImageView.image = #imageLiteral(resourceName: "userCenterBanner")
        }
        
    }
    
    
    
    //MARK: - 个人信息更多按钮
    @objc func showMoreBtnAct(){
        
        if isLogined() == true {
            
            self.navigationController?.pushViewController(UserAccountInfoVC(), animated: true)
        }else{
            checkLoginStatusAndAct()
        }
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        creatTableHeaderView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-STATUS_NAV_HEIGHT-TABBAR_HEIGHT), style: .grouped)
        mainTabView.backgroundColor = .clear
        mainTabView.separatorStyle = .none
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(MineHomepageCell.self, forCellReuseIdentifier: "MineHomepageCell")
        
        self.view.addSubview(mainTabView)
    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return mineHomepageModel.sectionCellModelArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mineHomepageModel.sectionCellModelArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MineHomepageCell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "MineHomepageCell")
            if cell == nil {
                cell = MineHomepageCell(style: UITableViewCellStyle.default, reuseIdentifier: "MineHomepageCell")
            }
            if let targetCell = cell as? MineHomepageCell{
                targetCell.selectionStyle = .none
                
                targetCell.setModel(model: mineHomepageModel.sectionCellModelArr[indexPath.section][indexPath.row])
                
                if mineHomepageModel.sectionCellModelArr[indexPath.section].count - 1 == indexPath.row {
                    targetCell.seperateLine.isHidden = true
                }else{
                    targetCell.seperateLine.isHidden = false
                }
                
                return targetCell
            }else{
                return cell!
            }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cmSizeFloat(7)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                //订单管理
            case 0:
                let orderVC = OrderManageVC()
                self.navigationController?.pushViewController(orderVC, animated: true)
                break
                //收货地址
            case 1:
                let adressVC = DeliveryAdressManagerVC()
                self.navigationController?.pushViewController(adressVC, animated: true)
                break
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
                //联系客服
            case 0:
                
                if UIApplication.shared.canOpenURL(URL(string: "mqq://")!) {
                    let qqNumStr = "3355261440"
                    let qqCustomServiceStr = "mqq://im/chat?chat_type=wpa&uin=\(qqNumStr)&version=1&src_type=web"
                    cmOpenUrl(str: qqCustomServiceStr)
                }else{
                    cmShowHUDToWindow(message: "您尚未安装QQ哦")
                }
                break
                //帮助
            case 1:
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
                //校园众包
            case 0:
                break
            default:
                break
            }
            break
        default:
            break
        }
        
        
    }

    //MARK: - scrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            backGroundView.frame.size.height =  -scrollView.contentOffset.y
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = false
        
        //显示已登录的用户信息
        if isLogined() {
            let userInfoModel = getLoginInfo()
            mineHomepageModel.userAvatarUrl =  userInfoModel.avatarUrl
            mineHomepageModel.userName = userInfoModel.userName
            mineHomepageModel.userTel = userInfoModel.userTel
        }else{
            mineHomepageModel.userName = "立刻登录"
            mineHomepageModel.userTel = "登录后享受更多功能"
            mineHomepageModel.userAvatarUrl = ""
        }
        self.loginSetUI()

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
