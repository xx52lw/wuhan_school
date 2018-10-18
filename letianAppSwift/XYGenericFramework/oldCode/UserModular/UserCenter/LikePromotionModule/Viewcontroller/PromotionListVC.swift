//
//  PromotionListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/1.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class PromotionListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private  var topView:XYTopView!
    public var mainTabView:UITableView!

    //网络异常空白页
    public var promotionListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var promotionListNoDataView:XYAbnormalViewManager!
    
    var promotionListModel:PromotionListModel!
    var service:PromotionListService = PromotionListService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        service.getUserPromotionListRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "商家代金券"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            promotionListNoDataView = abnormalView
            promotionListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            promotionListAbnormalView = abnormalView
            promotionListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            promotionListAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.getUserPromotionListRequest(target: self!)
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
        mainTabView.register(PromotionListTabcell.self, forCellReuseIdentifier: "PromotionListTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return promotionListModel.cellModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  PromotionListTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "PromotionListTabcell")
        if cell == nil {
            cell = PromotionListTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "PromotionListTabcell")
        }
        if let targetCell = cell as? PromotionListTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: promotionListModel.cellModelArr[indexPath.row], index: indexPath.row)
            return targetCell
        }else{
            return cell!
        }
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
