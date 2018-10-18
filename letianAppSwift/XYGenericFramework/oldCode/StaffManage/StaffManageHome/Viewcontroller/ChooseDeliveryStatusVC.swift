//
//  ChooseDeliveryStatusVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ChooseDeliveryStatusVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let toside = cmSizeFloat(20)
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var unchooseStaffBtn:UIButton!
    var sectionStrArr = ["已收货情况","未收货情况"]
    var deliveryStatusArr = [["已签收","委托代收","指定地点","其他"],["未联系上","拒收","其他"]]
    var seperateLine:UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createTableHeaderView()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "送达状态选择"
    }
    
    
    
    
    func createTableHeaderView(){
        
        let headerViewHeight = cmSizeFloat(7+50)
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerViewHeight))
        
        unchooseStaffBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(50)))
        unchooseStaffBtn.setTitle("不选择，返回", for: .normal)
        unchooseStaffBtn.setTitleColor(MAIN_BLACK, for: .normal)
        unchooseStaffBtn.titleLabel?.font = cmSystemFontWithSize(14)
        unchooseStaffBtn.addTarget(self, action: #selector(unchooseStaffBtnAct), for: .touchUpInside)
        unchooseStaffBtn.backgroundColor = .white
        tableHeaderView.addSubview(unchooseStaffBtn)
        
        
        seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: unchooseStaffBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        tableHeaderView.addSubview(seperateLine)
        
        
        
    }
    
    
    //MARK: - 不选择配送员响应
    @objc func unchooseStaffBtnAct() {
        
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? StaffOrderDetailVC {
            lastVC.chooseStatusTextField.text = ""
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - seperateLine.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.tableHeaderView = self.tableHeaderView
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(ChooseDeliveryStatusTabcell.self, forCellReuseIdentifier: "ChooseDeliveryStatusTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionStrArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deliveryStatusArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  ChooseDeliveryStatusTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDeliveryStatusTabcell")
        if cell == nil {
            cell = ChooseDeliveryStatusTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "ChooseDeliveryStatusTabcell")
        }
        if let targetCell = cell as? ChooseDeliveryStatusTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(statusStr: deliveryStatusArr[indexPath.section][indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return cmSizeFloat(7)
        }else{
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        }else{
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cmSizeFloat(50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(40)))
        sectionView.backgroundColor = .white
        let sectionLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH - toside*2, height: cmSizeFloat(50)))
        sectionLabel.textAlignment = .left
        sectionLabel.font = cmBoldSystemFontWithSize(15)
        sectionLabel.text = sectionStrArr[section]
        sectionLabel.textColor = MAIN_BLUE
        sectionView.addSubview(sectionLabel)
        
        sectionView.addSubview(XYCommonViews.creatCommonSeperateLine(pointY:sectionView.frame.size.height - cmSizeFloat(1)))
        
        return sectionView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? StaffOrderDetailVC {
            lastVC.chooseStatusTextField.text = deliveryStatusArr[indexPath.section][indexPath.row]
            self.navigationController?.popViewController(animated: true)
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
