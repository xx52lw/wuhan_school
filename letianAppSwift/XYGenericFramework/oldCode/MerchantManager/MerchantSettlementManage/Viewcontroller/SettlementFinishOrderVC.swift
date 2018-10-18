//
//  SettlementFinishOrderVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementFinishOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    var mainTabView:UITableView!
    //网络异常空白页
    public var finishOrderAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var finishOrderNoDataView:XYAbnormalViewManager!
    
    var finishOrderModel:SettlementFinishOrderListModel!
    
    var service:MerchantSettlementFinishOrderService = MerchantSettlementFinishOrderService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        service.settlementFinishWeekDataRequest(target: self)
        // Do any additional setup after loading the view.
    }

    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "已完成订单"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            finishOrderNoDataView = abnormalView
            finishOrderNoDataView.abnormalType = .noData
        }else if isNetError == true{
            finishOrderAbnormalView = abnormalView
            finishOrderAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            finishOrderAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.settlementFinishWeekDataRequest(target: self!)
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
        mainTabView.register(SettlementFinishOrderTabcell.self, forCellReuseIdentifier: "SettlementFinishOrderTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return finishOrderModel.finishOrderSettlementCellModelArr.count
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  SettlementFinishOrderTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettlementFinishOrderTabcell")
        if cell == nil {
            cell = SettlementFinishOrderTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "SettlementFinishOrderTabcell")
        }
        if let targetCell = cell as? SettlementFinishOrderTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: finishOrderModel.finishOrderSettlementCellModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let finishDayVC = SettlementDayListVC()
            finishDayVC.dayRange = finishOrderModel.finishOrderSettlementCellModelArr[indexPath.row].Start + finishOrderModel.finishOrderSettlementCellModelArr[indexPath.row].End
            self.navigationController?.pushViewController(finishDayVC, animated: true)
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
