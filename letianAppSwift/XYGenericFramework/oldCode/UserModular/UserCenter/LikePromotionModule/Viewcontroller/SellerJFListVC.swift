//
//  SellerJFListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SellerJFListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private  var topView:XYTopView!
    public var mainTabView:UITableView!
    
    //网络异常空白页
    public var sellerJFListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var sellerJFListNoDataView:XYAbnormalViewManager!
    
    var sellerJFListModel:SellerJFListModel!
    var service:SellerJFListService = SellerJFListService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        self.service.getUserJFListRequest(target: self)
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "商家积分"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            sellerJFListNoDataView = abnormalView
            sellerJFListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            sellerJFListAbnormalView = abnormalView
            sellerJFListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            sellerJFListAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.getUserJFListRequest(target: self!)
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
        mainTabView.register(SellerJFListTabcell.self, forCellReuseIdentifier: "SellerJFListTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sellerJFListModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  SellerJFListTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SellerJFListTabcell")
        if cell == nil {
            cell = SellerJFListTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "SellerJFListTabcell")
        }
        if let targetCell = cell as? SellerJFListTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: sellerJFListModel.cellModelArr[indexPath.row])
            if indexPath.row == sellerJFListModel.cellModelArr.count - 1 && sellerJFListModel.cellModelArr.count > 1{
                targetCell.seperateView.isHidden = true
            }else{
                targetCell.seperateView.isHidden = false
            }
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerVC = SellerDetailPageVC()
        sellerVC.merchantID = self.sellerJFListModel.cellModelArr[indexPath.row].MerchantID
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
