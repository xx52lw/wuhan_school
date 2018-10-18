//
//  MerchantOrderEvaluateListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/25.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderEvaluateListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var topView:XYTopView!
    let toside = cmSizeFloat(20)

    var mainTabView:UITableView!
    //网络异常空白页
    public var evaluateListAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var evaluateListNoDataView:XYAbnormalViewManager!
    
    var evaluateListModel:MerchantOrderEvaluateListModel!
    var service:MerchantOrderEvaluateListService = MerchantOrderEvaluateListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        creatNavTopView()
        self.service.merchantOrderEvaluateManagerListDataRequest(target: self)
        // Do any additional setup after loading the view.
    }

    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
        topView.titleLabel.text = "用户评价"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            evaluateListNoDataView = abnormalView
            evaluateListNoDataView.abnormalType = .noData
        }else if isNetError == true{
            evaluateListAbnormalView = abnormalView
            evaluateListAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            evaluateListAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.merchantOrderEvaluateManagerListDataRequest(target: self!)
            }
        }
    }
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:topView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - topView.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
                mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
                    self?.service.refreshmerchantOrderEvaluateListData(target: self!)
                    if self?.mainTabView.mj_footer != nil {
                        self?.mainTabView.mj_footer.resetNoMoreData()
                    }
                })
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(MerchantOrderEvaluateListTabCell.self, forCellReuseIdentifier: "MerchantOrderEvaluateListTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return evaluateListModel.evaluateSectionModelArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return evaluateListModel.evaluateSectionModelArr[section].evaluateCellModelArr.count
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return MerchantOrderEvaluateListTabCell.cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantOrderEvaluateListTabCell")
        if cell == nil {
            cell = MerchantOrderEvaluateListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantOrderEvaluateListTabCell")
        }
        if let targetCell = cell as? MerchantOrderEvaluateListTabCell{
            targetCell.selectionStyle = .none
            
            if indexPath.row == evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr.count - 1 {
                targetCell.bottomeSeperateView.isHidden = true
            }else{
                targetCell.bottomeSeperateView.isHidden = false
            }
            targetCell.setModel(model: evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr[indexPath.row])
            return targetCell
        }else{
            return cell!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return cmSizeFloat(40)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeight = cmSizeFloat(40)
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
        sectionHeaderView.backgroundColor = seperateLineColor
        
        var sectionTimeStr = ""
        
        sectionTimeStr = evaluateListModel.evaluateSectionModelArr[section].Day
        
        let timeStrLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
        timeStrLabel.font = cmSystemFontWithSize(13)
        timeStrLabel.textColor = MAIN_BLACK
        timeStrLabel.textAlignment = .left
        timeStrLabel.text = sectionTimeStr
        sectionHeaderView.addSubview(timeStrLabel)
        return sectionHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let evaluateDetailVC = MerchantEvaluateDetailVC()
        evaluateDetailVC.commentId = evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr[indexPath.row].MerchantCommentID
        evaluateDetailVC.ifShow = evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr[indexPath.row].IfShow
        self.navigationController?.pushViewController(evaluateDetailVC, animated: true)

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr[indexPath.row].IfShow == false {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.service.deleteUserEvaluationRequest(merchantEvaluateID: evaluateListModel.evaluateSectionModelArr[indexPath.section].evaluateCellModelArr[indexPath.row].MerchantCommentID, successAct: { [weak self] in
            DispatchQueue.main.async {
                cmShowHUDToWindow(message: "删除成功")
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
        if mainTabView != nil {
            mainTabView.mj_header.beginRefreshing()
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
