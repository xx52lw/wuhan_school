//
//  ChooseStaffVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/23.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class ChooseStaffVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias SelectedFinishAct = ()->Void
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableHeaderView:UIView!
    var unchooseStaffBtn:UIButton!
    
    var staffModelArr:[MerchantStaffListModel] = Array()
    var selectedFinishAct:SelectedFinishAct!
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
        topView.titleLabel.text = "商家配送员"
    }
    

    
    
    func createTableHeaderView(){
        
        let headerViewHeight = cmSizeFloat(7+50)
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerViewHeight))
        
        unchooseStaffBtn = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: cmSizeFloat(50)))
        unchooseStaffBtn.setTitle("不选择，返回", for: .normal)
        unchooseStaffBtn.setTitleColor(MAIN_BLACK, for: .normal)
        unchooseStaffBtn.titleLabel?.font = cmSystemFontWithSize(14)
        unchooseStaffBtn.addTarget(self, action: #selector(unchooseStaffBtnAct), for: .touchUpInside)
        tableHeaderView.addSubview(unchooseStaffBtn)
        
        
        seperateLine = XYCommonViews.creatCustomSeperateLine(pointY: unchooseStaffBtn.bottom, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        tableHeaderView.addSubview(seperateLine)
        
        
        
    }
    
    
    //MARK: - 不选择配送员响应
    @objc func unchooseStaffBtnAct() {

        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? MerchantCurrentOrderDetailVC {
            for index  in 0..<lastVC.oderDetailModel.staffListModelArr.count {
                lastVC.oderDetailModel.staffListModelArr[index].isSelected = false
            }
            lastVC.oderDetailModel.chooseStaffModel = nil
            lastVC.refreshSubviewUI()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - seperateLine.bottom), style: .plain)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        mainTabView.tableHeaderView = self.tableHeaderView
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(ChooseStaffTabcell.self, forCellReuseIdentifier: "ChooseStaffTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return staffModelArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  ChooseStaffTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChooseStaffTabcell")
        if cell == nil {
            cell = ChooseStaffTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "ChooseStaffTabcell")
        }
        if let targetCell = cell as? ChooseStaffTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(model: staffModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let navVCCount = self.navigationController!.viewControllers.count
        if  let lastVC = self.navigationController?.viewControllers[navVCCount - 2] as? MerchantCurrentOrderDetailVC {
            for index  in 0..<staffModelArr.count {
                staffModelArr[index].isSelected = false
            }
            staffModelArr[indexPath.row].isSelected = true
            lastVC.oderDetailModel.chooseStaffModel = staffModelArr[indexPath.row]
            lastVC.refreshSubviewUI()
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
