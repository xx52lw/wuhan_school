//
//  StaffSystemSettingHomePageVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/28.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffSystemSettingHomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let toside = cmSizeFloat(20)
    
    var topView:XYTopView!
    var mainTabView:UITableView!
    var tableFooterView:UIView!
    var titleStrArr = [["用户姓名","登录账号","修改密码"],["接单铃声设置","接单震动设置"]]
    
    var staffInfoModel:StaffInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        creatMainTabView()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.createLeftBackBtn(target: self, action: nil).navigationTitleItem())
        topView.titleLabel.text = "系统设置"
    }
    
    //MARK: - 创建footerView
    func createFooterView(){
        let toFooterViewTop = cmSizeFloat(25)
        let btnHeight = cmSizeFloat(38)
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: toFooterViewTop+btnHeight))
        
        let loginOutBtn = UIButton(frame: CGRect(x: 0, y: toFooterViewTop, width: SCREEN_WIDTH, height: btnHeight))
        loginOutBtn.setTitle("退出登录", for: .normal)
        loginOutBtn.setTitleColor(MAIN_BLUE, for: .normal)
        loginOutBtn.titleLabel?.font = cmSystemFontWithSize(15)
        loginOutBtn.backgroundColor = .white
        
        loginOutBtn.addTarget(self, action: #selector(loginOutBtnAct), for: .touchUpInside)
        tableFooterView.addSubview(loginOutBtn)
    }
    
    
    //MARK: - 退出登录
    @objc func loginOutBtnAct(){
        loginOutApp()
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        
        createFooterView()
        
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        //mainTabView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.tableFooterView = tableFooterView
        
        mainTabView.register(StaffSystemSettingTabcell.self, forCellReuseIdentifier: "StaffSystemSettingTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleStrArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleStrArr[section].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  StaffSystemSettingTabcell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "StaffSystemSettingTabcell")
        if cell == nil {
            cell = StaffSystemSettingTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "StaffSystemSettingTabcell")
        }
        if let targetCell = cell as? StaffSystemSettingTabcell{
            targetCell.selectionStyle = .none
            targetCell.setModel(titleStr: titleStrArr[indexPath.section][indexPath.row])
            
            if titleStrArr[indexPath.section][indexPath.row] == "接单铃声设置" {
                if isStaffOrderUseBell() == true {
                    targetCell.showMoreTextField.text = MerchantOrderBellSettingEnum.userBell.rawValue
                }else{
                    targetCell.showMoreTextField.text = MerchantOrderBellSettingEnum.unuseBell.rawValue
                }
            }else if titleStrArr[indexPath.section][indexPath.row] == "接单震动设置" {
                if isStaffOrderUseVibrate() == true {
                    targetCell.showMoreTextField.text = MerchantOrderVibrateSettingEnum.userVibrate.rawValue
                }else{
                    targetCell.showMoreTextField.text = MerchantOrderVibrateSettingEnum.unuseVibrate.rawValue
                }
            }else if titleStrArr[indexPath.section][indexPath.row] == "用户姓名" {
                if staffInfoModel != nil {
                    targetCell.showMoreTextField.text = staffInfoModel.StaffName
                }else{
                    targetCell.showMoreTextField.text = ""
                }
            }else if titleStrArr[indexPath.section][indexPath.row] == "登录账号" {
                if staffInfoModel != nil {
                    targetCell.showMoreTextField.text = staffInfoModel.Phone
                }else{
                    targetCell.showMoreTextField.text = ""
                }
            }else{
                targetCell.showMoreTextField.text =  ""
            }
            
            if titleStrArr[indexPath.section][indexPath.row] == "用户姓名" ||  titleStrArr[indexPath.section][indexPath.row] == "登录账号"{
                targetCell.showMoreTextField.rightViewMode = .never
                targetCell.showMoreTextField.frame.size.width = SCREEN_WIDTH -  cmSizeFloat(20)
            }else{
                targetCell.showMoreTextField.rightViewMode = .always
                targetCell.showMoreTextField.frame.size.width = SCREEN_WIDTH
            }
            
            
            return targetCell
        }else{
            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != titleStrArr.count - 1 {
            return cmSizeFloat(7)
        }else{
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != titleStrArr.count - 1 {
            return XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
        }else{
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch  indexPath.section{
        case 0:
            
            if   indexPath.row  == 2 {
                let passwordModifyVC = StaffPasswordModifyVC()
                self.navigationController?.pushViewController(passwordModifyVC, animated: true)
            }
            
            break
        case 1:
            if   indexPath.row  == 0 {
                let bellSettingVC = StaffOrderBellSettingVC()
                self.navigationController?.pushViewController(bellSettingVC, animated: true)
                
            }else  if   indexPath.row  == 1 {
                let vibrateSettingVC = StaffVibrateSettingVC()
                self.navigationController?.pushViewController(vibrateSettingVC, animated: true)
            }
            break
        default:
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        tabBarController?.tabBar.isHidden = true
        
        //如果铃声设置等有改变需要刷新界面
        if mainTabView != nil {
            mainTabView.reloadData()
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
