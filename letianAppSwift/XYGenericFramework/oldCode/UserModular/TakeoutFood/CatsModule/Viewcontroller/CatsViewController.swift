//
//  CatsViewController.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/10/12.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

import UIKit

class CatsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let segmentBtnStrArr = ["距离最近","销量最高","评价最高"]
    
    var topView:XYTopView!
    var segmentBtnsView:UIView!
    var mainTabView:UITableView!
    var catName:String!
    var catID:Int!
    var currentSearchType:LTSearchType = .distance
    
    var segmentsBtnArr:[UIButton] = Array()
    
    //此处根据传递数据请求一级分类下商家还是二级分类下商家
    var goodsCatsUrl:String!

    //网络异常空白页
    public var sellerListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var sellerListNoDataView:XYAbnormalViewManager!
    
    //model
    var catsModel:CatsModel!
    var service:CatsHomeService = CatsHomeService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatSegmentBtn()
        service.catsDetailDataRequest(target: self, goodsFCatID: catID, searchType: currentSearchType)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        if catName != nil {
            topView.titleLabel.text = catName
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
                self.service.catsDetailDataRequest(target: self, goodsFCatID: self.catID, searchType: self.currentSearchType)
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
            segmentBtn.tag = 300 + index
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
    @objc  func segmentAct(sender:UIButton){
        for segmentBtn in segmentsBtnArr {
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
        }
        sender.setTitleColor(MAIN_BLUE, for: .normal)
        //每次请求不同的数据都重新设置footer
        if self.mainTabView.mj_footer != nil {
            self.mainTabView.mj_footer.resetNoMoreData()
        }
        switch sender.tag {
        case 300:
            if currentSearchType != .distance {
                currentSearchType = .distance
                service.catsDetailDataRequest(target: self, goodsFCatID: catID, searchType: currentSearchType)
            }
            break
        case 301:
            if currentSearchType != .saleCount {
                currentSearchType = .saleCount
                service.catsDetailDataRequest(target: self, goodsFCatID: catID, searchType: currentSearchType)
            }
            break
        case 302:
            if currentSearchType != .score {
                currentSearchType = .score
                service.catsDetailDataRequest(target: self, goodsFCatID: catID, searchType: currentSearchType)
            }
            break
        default:
            break
        }
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:segmentBtnsView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [unowned self] in
            self.service.refreshSellerListData(target: self, goodsFCatID: self.catID, searchType: self.currentSearchType)
            if self.mainTabView.mj_footer != nil {
                self.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [unowned self] in
            self.service.getTypePullListData(target: self, goodsFCatID: self.catID, searchType: self.currentSearchType)
        })
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(CatsDetailTableViewCell.self, forCellReuseIdentifier: "CatsDetailTableViewCell")
        self.view.addSubview(mainTabView)
    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catsModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CatsDetailTableViewCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CatsDetailTableViewCell")
        if cell == nil {
            cell = CatsDetailTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CatsDetailTableViewCell")
        }
        if let targetCell = cell as? CatsDetailTableViewCell{
            targetCell.selectionStyle = .none
            
            targetCell.setModel(model: catsModel.cellModelArr[indexPath.row])
            
            
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sellerVC = SellerDetailPageVC()
        sellerVC.merchantID = catsModel.cellModelArr[indexPath.row].sellerID
        self.navigationController?.pushViewController(sellerVC, animated: true)
        
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
