//
//  MerchantOrderManageVC.swift
//  XYGenericFramework
//
//  Created by xiaoyi on 2018/2/10.
//  Copyright © 2018年 xiaoyi. All rights reserved.
//

import UIKit

class MerchantOrderManageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let toside = cmSizeFloat(20)
    
    var topView:XYTopView!
    var segmentBtnsView:UIView!
    var segmentChooseLine:UIView!
    
    var mainTabView:UITableView!
    
    
    var segmentsBtnArr:[UIButton] = Array()
    
    var merchantOrderManageModel:MerchantOrderManageModel!
    var cuurentSelectedTypeTag:Int = 0
    
    var requestTypeModelArr:[MerchantOrderManageRequstTypeModel] = Array()
    var service:MerchantOrderManageService =  MerchantOrderManageService()
    
    //var detailOrderService:OrderDetailService =  OrderDetailService()
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
        service.merchantOrderListDataRequest(target: self, requestTypeModel: requestTypeModelArr[0])
        // Do any additional setup after loading the view.
    }
    
    
    func createRequstTypeModelArr() {
        let requestUrlArr = [merchantCurrentOrderListUrl,merchantDeliveringOrderListUrl,merchantDeliveriedOrderListUrl,merchantNeedReturnOrderListUrl,merchantHasreturnOrderListUrl]
        let requestTypeArr = [MerchantOrderRequestTypeEnum.current,MerchantOrderRequestTypeEnum.delivering,MerchantOrderRequestTypeEnum.hasDeliveried,MerchantOrderRequestTypeEnum.returnOrder,MerchantOrderRequestTypeEnum.hasReturned]
        let segmentBtnStrArr = ["实时订单","配送中","已送达","退单","已退单"]
        
        
        for index in 0..<segmentBtnStrArr.count {
            let typeModel = MerchantOrderManageRequstTypeModel()
            typeModel.requestType = requestTypeArr[index]
            typeModel.requestTypeUrl = requestUrlArr[index]
            typeModel.typeName = segmentBtnStrArr[index]
            requestTypeModelArr.append(typeModel)
        }
    }
    
    //MARK: - 创建navigationView
    func creatNavTopView(){
        topView = XYTopView.creatCustomTopView()
            self.view.addSubview(topView.navigationTitleItem().createLeftBackBtn(target: self, action: nil))
            topView.titleLabel.text = "今日订单"
        topView.backgroundColor = cmColorWithString(colorName: MAIN_BLUE_STR)
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
                self?.service.merchantOrderListDataRequest(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
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
        self.service.merchantOrderListDataRequest(target: self, requestTypeModel: self.requestTypeModelArr[cuurentSelectedTypeTag])
        
    }
    
    
    // MARK: - 创建tableview
    func creatMainTabView(){
        mainTabView = UITableView(frame: CGRect(x:0,y:segmentBtnsView.bottom, width:SCREEN_WIDTH, height:SCREEN_HEIGHT - segmentBtnsView.bottom), style: .grouped)
        if #available(iOS 11, *) {
            mainTabView.contentInsetAdjustmentBehavior = .never
        }
                mainTabView.mj_header = XYRefreshHeader(refreshingBlock: { [weak self] in
                    self?.service.refreshMerchantOrderListData(target: self!, requestTypeModel: self!.requestTypeModelArr[self!.cuurentSelectedTypeTag])
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
        mainTabView.register(MerchantDeliveriedOrderListTabCell.self, forCellReuseIdentifier: "MerchantDeliveriedOrderListTabCell")
        mainTabView.register(MerchantCurrentOrderListTabcell.self, forCellReuseIdentifier: "MerchantCurrentOrderListTabcell")
        mainTabView.register(MerchantDeliveringOrderListTabCell.self, forCellReuseIdentifier: "MerchantDeliveringOrderListTabCell")
        mainTabView.register(MerchantReturnOrderListTabCell.self, forCellReuseIdentifier: "MerchantReturnOrderListTabCell")
        mainTabView.register(MerchantHasReturnedOrderListTabCell.self, forCellReuseIdentifier: "MerchantHasReturnedOrderListTabCell")
        
        
        self.view.addSubview(mainTabView)
    }
    
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return merchantOrderManageModel.allOrderSectionModelArr.count
    }
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch  merchantOrderManageModel.requestType{
        case .current?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantCurrentOrderModel {
                return currentModel.sectionCellModelArr.count
            }
            break
        case .delivering?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantDeliveringOrderModel {
                return currentModel.sectionCellModelArr.count
            }
            break
        case .hasDeliveried?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantDeliveriedOrderModel {
                return currentModel.sectionCellModelArr.count
            }
            break
        case .returnOrder?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantReturnOrderModel {
                return currentModel.sectionCellModelArr.count
            }
            break
        case .hasReturned?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantHasReturnedOrderModel {
                return currentModel.sectionCellModelArr.count
            }
            break
        default:
            break
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch  merchantOrderManageModel.requestType{
        case .current?:
            return MerchantCurrentOrderListTabcell.cellHeight
        case .delivering?:
            return MerchantDeliveringOrderListTabCell.cellHeight

        case .hasDeliveried?:
            return MerchantDeliveriedOrderListTabCell.cellHeight

        case .returnOrder?:
            return MerchantReturnOrderListTabCell.cellHeight

        case .hasReturned?:
            return MerchantHasReturnedOrderListTabCell.cellHeight

        default:
            return .leastNormalMagnitude
        }
            
            
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch  merchantOrderManageModel.requestType{
        case .current?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantCurrentOrderListTabcell")
            if cell == nil {
                cell = MerchantCurrentOrderListTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantCurrentOrderListTabcell")
            }
            if let targetCell = cell as? MerchantCurrentOrderListTabcell{
                targetCell.selectionStyle = .none
                
                if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantCurrentOrderModel {
                    
                    targetCell.setModel(model: currentModel.sectionCellModelArr[indexPath.row])
                }
                return targetCell
            }
            break
        case .delivering?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantDeliveringOrderListTabCell")
            if cell == nil {
                cell = MerchantDeliveringOrderListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantDeliveringOrderListTabCell")
            }
            if let targetCell = cell as? MerchantDeliveringOrderListTabCell{
                targetCell.selectionStyle = .none
                
                if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantDeliveringOrderModel {
                    
                    targetCell.setModel(model: currentModel.sectionCellModelArr[indexPath.row])
                }
                return targetCell
            }
            break
        case .hasDeliveried?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantDeliveriedOrderListTabCell")
            if cell == nil {
                cell = MerchantDeliveriedOrderListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantDeliveriedOrderListTabCell")
            }
            if let targetCell = cell as? MerchantDeliveriedOrderListTabCell{
                targetCell.selectionStyle = .none
                
                if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantDeliveriedOrderModel {
                    
                    targetCell.setModel(model: currentModel.sectionCellModelArr[indexPath.row])
                }
                return targetCell
            }
            break
        case .returnOrder?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantReturnOrderListTabCell")
            if cell == nil {
                cell = MerchantReturnOrderListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantReturnOrderListTabCell")
            }
            if let targetCell = cell as? MerchantReturnOrderListTabCell{
                targetCell.selectionStyle = .none
                
                if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantReturnOrderModel {
                    
                    targetCell.setModel(model: currentModel.sectionCellModelArr[indexPath.row])
                }
                return targetCell
            }
            break
        case .hasReturned?:
            var cell = tableView.dequeueReusableCell(withIdentifier: "MerchantHasReturnedOrderListTabCell")
            if cell == nil {
                cell = MerchantHasReturnedOrderListTabCell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantHasReturnedOrderListTabCell")
            }
            if let targetCell = cell as? MerchantHasReturnedOrderListTabCell{
                targetCell.selectionStyle = .none
                
                if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantHasReturnedOrderModel {
                    if indexPath.row == currentModel.sectionCellModelArr.count - 1 {
                        targetCell.bottomeSeperateView.isHidden = true
                    }else{
                        targetCell.bottomeSeperateView.isHidden = false
                    }
                    targetCell.setModel(model: currentModel.sectionCellModelArr[indexPath.row])
                }
                return targetCell
            }
            break
        default:
            break
        }
        return MerchantCurrentOrderListTabcell(style: UITableViewCellStyle.default, reuseIdentifier: "MerchantCurrentOrderListTabcell")
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch  merchantOrderManageModel.requestType{
        case .current?:
            return cmSizeFloat(40+7)
        case .delivering?,.hasReturned?,.hasDeliveried?,.returnOrder?:
            return cmSizeFloat(40)
        default:
            return .leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        switch  merchantOrderManageModel.requestType{
        case .current?:
            
            let sectionHeight = cmSizeFloat(40+7)
            let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
            sectionHeaderView.backgroundColor = .white
            
            let seperateView = XYCommonViews.creatCustomSeperateLine(pointY: 0, lineWidth: SCREEN_WIDTH, lineHeight: cmSizeFloat(7))
            sectionHeaderView.addSubview(seperateView)
            
            var sectionOrderAreaStr = ""
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantCurrentOrderModel {
                sectionOrderAreaStr = currentModel.FAreaName
            }
            let adressLabel = UILabel(frame: CGRect(x: toside, y: cmSizeFloat(7), width: SCREEN_WIDTH, height: cmSizeFloat(40)))
            adressLabel.font = cmSystemFontWithSize(13)
            adressLabel.textColor = MAIN_BLACK
            adressLabel.textAlignment = .left
            adressLabel.text = sectionOrderAreaStr
            sectionHeaderView.addSubview(adressLabel)
            return sectionHeaderView
        case .hasReturned?,.delivering?,.hasDeliveried?,.returnOrder?:
            let sectionHeight = cmSizeFloat(40)
            let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
            sectionHeaderView.backgroundColor = seperateLineColor
            
            var sectionTimeStr = ""
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantHasReturnedOrderModel {
                sectionTimeStr = currentModel.Day
            }else if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantDeliveringOrderModel {
                sectionTimeStr = currentModel.Day
            }else if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantDeliveriedOrderModel {
                sectionTimeStr = currentModel.Day
            }else if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[section] as? MerchantReturnOrderModel {
                sectionTimeStr = currentModel.Day
            }
            let timeStrLabel = UILabel(frame: CGRect(x: toside, y: 0, width: SCREEN_WIDTH, height: sectionHeight))
            timeStrLabel.font = cmSystemFontWithSize(13)
            timeStrLabel.textColor = MAIN_BLACK
            timeStrLabel.textAlignment = .left
            timeStrLabel.text = sectionTimeStr
            sectionHeaderView.addSubview(timeStrLabel)
            return sectionHeaderView
        default:
            return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch  merchantOrderManageModel.requestType{
        case .current?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantCurrentOrderModel {
                let currentOrderDetailVC = MerchantCurrentOrderDetailVC()
                currentOrderDetailVC.orderId = currentModel.sectionCellModelArr[indexPath.row].UserOrderID
                self.navigationController?.pushViewController(currentOrderDetailVC, animated: true)
            }

            break
        case .delivering?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantDeliveringOrderModel {
                let deliveringOrderDetailVC = MerchantOrderDeliveringDetailVC()
                deliveringOrderDetailVC.orderId = currentModel.sectionCellModelArr[indexPath.row].UserOrderID
                self.navigationController?.pushViewController(deliveringOrderDetailVC, animated: true)
            }
            break
            
        case .hasDeliveried?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantDeliveriedOrderModel {
                let deliveriedOrderDetailVC = MerchantOrderDeliveriedDetailVC()
                deliveriedOrderDetailVC.orderId = currentModel.sectionCellModelArr[indexPath.row].UserOrderID
                self.navigationController?.pushViewController(deliveriedOrderDetailVC, animated: true)
            }
            break
            
        case .returnOrder?:
            
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantReturnOrderModel {
                let detailService = MerchantOrderDetailService()
                detailService.merchantReturnOrderDetailRequest(userOrderID: currentModel.sectionCellModelArr[indexPath.row].UserOrderID, successAct: {
                    
                }, failureAct: {
                    
                })
            }
            break
            
        case .hasReturned?:
            if let currentModel = merchantOrderManageModel.allOrderSectionModelArr[indexPath.section] as? MerchantHasReturnedOrderModel {
                let hasReturnedOrderDetailVC = MerchantHasReturnOrderDetailVC()
                hasReturnedOrderDetailVC.orderId = currentModel.sectionCellModelArr[indexPath.row].UserOrderID
                self.navigationController?.pushViewController(hasReturnedOrderDetailVC, animated: true)
            }
            break
            
        default:
            break
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.isHidden = true
        
        if mainTabView != nil {
            mainTabView.mj_header.beginRefreshing()
        }
        
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
