//
//  SettlementOrderListhVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class SettlementOrderListhVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableheaderView:UIView!
    //网络异常空白页
    public var dayOrderAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var dayOrderNoDataView:XYAbnormalViewManager!
    
    var dayOrderListModel:SettlementFinishDayDetailModel!
    
    var service:SettlementFinishDayDetailService = SettlementFinishDayDetailService()
    var dayStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        service.settlementDayDetailOrderDataRequest(target: self, dayStr: dayStr)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "订单列表"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建headerView
    func createHeaderView(){
        
        var dataStr = "20"
        for index in 0..<dayOrderListModel.Day.count {
            dataStr += dayOrderListModel.Day[index..<index+1]
            if  (index+1)%2 == 0 && index != dayOrderListModel.Day.count - 1{
                dataStr += "-"
            }
        }
        
        tableheaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(50+7)))
        
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(50)))
        headerLabel.font = cmSystemFontWithSize(15)
        headerLabel.textColor = MAIN_BLACK
        headerLabel.textAlignment = .center
        headerLabel.text = dataStr + "  商家收入¥" + moneyExchangeToString(moneyAmount: dayOrderListModel.Money)
        tableheaderView.addSubview(headerLabel)
        
        tableheaderView.addSubview(XYCommonViews.creatCustomSeperateLine(pointY: headerLabel.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7)))
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            dayOrderNoDataView = abnormalView
            dayOrderNoDataView.abnormalType = .noData
        }else if isNetError == true{
            dayOrderAbnormalView = abnormalView
            dayOrderAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            dayOrderAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.settlementDayDetailOrderDataRequest(target: self!, dayStr: self!.dayStr)
            }
        }
    }
    
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        createHeaderView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        
        mainTabView.tableHeaderView = self.tableheaderView
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(SettlementFinishDayDetailTabcell.self, forCellReuseIdentifier: "SettlementFinishDayDetailTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dayOrderListModel.finishDayDetailCellModelArr.count
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  SettlementFinishDayDetailTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettlementFinishDayDetailTabcell")
        if cell == nil {
            cell = SettlementFinishDayDetailTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "SettlementFinishDayDetailTabcell")
        }
        if let targetCell = cell as? SettlementFinishDayDetailTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: dayOrderListModel.finishDayDetailCellModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
