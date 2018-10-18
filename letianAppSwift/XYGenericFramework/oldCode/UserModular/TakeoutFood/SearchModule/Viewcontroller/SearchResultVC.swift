//
//  SearchResultViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/10.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let segmentBtnStrArr = ["距离最近","销量最高","评价最高"]
    
    var topView:XYTopView!
    var searchWord:String!
    var segmentBtnsView:UIView!
    var mainTabView:UITableView!
    
    //网络异常空白页
    public var sellerListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var sellerListNoDataView:XYAbnormalViewManager!
    //当前搜索的按钮类别
    var currentSearchType:LTSearchType = .distance
    //搜索结果为商家还是商品
    var searchType:Int!

    var segmentsBtnArr:[UIButton] = Array()
    //model
    var searchModel:SearchResultModel!
    var service:SearchSellerGoodsService = SearchSellerGoodsService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatSegmentBtn()
        service.searchSellerRequest(target: self, keyWord: searchWord, searchType: .distance)
        
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).rightStrBtnItem(target: self, action: #selector(searchAction), btnStr: "搜索", fontSize:15).searchTextFieldItem(placeholderStr: nil))
        if searchWord != nil {
            topView.searchTextField.text = searchWord
        }
    }
    //MARK: - 搜索按钮响应
    @objc func searchAction(){
        
        if topView.searchTextField.text!.isEmpty {
            cmShowHUDToWindow(message: "搜索内容不能为空")
        }else{
         self.view.endEditing(true)
         self.searchWord = topView.searchTextField.text!
            self.mainTabView.mj_header.beginRefreshing()
        }
        
    }
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height:isNetError ? SCREEN_HEIGHT-topView.bottom:SCREEN_HEIGHT-segmentBtnsView.bottom), in: isNetError ?self.view:self.mainTabView)
        
        if isNetError == false{
            sellerListNoDataView = abnormalView
            sellerListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            sellerListAbnormalView = abnormalView
            sellerListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            sellerListAbnormalView.refreshActionBlock = {[unowned self] in
                    self.service.searchSellerRequest(target: self, keyWord: self.searchWord, searchType: self.currentSearchType)
            }
        }
    }
    
    
    //MARK: - 创建分段按钮
    func creatSegmentBtn(){
        let segmentBtnsViewHeight = cmSizeFloat(40)
        segmentBtnsView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height:segmentBtnsViewHeight ))
        for index in 0..<segmentBtnStrArr.count {
            
            let segmentBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH/CGFloat(segmentBtnStrArr.count)*CGFloat(index), y: 0, width: SCREEN_WIDTH/CGFloat(segmentBtnStrArr.count), height: segmentBtnsViewHeight))
            segmentBtn.setTitle(segmentBtnStrArr[index], for: .normal)
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
            if index == 0{
            segmentBtn.setTitleColor(MAIN_BLUE, for: .normal)
            }
            segmentBtn.titleLabel?.font = cmSystemFontWithSize(15)
            segmentBtn.addTarget(self, action: #selector(segmentAct(sender:)), for: .touchUpInside)
            segmentBtn.tag = 200 + index
            segmentsBtnArr.append(segmentBtn)
            segmentBtnsView.addSubview(segmentBtn)
            
            if index != segmentBtnStrArr.count - 1{
                let seperateLine = UIView(frame: CGRect(x: segmentBtn.right, y:cmSizeFloat(8) , width: cmSizeFloat(1), height: segmentBtnsViewHeight - cmSizeFloat(16)))
                seperateLine.backgroundColor =  MAIN_GRAY
                segmentBtnsView.addSubview(seperateLine)
            }
            
            
        }
        
        let segmentSeperateLine = XYCommonViews.creatCommonSeperateLine(pointY: segmentBtnsViewHeight - cmSizeFloat(1))
        segmentBtnsView.addSubview(segmentSeperateLine)
        self.view.addSubview(segmentBtnsView)
        
    }
    //MARK: - 分段按钮响应
    @objc func segmentAct(sender:UIButton){
        for segmentBtn in segmentsBtnArr {
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
        }
        sender.setTitleColor(MAIN_BLUE, for: .normal)
        
        switch sender.tag {
        case 200:
            self.currentSearchType = .distance
            break
        case 201:
             self.currentSearchType = .saleCount
            break
        case 202:
             self.currentSearchType = .score
            break
        default:
            break
        }
        
        self.service.refreshSellerListData(target: self, keyWord: self.searchWord, searchType: self.currentSearchType)
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:segmentBtnsView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [unowned self] in
            self.service.refreshSellerListData(target: self, keyWord: self.searchWord, searchType: self.currentSearchType)
            
            if self.mainTabView.mj_footer != nil {
                self.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        

        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [unowned self] in
                self.service.getTypePullSellerListData(target: self, keyWord: self.searchWord, searchType: self.currentSearchType)
            
        })
        
        
        
        
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(TakeFoodTableViewCell.self, forCellReuseIdentifier: "TakeFoodTableViewCell")
        mainTabView.register(HotestDiscountTableViewCell.self, forCellReuseIdentifier: "HotestDiscountTableViewCell")
        mainTabView.register(HotestNodiscountTableViewCell.self, forCellReuseIdentifier: "HotestNodiscountTableViewCell")
        self.view.addSubview(mainTabView)
    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == 0{
        return searchModel.searchSellerCellArr.count
        }else if searchType == 1{
            return searchModel.searchGoodsCellArr.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchType == 0{
            return takeFoodTableViewCellHeight
        }else if searchType == 1 {
            if searchModel.searchGoodsCellArr[indexPath.row].discountDetailStr.isEmpty {
                return HotestNodiscountTableViewCell.hotestNoDiscountCellHeight
            }else{
                return HotestDiscountTableViewCell.hotestDiscountCellHeight
            }
        }else {
            return .leastNormalMagnitude
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  searchType == 0 {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TakeFoodTableViewCell")
        if cell == nil {
            cell = TakeFoodTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TakeFoodTableViewCell")
        }
        if let targetCell = cell as? TakeFoodTableViewCell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: searchModel.searchSellerCellArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
        }else if searchType == 1 {
            if searchModel.searchGoodsCellArr[indexPath.row].discountDetailStr.isEmpty {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HotestNodiscountTableViewCell")
                if cell == nil {
                    cell = HotestNodiscountTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "HotestNodiscountTableViewCell")
                }
                if let targetCell = cell as? HotestNodiscountTableViewCell{
                    targetCell.selectionStyle = .none
                    targetCell.setModel(model: searchModel.searchGoodsCellArr[indexPath.row])
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
                    targetCell.setModel(model: searchModel.searchGoodsCellArr[indexPath.row])
                    return targetCell
                }else{
                    return cell!
                }
            }
        }else{
            return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchType == 1 {
            
        }else{
            let sellerVC = SellerDetailPageVC()
            sellerVC.merchantID = searchModel.searchSellerCellArr[indexPath.row].sellerID
            self.navigationController?.pushViewController(sellerVC, animated: true)
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = .default
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
