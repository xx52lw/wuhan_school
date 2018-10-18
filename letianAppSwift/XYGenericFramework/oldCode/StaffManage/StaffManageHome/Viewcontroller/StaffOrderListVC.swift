//
//  StaffOrderListVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/26.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class StaffOrderListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let toside = cmSizeFloat(20)
    
    var topView:XYTopView!
    var segmentBtnsView:UIView!
    var segmentChooseLine:UIView!
    
    var mainTabView:UITableView!
    
    
    var segmentsBtnArr:[UIButton] = Array()
    
    var staffOrderManageModel:StaffOrderListModel!
    var cuurentSelectedTypeTag:Int = 0
    
    var requestTypeModelArr:[StaffOrderManageRequstTypeModel] = Array()
    var service:StaffOrderListService =  StaffOrderListService()
    var staffInfoModel:StaffInfoModel!
    
    //网络异常空白页
    public var orderManagerAbnormalView:XYAbnormalViewManager!
    //无数据页
    public var orderManagerNoDataView:XYAbnormalViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        createRequstTypeModelArr()
        creatNavTopView()
        creatSegmentBtn()
        service.staffOrderListDataRequest(target: self, requestTypeModel: requestTypeModelArr[0])
        //获取配送员信息
        service.getStaffSystemInfoRequest(target: self)
        // Do any additional setup after loading the view.
    }
    
    
    func createRequstTypeModelArr() {
        let requestUrlArr = [staffOrderWaiteDeliveryUrl,staffOrderDeliveriedUrl]
        let requestTypeArr = [StaffOrderRequestTypeEnum.waiteToDelivery,StaffOrderRequestTypeEnum.hasDeliveried]
        let segmentBtnStrArr = ["订单配送","已送达"]
        
        
        for index in 0..<segmentBtnStrArr.count {
            let typeModel = StaffOrderManageRequstTypeModel()
            typeModel.requestType = requestTypeArr[index]
            typeModel.requestTypeUrl = requestUrlArr[index]
            typeModel.typeName = segmentBtnStrArr[index]
            requestTypeModelArr.append(typeModel)
        }
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
        self.view.addSubview(topView.navigationTitleItem().rightStrBtnItem(target: self, action: #selector(settingAct), btnStr: "设置", fontSize: 15))
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
    }
    
    //MARK: - 系统设置按钮响应
    @objc func settingAct(){
        let systemSettingVC = StaffSystemSettingHomePageVC()
        if self.staffInfoModel != nil {
            systemSettingVC.staffInfoModel = self.staffInfoModel
        }
        self.navigationController?.pushViewController(systemSettingVC, animated: true)
    }
    
    
    //MARK: - 创建异常页面
    public func creatAbnormalView(isNetError:Bool){
        let abnormalView = XYAbnormalViewManager(frame: CGRect(x:0  , y:isNetError ? topView.bottom:0 , width: SCREEN_WIDTH, height: isNetError ? SCREEN_HEIGHT-STATUS_NAV_HEIGHT:self.mainTabView.frame.size.height), in: isNetError ? self.view:self.mainTabView)
        
        if isNetError == false{
            orderManagerNoDataView = abnormalView
            orderManagerNoDataView.abnormalType = .noData
        }else if isNetError == true{
            orderManagerAbnormalView = abnormalView
            orderManagerAbnormalView.abnormalType = .networkError
            //数据错误刷新Act
            orderManagerAbnormalView.refreshActionBlock = {[weak self] in
                self?.service.staffOrderListDataRequest(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
                 self?.service.getStaffSystemInfoRequest(target: self!)

            }
        }
    }
    
    
    //MARK: - 创建分段按钮
    func creatSegmentBtn(){
        let segmentBtnsViewHeight = cmSizeFloat(40)
        segmentBtnsView = UIView(frame: CGRect(x: 0, y: topView.bottom, width: SCREEN_WIDTH, height:segmentBtnsViewHeight + cmSizeFloat(10) ))
        for index in 0..<requestTypeModelArr.count {
            
            let segmentBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count)*CGFloat(index), y: 0, width: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count), height: segmentBtnsViewHeight))
            segmentBtn.setTitle(requestTypeModelArr[index].typeName, for: .normal)
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
            if index == 0{
                segmentBtn.setTitleColor(MAIN_BLUE, for: .normal)
            }
            segmentBtn.titleLabel?.font = cmSystemFontWithSize(15)
            segmentBtn.tag = 200 + index
            segmentBtn.addTarget(self, action: #selector(segmentAct(sender:)), for: .touchUpInside)
            segmentsBtnArr.append(segmentBtn)
            segmentBtnsView.addSubview(segmentBtn)
            
            
        }
        
        segmentChooseLine = UIView(frame: CGRect(x: 0, y: segmentBtnsViewHeight + cmSizeFloat(10) - cmSizeFloat(9), width: SCREEN_WIDTH/CGFloat(requestTypeModelArr.count), height: cmSizeFloat(2)))
        segmentChooseLine.backgroundColor = MAIN_BLUE
        segmentBtnsView.addSubview(segmentChooseLine)
        
        
        self.view.addSubview(segmentBtnsView)
        
    }
    //MARK: - 分段按钮响应
    @objc func segmentAct(sender:UIButton){
        for segmentBtn in segmentsBtnArr {
            segmentBtn.setTitleColor(MAIN_BLACK, for: .normal)
        }
        sender.setTitleColor(MAIN_BLUE, for: .normal)
        segmentChooseLine.frame.origin.x = SCREEN_WIDTH/CGFloat(requestTypeModelArr.count)*CGFloat(sender.tag - 200)
        
        //如果点击同一个btn，不做数据请求处理
        if cuurentSelectedTypeTag == sender.tag - 200{
            return
        }
        
        cuurentSelectedTypeTag = sender.tag - 200
        self.service.staffOrderListDataRequest(target: self, requestTypeModel: self.requestTypeModelArr[cuurentSelectedTypeTag])
        
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:segmentBtnsView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsView.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
                mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
                    self?.service.refreshStaffOrderListData(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
                    if self?.mainTabView.mj_footer != nil {
                        self?.mainTabView.mj_footer.resetNoMoreData()
                    }
                })
        //        mainTabView.mj_footer = XYRefreshFooter(refreshingBlock: { [weak self] in
        //            self?.service.orderManagerListPullData(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
        //        })
        
        mainTabView.separatorStyle = .none
        mainTabView.delegate = self
        mainTabView.dataSource = self
        mainTabView.register(StaffDeliveriedOrderTabcell.self, forCellReuseIdentifier: "StaffDeliveriedOrderTabcell")
        mainTabView.register(StaffWaiteToDeliveryTabcell.self, forCellReuseIdentifier: "StaffWaiteToDeliveryTabcell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return staffOrderManageModel.orderSectionModelArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        
        return staffOrderManageModel.orderSectionModelArr[section].orderCellModelArr.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let recieverTitleStrMaxWidth = "下单时间: ".stringWidth(cmSingleLineHeight(fontSize: cmSystemFontWithSize(13)), font: cmSystemFontWithSize(13))
        
        
        let recieverInfoStr = staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row].ReceiverName + "  " + staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row].RecieverPhone + "  " + staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row].Address
        
        let recieverInfoStrHeight = recieverInfoStr.stringHeight(SCREEN_WIDTH - recieverTitleStrMaxWidth - toside*2, font: cmSystemFontWithSize(13))
        
        switch  staffOrderManageModel.requestType{
        case .waiteToDelivery?:
            return StaffWaiteToDeliveryTabcell.cellHeight + recieverInfoStrHeight
        case .hasDeliveried?:
            return StaffDeliveriedOrderTabcell.cellHeight  + recieverInfoStrHeight
            
        default:
            return .leastNormalMagnitude
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch  staffOrderManageModel.requestType{
        case .waiteToDelivery?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "StaffWaiteToDeliveryTabcell")
            if cell == nil {
                cell = StaffWaiteToDeliveryTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "StaffWaiteToDeliveryTabcell")
            }
            if let targetCell = cell as? StaffWaiteToDeliveryTabcell{
                targetCell.selectionStyle = .none
                    targetCell.setModel(model: staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row])
                return targetCell
            }
            break

        case .hasDeliveried?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "StaffDeliveriedOrderTabcell")
            if cell == nil {
                cell = StaffDeliveriedOrderTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "StaffDeliveriedOrderTabcell")
            }
            if let targetCell = cell as? StaffDeliveriedOrderTabcell{
                targetCell.selectionStyle = .none
                    targetCell.setModel(model: staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row])
                return targetCell
            }
            break
        default:
            break
        }
        return StaffWaiteToDeliveryTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "StaffWaiteToDeliveryTabcell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cmSizeFloat(35+7)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeight = cmSizeFloat(35+7)
            let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
            sectionHeaderView.backgroundColor = .white
            
            let seperateView = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            sectionHeaderView.addSubview(seperateView)
            
            let sectionOrderAreaStr = staffOrderManageModel.orderSectionModelArr[section].FAreaName
        
            let adressLabel = UILabel(frame: CGRect(x: toside, y: cmSizeFloat(7), width: SCREEN_WIDTH, height: cmSizeFloat(35)))
            adressLabel.font = cmSystemFontWithSize(13)
            adressLabel.textColor = MAIN_BLACK
            adressLabel.textAlignment = .left
            adressLabel.text = sectionOrderAreaStr
            sectionHeaderView.addSubview(adressLabel)
            return sectionHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let orderDetailVC = StaffOrderDetailVC()
            orderDetailVC.orderId = staffOrderManageModel.orderSectionModelArr[indexPath.section].orderCellModelArr[indexPath.row].UserOrderID
            self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isHidden = true
        //禁止系统手势右滑返回
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
