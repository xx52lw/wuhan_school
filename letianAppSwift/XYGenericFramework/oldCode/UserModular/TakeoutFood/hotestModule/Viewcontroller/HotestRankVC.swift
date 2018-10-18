//
//  HotestRankVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class HotestRankVC: UIViewController,XYBannerViewDelegate,UITableViewDelegate,UITableViewDataSource {

    let bannerHeight = cmSizeFloat(150)
    let segmentScrollViewHeight = cmSizeFloat(50)
    var topView:XYTopView!
    var tableHeaderView:UIView!
    var titleStr:String!
    //创建banner
    var bannerView:XYBannerBrowser!
    //tableView
    var mainTabView:UITableView!
    //分类标签滑动view
    var segmentScrollView:UIScrollView!
    //网络异常空白页
    public var rankAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var rankNoDataView:XYAbnormalViewManager!
    
    //所有的标签选项按钮
    var allTypesBtnArr:[UIButton] = Array()
    //所有标签选项按钮位置Arr
    var allTypeBtnPointXArr:[CGFloat] = Array()
    var rankModel:HotestRankModel!
    var rankTypeModel:HotestRankTypeModel!
    
    var service:HotestRankService = HotestRankService()
    //hotestID
    var hotestID:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //creatMainTabView()
        creatNavTopView()
        service.hotestRankTypeRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? 0:bannerHeight+segmentScrollViewHeight , width: SCREEN_WIDTH, height: isNetError ?  SCREEN_HEIGHT:SCREEN_HEIGHT - (bannerHeight+segmentScrollViewHeight)), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            rankNoDataView = abnormalView
            rankNoDataView.abnormalType = .noData
        }else if isNetError == true{
            rankAbnormalView = abnormalView
            rankAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            rankAbnormalView.refreshActionBlock = {[unowned self] in
                self.service.hotestRankTypeRequest(target: self)
            }
        }
    }
    
    //MARK: - 创建tableHeaderView
    func  creatTableHeaderView(){
        
        
        
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bannerHeight+segmentScrollViewHeight))
        tableHeaderView.isUserInteractionEnabled = true
        tableHeaderView.backgroundColor = .white
        
        bannerView  = XYBannerBrowser(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:bannerHeight), imageArrayUrl: [rankTypeModel.bannerPicUrl])
        bannerView.delegate = self
        tableHeaderView.addSubview(bannerView)
        
        segmentScrollView = UIScrollView(frame: CGRect(x: 0, y: bannerView.frame.maxY, width: SCREEN_WIDTH, height: segmentScrollViewHeight))
        //segmentScrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: segmentScrollViewHeight)
        segmentScrollView.isPagingEnabled = false
        segmentScrollView.bounces = true
        segmentScrollView.backgroundColor = cmColorWithString(colorName: "ffffff")
        segmentScrollView.showsVerticalScrollIndicator = false
        segmentScrollView.showsHorizontalScrollIndicator = false
        
        var currentBtnXPoint:CGFloat = cmSizeFloat(15)
        for index in 0..<rankTypeModel.typesModelArr.count {
            let typeStrWdith = rankTypeModel.typesModelArr[index].typeName.stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13)) + 16
            let btnHeight = cmSizeFloat(30)
            let typeBtn = UIButton(frame: CGRect(x: currentBtnXPoint, y: (segmentScrollViewHeight - btnHeight)/2, width: typeStrWdith, height: btnHeight))
            typeBtn.setTitle(rankTypeModel.typesModelArr[index].typeName, for: .normal)
            typeBtn.titleLabel?.font = cmSystemFontWithSize(13)
            typeBtn.setTitleColor(MAIN_BLACK2, for: .normal)
            typeBtn.layer.borderWidth = 1
            typeBtn.layer.borderColor = MAIN_BLUE.cgColor
            typeBtn.layer.cornerRadius = btnHeight/2
            typeBtn.clipsToBounds = true
            typeBtn.tag = 300 + index
            typeBtn.addTarget(self, action: #selector(chooseTagAct(sender:)), for: .touchUpInside)
            allTypeBtnPointXArr.append(currentBtnXPoint)
            allTypesBtnArr.append(typeBtn)
            currentBtnXPoint += typeStrWdith + cmSizeFloat(15)
            if index == rankTypeModel.typesModelArr.count - 1{
                segmentScrollView.contentSize = CGSize(width: currentBtnXPoint, height: segmentScrollViewHeight)
            }
            
            if index == 0 {
                typeBtn.setTitleColor(MAIN_BLUE, for: .normal)
            }
            
            
            segmentScrollView.addSubview(typeBtn)
        }
        
        tableHeaderView.addSubview(segmentScrollView)

        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: segmentScrollView.bottom - cmSizeFloat(1))
        tableHeaderView.addSubview(seperateLine)
        
    }
    
    //MARK: - 点击标签按钮
    @objc func chooseTagAct(sender:UIButton){
        let typeTag = sender.tag - 300
        for tagBtn in allTypesBtnArr{
            tagBtn.setTitleColor(MAIN_BLACK2, for: .normal)
        }
        sender.setTitleColor(MAIN_BLUE, for: .normal)
        
        if typeTag == allTypesBtnArr.count - 1 {
            
        }else if typeTag > 2 {
            self.segmentScrollView.setContentOffset(CGPoint(x: allTypeBtnPointXArr[typeTag-2], y: 0), animated: true)
        }else{
            self.segmentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
       self.service.searchRankGoodsByPrice(target: self, typeCellModel: rankTypeModel.typesModelArr[sender.tag - 300])
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = tableHeaderView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(RankDiscountTableViewCell.self, forCellReuseIdentifier: "RankDiscountTableViewCell")
        mainTabView.register(RankNoDiscountTableViewCell.self, forCellReuseIdentifier: "RankNoDiscountTableViewCell")
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        for sublayer in topView.layer.sublayers! {
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = titleStr
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0)
    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rankModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if rankModel.cellModelArr[indexPath.row].goodsDetailStr.isEmpty {
            return HotestNodiscountTableViewCell.hotestNoDiscountCellHeight
        }else{
            return  HotestDiscountTableViewCell.hotestDiscountCellHeight
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if rankModel.cellModelArr[indexPath.row].discountDetailStr.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "RankNoDiscountTableViewCell")
            if cell == nil {
                cell = RankNoDiscountTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RankNoDiscountTableViewCell")
            }
            if let targetCell = cell as? RankNoDiscountTableViewCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: rankModel.cellModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "RankDiscountTableViewCell")
            if cell == nil {
                cell = RankDiscountTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RankDiscountTableViewCell")
            }
            if let targetCell = cell as? RankDiscountTableViewCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: rankModel.cellModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    //MARK: - 通过Scroll的代理方法监听tableView滑动情况
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = bannerHeight - STATUS_NAV_HEIGHT
        if scrollView == mainTabView{
            //颜色渐变
            if  scrollView.contentOffset.y <= scrollHeight{
                
                if   scrollView.contentOffset.y > 0{
                    topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: ( 0 + scrollView.contentOffset.y / scrollHeight))
                }else if scrollView.contentOffset.y <= 0{
                    topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 0)
                }
            }else{
                topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR, alpha: 1)
            }
        }
    }
    
    //MARK: - banner点击代理事件
    func didClickCurrentImage(currentIndex: Int) {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = .default
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
