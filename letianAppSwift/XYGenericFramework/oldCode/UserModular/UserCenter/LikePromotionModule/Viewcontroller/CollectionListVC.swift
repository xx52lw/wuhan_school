//
//  CollectionListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class CollectionListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private  var topView:XYTopView!
    public var mainTabView:UITableView!
    
    //网络异常空白页
    public var collectionListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var collectionListNoDataView:XYAbnormalViewManager!
    
    var collectionListModel:CollectionListModel!
    var service:CollerctionListService = CollerctionListService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        self.service.getMerchantCollectListRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "我的收藏"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            collectionListNoDataView = abnormalView
            collectionListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            collectionListAbnormalView = abnormalView
            collectionListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            collectionListAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.getMerchantCollectListRequest(target: self!)
            }
        }
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(CollectionListTabcell.self, forCellReuseIdentifier: "CollectionListTabcell")
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [unowned self] in
            self.service.refreshCollectionListData(target: self)
            if self.mainTabView.mj_footer != nil {
                self.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return collectionListModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  CollectionListTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CollectionListTabcell")
        if cell == nil {
            cell = CollectionListTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "CollectionListTabcell")
        }
        if let targetCell = cell as? CollectionListTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: collectionListModel.cellModelArr[indexPath.row])
            
            if indexPath.row == collectionListModel.cellModelArr.count - 1 {
                targetCell.seperateView.isHidden = true
            }else{
                targetCell.seperateView.isHidden = false
            }
            
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.service.deleteCollectionRequest(collectionID: collectionListModel.cellModelArr[indexPath.row].UserFavoriteID, successAct: { [weak self] in
            DispatchQueue.main.async {
                self?.mainTabView.mj_header.beginRefreshing()
            }
        }) {
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerVC = SellerDetailPageVC()
        sellerVC.merchantID = collectionListModel.cellModelArr[indexPath.row].MerchantID
        self.navigationController?.pushViewController(sellerVC, animated: true)
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
