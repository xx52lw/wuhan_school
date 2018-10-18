//
//  StaffManageListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/24.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffManageListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let toside = cmSizeFloat(20)
    
    var topView:XYTopView!
    var addStaffBtn:UIButton!
    var mainTabView:UITableView!

    //网络异常空白页
    public var staffManagerAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var staffManagerNoDataView:XYAbnormalViewManager!
    
    var staffManagerModel:StaffManageListModel!
    
    var service:StaffManageListService =  StaffManageListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        createAddBtn()
        self.service.staffManagerListDataRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "配送员管理"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            staffManagerNoDataView = abnormalView
            staffManagerNoDataView.abnormalType = .noData
        }else if isNetError == true{
            staffManagerAbnormalView = abnormalView
            staffManagerAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            staffManagerAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.staffManagerListDataRequest(target: self!)
            }
        }
    }
    
    //MARK: - 创建新增配送员按钮
    func createAddBtn() {
        addStaffBtn = UIButton(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height: cmSizeFloat(44)))
        addStaffBtn.setTitle("新增配送员", for: .normal)
        addStaffBtn.setTitleColor(MAIN_BLUE, for: .normal)
        addStaffBtn.titleLabel?.font = cmSystemFontWithSize(14)
        addStaffBtn.addTarget(self, action: #selector(addStaffBtnAct), for: .touchUpInside)
        
        
        let seperateLine = XYCommonViews.creatCommonSeperateLine(pointY: addStaffBtn.frame.size.height - cmSizeFloat(1))
        addStaffBtn.addSubview(seperateLine)
        
        
        self.view.addSubview(addStaffBtn)
        
        
    }
    
    //MARK: - 新增配送员响应
    @objc func addStaffBtnAct(){
        
        let addStaffVC = AddNewStaffVC()
        self.navigationController?.pushViewController(addStaffVC, animated: true)
        
    }
    
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:addStaffBtn.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - addStaffBtn.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
        
        mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [unowned self] in
            self.service.refreshStaffManagerListData(target: self)
            if self.mainTabView.mj_footer != nil {
                self.mainTabView.mj_footer.resetNoMoreData()
            }
        })
        
        mainTabView.showsVerticalScrollIndicator = false
        mainTabView.showsHorizontalScrollIndicator = false
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(StaffManageListTabCell.self, forCellReuseIdentifier: "StaffManageListTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return staffManagerModel.usefulStaffModelArr.count
        case 1:
            return staffManagerModel.unusefulStaffModelArr.count
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  StaffManageListTabCell.cellHeight
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "StaffManageListTabCell")
        if cell == nil {
            cell = StaffManageListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "StaffManageListTabCell")
        }
        if let targetCell = cell as? StaffManageListTabCell{
            targetCell.selectionStyle = .none
            
            switch indexPath.section {
            case 0:
                targetCell.setModel(model: staffManagerModel.usefulStaffModelArr[indexPath.row])
                break
            case 1:
                targetCell.setModel(model:  staffManagerModel.unusefulStaffModelArr[indexPath.row])
                break
            default:
                break
            }
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
        
        switch section {
        case 0:
            sectionLabel.textColor = MAIN_BLUE
            sectionLabel.text = "可用配送员"
            break
        case 1:
            sectionLabel.textColor = MAIN_GRAY
            sectionLabel.text = "不可用配送员"
            break
        default:
            break
        }
        sectionView.addSubview(sectionLabel)
        return sectionView
    }
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var staffID:Int!
        switch indexPath.section {
        case 0:
            staffID = staffManagerModel.usefulStaffModelArr[indexPath.row].DStaffID
            break
        case 1:
            staffID = staffManagerModel.unusefulStaffModelArr[indexPath.row].DStaffID
            break
        default:
            break
        }
        
        
        self.service.deleteMerchantStaffRequest(DStaffID: staffID, successAct: { [weak self] in
            
            DispatchQueue.main.async {
               self?.mainTabView.mj_header.beginRefreshing()
            }
            
        }) {
            
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
