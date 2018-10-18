//
//  TakeOutFoodVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi6409 on 2017/10/2.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class TakeOutFoodVC: UIViewController,XYBannerViewDelegate,UITableViewDelegate,UITableViewDataSource {

    let bannerHeight = cmSizeFloat(150)
    //请求分类错误页
    public var takeoutFoodAbnormalView:XYAbnormalViewManager!
    
    var topView:XYTopView!
    //创建banner
    var bannerView:XYBannerBrowser!
    //tableView
    var mainTabView:UITableView!
    //tableHeaderView
    var tableHeaderView:UIView!
    //model
    var takeFoodModel:TakeFoodModel =  TakeFoodModel()
    //service
    var service:TakeOutFoodService = TakeOutFoodService()
    
    //网络异常空白页
    public var takefoodOutAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var takefoodOutNoDataView:XYAbnormalViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        checkUserRoleAndAct()


        // Do any additional setup after loading the view.
    }

    
    
    //MARK: - 判断角色然后进行操作
    func checkUserRoleAndAct(){
        let userRole = getUserRole()
        switch userRole {
        case .ExpressManager:
            break
        case .Guest:
            removeLoginInfo()
            removeTokenInfo()
            gusteLoginAct()
            break
        case .Merchant:
            let merchantHomepagevc = MerchantManagerHomepageVC()
            self.navigationController?.pushViewController(merchantHomepagevc, animated: true)
            break
        case .MerchantDeliver:
            let staffHomepagevc = StaffOrderListVC()
            self.navigationController?.pushViewController(staffHomepagevc, animated: true)
            break
        case .User:
            self.service.takefoodOutDataRequest(target: self)
            break
        case .UserDeliver:
            break
        case .none:
            gusteLoginAct()

            break
        }
        
        

        
    }
    
    
    
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.rightImageBtnItme(target: self, action: #selector(rightAct), btnImage: #imageLiteral(resourceName: "topviewSearch")).createLocationBtn(titleStr: takeFoodModel.currentAdress,action:#selector(chooseLocationAct),target:self))
    }
    
    @objc func rightAct(){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc func chooseLocationAct(){
        
        if isLogined() == false {
            checkLoginStatusAndAct()
            return
        }
        
        let mapLocationVC = MapLocationVC()
        mapLocationVC.currentSelectedGeoHashStr = takeFoodModel.geoHash
        self.navigationController?.pushViewController(mapLocationVC, animated: true)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TABBAR_HEIGHT), in: self.view)
        
        if isNetError == false{
            takefoodOutNoDataView = abnormalView
            takefoodOutNoDataView.abnormalType = .noData
        }else if isNetError == true{
            takefoodOutAbnormalView = abnormalView
            takefoodOutAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            takefoodOutAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.takefoodOutDataRequest(target: self!)
            }
        }
    }
    
    //MARK: - 创建tableHeaderView
    func  creatTableHeaderView(){
        

        let typeBtnHeight = cmSizeFloat(100)
        let hotestBtnHeight = cmSizeFloat(105)
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:bannerHeight+typeBtnHeight+hotestBtnHeight*2+cmSizeFloat(12)))
        tableHeaderView.backgroundColor = MAIN_WHITE
        
        //获取banner广告ImageUrl
        var bannerPicArr:[String] = Array()
        for bannerModel in takeFoodModel.bannerModelArr {
            bannerPicArr.append(bannerModel.imageUrl)
        }
        
        //创建BannerView
        bannerView  = XYBannerBrowser(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:bannerHeight), imageArrayUrl: bannerPicArr)
        bannerView.delegate = self
        tableHeaderView.addSubview(bannerView)
        
        
        //创建分类按钮
        for index in 0..<takeFoodModel.takeFoodTypeModelArr.count{
            
            let typeBtnWidth = SCREEN_WIDTH/CGFloat(takeFoodModel.takeFoodTypeModelArr.count)
            let imageSize = cmSizeFloat(55)
            let wordLineHeight = cmSingleLineHeight(fontSize: cmSystemFontWithSize(13))
            
            let typeBtn = UIButton(frame: CGRect(x: typeBtnWidth*CGFloat(index) , y: bannerView.frame.maxY, width: typeBtnWidth, height: typeBtnHeight))
            typeBtn.backgroundColor = MAIN_WHITE
            typeBtn.tag = 200 + index
            typeBtn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
            tableHeaderView.addSubview(typeBtn)
            
            let btnImageView = UIImageView(frame: CGRect(x: typeBtnWidth/2 - imageSize/2, y: (typeBtnHeight - imageSize - wordLineHeight)/3, width: imageSize, height: imageSize))
            
            if let imageUrl = URL(string:takeFoodModel.takeFoodTypeModelArr[index].typeImageUrl){
                btnImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
            }else{
                btnImageView.image = #imageLiteral(resourceName: "placeHolderImage")
            }
            
            typeBtn.addSubview(btnImageView)
            
            let btnLabel = UILabel(frame: CGRect(x: 0, y: btnImageView.frame.maxY + (typeBtnHeight - imageSize - wordLineHeight)/3, width: typeBtnWidth, height: wordLineHeight))
            btnLabel.font = cmSystemFontWithSize(13)
            btnLabel.text = takeFoodModel.takeFoodTypeModelArr[index].typeName
            btnLabel.textColor = MAIN_BLACK2
            btnLabel.textAlignment = .center
            typeBtn.addSubview(btnLabel)
            
        }
        
        let typeSeperateLine = XYCommonViews.creatCustomSeperateLine(pointY: bannerView.frame.maxY + typeBtnHeight, lineWidth:SCREEN_WIDTH, lineHeight: cmSizeFloat(6))
        tableHeaderView.addSubview(typeSeperateLine)
        
        //热门及推荐品类
        let hotestBtnWidth = SCREEN_WIDTH/2
        let hotestImageSize = cmSizeFloat(65)
        for hotestIndex in 0..<takeFoodModel.takeFoodHotestModelArr.count{
            let hotestBtn = UIButton(frame: CGRect(x: hotestBtnWidth*CGFloat(hotestIndex%2), y: typeSeperateLine.frame.maxY + hotestBtnHeight*CGFloat(hotestIndex/2), width: hotestBtnWidth, height: hotestBtnHeight))
            hotestBtn.tag = 300 + hotestIndex
            hotestBtn.addTarget(self, action: #selector(hotestBtnAct(sender:)), for: .touchUpInside)
            
            let hotestImageView = UIImageView(frame: CGRect(x: hotestBtnWidth - cmSizeFloat(20) - hotestImageSize, y: (hotestBtnHeight - hotestImageSize)/2, width: hotestImageSize, height: hotestImageSize))
            
            if let imageUrl = URL(string:takeFoodModel.takeFoodHotestModelArr[hotestIndex].hotestImageUrl){
                hotestImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"))
            }else{
                hotestImageView.image = #imageLiteral(resourceName: "placeHolderImage")
            }
            hotestBtn.addSubview(hotestImageView)
            
            
            let hotestbtnLabel = UILabel(frame: CGRect(x: cmSizeFloat(20), y: cmSizeFloat(30), width: hotestBtnWidth - hotestImageSize - cmSizeFloat(30), height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(14))))
            hotestbtnLabel.font = cmBoldSystemFontWithSize(14)
            hotestbtnLabel.text = takeFoodModel.takeFoodHotestModelArr[hotestIndex].hotestName
            hotestbtnLabel.textColor = MAIN_BLACK
            hotestbtnLabel.textAlignment = .left
            hotestBtn.addSubview(hotestbtnLabel)
            
            
            let hotestLabelDescription = UILabel(frame: CGRect(x: hotestbtnLabel.left, y: hotestbtnLabel.bottom + cmSizeFloat(10), width: hotestBtnWidth - hotestImageSize - cmSizeFloat(40), height: cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(12))))
                hotestLabelDescription.font = cmSystemFontWithSize(12)
                hotestLabelDescription.text = takeFoodModel.takeFoodHotestModelArr[hotestIndex].hotestDescription
                hotestLabelDescription.textColor = MAIN_GRAY
                hotestLabelDescription.textAlignment = .left
                hotestBtn.addSubview(hotestLabelDescription)
            
            
            tableHeaderView.addSubview(hotestBtn)
            
        }
        
        
        let hotestHorizontalLine = XYCommonViews.creatCustomSeperateLine(pointY: bannerView.frame.maxY + typeBtnHeight + hotestBtnHeight + cmSizeFloat(6), lineWidth: SCREEN_WIDTH, lineHeight: CGFloat(0.5))
        tableHeaderView.addSubview(hotestHorizontalLine)
        
        let  hotestVerticalLine = XYCommonViews.creatCustomSeperateLine(pointY: bannerView.frame.maxY + typeBtnHeight + cmSizeFloat(6), lineWidth: CGFloat(0.5), lineHeight: hotestBtnHeight*2)
        hotestVerticalLine.frame.origin.x = SCREEN_WIDTH/2
        tableHeaderView.addSubview(hotestVerticalLine)
        
        
        let hotestSeperateView = XYCommonViews.creatCustomSeperateLine(pointY: bannerView.frame.maxY + typeBtnHeight + hotestBtnHeight*2 + cmSizeFloat(6), lineWidth:SCREEN_WIDTH, lineHeight: cmSizeFloat(6))
        tableHeaderView.addSubview(hotestSeperateView)
        
        
        
    }
    
    
    //MARK: - 点击分类按钮
    @objc  func clickTypeBtn(sender:UIButton){
        cmDebugPrint(sender.tag)
        
      let catVC =  CatsViewController()
        catVC.catName = takeFoodModel.takeFoodTypeModelArr[sender.tag - 200].typeName
        catVC.catID = takeFoodModel.takeFoodTypeModelArr[sender.tag - 200].typeId
        catVC.goodsCatsUrl = firstTypeSellerUrl
        self.navigationController?.pushViewController(catVC, animated: true)
        
    }
    
    //MARK: - 点击热门推荐品类
    @objc func hotestBtnAct(sender:UIButton){
        
        switch sender.tag {
        case 300:
            let discountVC = HotestDiscountVC()
            discountVC.titleStr = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestName
            discountVC.hotestID = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestID
            self.navigationController?.pushViewController(discountVC, animated: true)
            break
        case 301:
            let rankVC = HotestRankVC()
            rankVC.titleStr = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestName
            rankVC.hotestID = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestID
            self.navigationController?.pushViewController(rankVC, animated: true)
            break
        case 302,303:
            let setMenuVC = HotestSetMenuVC()
            setMenuVC.titleStr = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestName
            setMenuVC.hotestID = takeFoodModel.takeFoodHotestModelArr[sender.tag - 300].hotestID
            self.navigationController?.pushViewController(setMenuVC, animated: true)
            break
        default:
            break
        }
        
        cmDebugPrint(sender.tag)
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:STATUS_NAV_HEIGHT, width:SCREEN_WIDTH, height:SCREEN_HEIGHT-TABBAR_HEIGHT-STATUS_NAV_HEIGHT), style: .grouped)
        
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
            self?.service.refreshTakeFoodOutData(target: self!)
        })
        
        
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(TakeFoodTableViewCell.self, forCellReuseIdentifier: "TakeFoodTableViewCell")

        self.view.addSubview(mainTabView)
    }
    
    
    
    
//    //MARK: - 创建请求分类数据错误页
//    public func creatHomePageAbnormalView(){
//        takeoutFoodAbnormalView = XYAbnormalViewManager(frame: CGRect(x: 0 , y:STATUS_NAV_HEIGHT , width: SCREEN_WIDTH, height: SCREEN_HEIGHT-TABBAR_HEIGHT), in:
//            self.view)
//        takeoutFoodAbnormalView.abnormalType = .noData
//        takeoutFoodAbnormalView.refreshActionBlock = {[weak self] in
//            cmDebugPrint("刷新啦")
//        }
//    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return takeFoodModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return takeFoodTableViewCellHeight
            
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
            return .leastNormalMagnitude
        
            }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let recommendationView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(47)))
        recommendationView.backgroundColor = cmColorWithString(colorName: "ffffff")

        let recommendationLabel =  UILabel(frame: CGRect(x: cmSizeFloat(20), y: 0, width: SCREEN_WIDTH - cmSizeFloat(40), height: cmSizeFloat(47)))
        recommendationLabel.font = cmBoldSystemFontWithSize(14)
        recommendationLabel.text = "热门推荐"
        recommendationLabel.textColor = MAIN_BLACK
        recommendationLabel.textAlignment = .left
        recommendationView.addSubview(recommendationLabel)
        return recommendationView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            return cmSizeFloat(47)
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TakeFoodTableViewCell")
        if cell == nil {
            cell = TakeFoodTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TakeFoodTableViewCell")
        }
        if let targetCell = cell as? TakeFoodTableViewCell{
            targetCell.selectionStyle = .none
            
            targetCell.setModel(model: takeFoodModel.cellModelArr[indexPath.row])
            
            
            return targetCell
        }else{
            return cell!
        }

    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerVC = SellerDetailPageVC()
        sellerVC.merchantID = takeFoodModel.cellModelArr[indexPath.row].sellerID
        self.navigationController?.pushViewController(sellerVC, animated: true)
    }

    
    //MARK: - banner点击代理事件
    func didClickCurrentImage(currentIndex: Int) {
        
        //如果有链接，则跳转到链接
        if takeFoodModel.bannerModelArr[currentIndex].isLinkMerchant == true {
            let sellerVC = SellerDetailPageVC()
            sellerVC.merchantID = takeFoodModel.bannerModelArr[currentIndex].linkUrl
            self.navigationController?.pushViewController(sellerVC, animated: true)
        }else{
            cmOpenUrl(str: takeFoodModel.bannerModelArr[currentIndex].linkUrl)
        }
        
    }
 
    //MARK: - 游客登录Act
    func gusteLoginAct(){
        let loginService:LoginRegisterService = LoginRegisterService()
        loginService.loginByAccount(account: "guest", passWord: "1011", loginSuccessAct: { [weak self] in
            //刷新首页数据
            self?.service.takefoodOutDataRequest(target: self!)
        }) {
            
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = false
        
        if mainTabView != nil {
            mainTabView.mj_header.beginRefreshing()
        }
        
        //refreshCurrentLocation()
    }
    
    
    //MARK: - 刷新当前所属区域位置信息
    func refreshCurrentLocation(){
        if topView != nil {
            cmDebugPrint(currentSelectedAdress)
            var matchTitleStr:String!
            if currentSelectedAdress.count > 8 {
                matchTitleStr = currentSelectedAdress[0..<8] + "..."
            }else{
                matchTitleStr = currentSelectedAdress
            }
            
            let titleStrWidth = matchTitleStr.stringWidth(cmSingleLineHeight(fontSize: cmBoldSystemFontWithSize(18)), font: cmBoldSystemFontWithSize(18))
            topView.locationBtnTitleLab.frame.size.width = titleStrWidth
            topView.locationBtn.frame.size.width = topView.locationImageView.frame.size.width + titleStrWidth + cmSizeFloat(10)
            topView.locationBtn.frame.origin.x = SCREEN_WIDTH/2 - (topView.locationImageView.frame.size.width + titleStrWidth + cmSizeFloat(10))/2
            topView.locationBtnTitleLab.text = matchTitleStr
        }
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
