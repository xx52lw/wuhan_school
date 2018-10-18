//
//  HotestSetMenuVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/9.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit
import SwiftyJSON
class HotestSetMenuVC: UIViewController,XYBannerViewDelegate,UITableViewDelegate,UITableViewDataSource {

    let bannerHeight = cmSizeFloat(150)
    var topView:XYTopView!
    var titleStr:String!
    //创建banner
    var bannerView:XYBannerBrowser!
    //网络异常空白页
    public var economicalAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var ecnomicalNoDataView:XYAbnormalViewManager!
    //tableView
    var mainTabView:UITableView!
    
    var discountModel:HotestDiscountModel!
    //经济实惠请求sevice
    var economicalService:HotestEconomicalSeivice = HotestEconomicalSeivice()
    //精品餐请求sevice
    var requestSelectedFoodsService = HotestSelectedFoodsService()
    //hotestID
    var hotestID:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        if hotestID == HotestMMIDEnum.economical.rawValue {
            economicalService.hotestEconomicalDataRequest(target: self)
        }else if hotestID == HotestMMIDEnum.selectedFood.rawValue {
            requestSelectedFoodsService.hotestSelectedFoodsDataRequest(target: self)
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - 创建tableHeaderView
    func  creatTableHeaderView(){
        bannerView  = XYBannerBrowser(frame: CGRect(x:0,y:0,width:SCREEN_WIDTH,height:bannerHeight), imageArrayUrl: [discountModel.bannerPicUrl])
        bannerView.delegate = self
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
//        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
//            //self?.service.refreshTakeFoodOutData(target: self!)
//        })
        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [unowned self] in
           
            if self.hotestID == HotestMMIDEnum.economical.rawValue {
                self.economicalService.getHotestEconomicalPullListData(target: self)
            }else  if self.hotestID == HotestMMIDEnum.selectedFood.rawValue {
                self.requestSelectedFoodsService.getHotestSelectedFoodsPullListData(target: self)
            }
            
            
        })
        
        
        mainTabView.separatorStyle = .none
        mainTabView.tableHeaderView = bannerView
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(HotestDiscountTableViewCell.self, forCellReuseIdentifier: "HotestDiscountTableViewCell")
        mainTabView.register(HotestNodiscountTableViewCell.self, forCellReuseIdentifier: "HotestNodiscountTableViewCell")
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? 0:bannerHeight , width: SCREEN_WIDTH, height:isNetError ? SCREEN_HEIGHT:SCREEN_HEIGHT-bannerHeight), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            ecnomicalNoDataView = abnormalView
            ecnomicalNoDataView.abnormalType = .noData
        }else if isNetError == true{
            economicalAbnormalView = abnormalView
            economicalAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            economicalAbnormalView.refreshActionBlock = {[unowned self] in
                if self.hotestID == HotestMMIDEnum.economical.rawValue {
                    self.economicalService.hotestEconomicalDataRequest(target: self)
                }else if self.hotestID == HotestMMIDEnum.selectedFood.rawValue {
                    self.requestSelectedFoodsService.hotestSelectedFoodsDataRequest(target: self)
                }
            }
        }
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
        
        return discountModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if discountModel.cellModelArr[indexPath.row].goodsDetailStr.isEmpty {
            return HotestNodiscountTableViewCell.hotestNoDiscountCellHeight
        }else{
            return  HotestDiscountTableViewCell.hotestDiscountCellHeight
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if discountModel.cellModelArr[indexPath.row].discountDetailStr.isEmpty {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotestNodiscountTableViewCell")
            if cell == nil {
                cell = HotestNodiscountTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "HotestNodiscountTableViewCell")
            }
            if let targetCell = cell as? HotestNodiscountTableViewCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: discountModel.cellModelArr[indexPath.row])
                return targetCell
            }else{
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotestDiscountTableViewCell")
            if cell == nil {
                cell = HotestDiscountTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "HotestDiscountTableViewCell")
            }
            if let targetCell = cell as? HotestDiscountTableViewCell{
                targetCell.selectionStyle = .none
                targetCell.setModel(model: discountModel.cellModelArr[indexPath.row])
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
